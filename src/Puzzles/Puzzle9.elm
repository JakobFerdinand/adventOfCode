module Puzzles.Puzzle9 exposing (solve)

import List.Extra as ListE


solve : String -> String
solve input =
    input
        |> String.split "\n"
        |> List.map (String.split " -> ")
        |> List.filterMap prepareVector
        |> List.filterMap parseVector
        |> List.filter xOrYEqual
        |> process []
        |> List.filter (\p -> p.counter >= 2)
        |> List.length
        |> String.fromInt


type alias PointCounter =
    { counter : Int
    , point : Point
    }


process : List PointCounter -> List Vector -> List PointCounter
process knownPointCounters vectors =
    case vectors |> List.head of
        Just vector ->
            let
                points =
                    vector |> expand

                existingPoints =
                    points |> List.filter (\p -> (knownPointCounters |> List.filter (\kp -> kp.point == p) |> List.length) /= 0)

                notExistingProjects =
                    points |> List.filter (\p -> (knownPointCounters |> List.filter (\kp -> kp.point == p) |> List.length) == 0)

                updatedPoints =
                    knownPointCounters
                        |> ListE.updateIf (\kp -> existingPoints |> List.member kp.point) (\kp -> { kp | counter = kp.counter + 1 })
            in
            process
                (updatedPoints ++ (notExistingProjects |> List.map (PointCounter 1)))
                (vectors |> List.drop 1)

        Nothing ->
            knownPointCounters


xOrYEqual : Vector -> Bool
xOrYEqual v =
    v.from.x == v.to.x || v.from.y == v.to.y


prepareVector : List String -> Maybe ( String, String )
prepareVector input =
    let
        from =
            input |> List.head

        to =
            input |> List.drop 1 |> List.head
    in
    Maybe.map2 Tuple.pair from to


type alias Point =
    { x : Int
    , y : Int
    }


type alias Vector =
    { from : Point
    , to : Point
    }


parseVector : ( String, String ) -> Maybe Vector
parseVector ( from, to ) =
    let
        numbers value =
            value |> String.split ","

        x value =
            value |> numbers |> List.head |> Maybe.andThen String.toInt

        y value =
            value |> numbers |> List.drop 1 |> List.head |> Maybe.andThen String.toInt

        parsePoint value =
            Maybe.map2 Point (x value) (y value)
    in
    Maybe.map2 Vector
        (parsePoint from)
        (parsePoint to)


expand : Vector -> List Point
expand vector =
    let
        xIsEqual =
            vector.from.x == vector.to.x

        smallerFirst a b =
            if a < b then
                ( a, b )

            else
                ( b, a )
    in
    if xIsEqual then
        let
            sorted =
                smallerFirst vector.from.y vector.to.y

            from =
                sorted |> Tuple.first

            to =
                sorted |> Tuple.second
        in
        List.range from to
            |> List.map (\y -> Point vector.from.x y)

    else
        let
            sorted =
                smallerFirst vector.from.x vector.to.x

            from =
                sorted |> Tuple.first

            to =
                sorted |> Tuple.second
        in
        List.range from to
            |> List.map (\x -> Point x vector.from.y)
