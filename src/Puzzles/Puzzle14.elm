module Puzzles.Puzzle14 exposing (solve)


solve : String -> String
solve input =
    let
        positions =
            input
                |> String.split ","
                |> List.filterMap String.toInt

        maxPosition =
            positions |> List.maximum |> Maybe.withDefault 0

        allPossiblePositions =
            List.range 0 maxPosition
    in
    allPossiblePositions
        |> List.map (calcFuelNeed positions)
        |> List.minimum
        |> Maybe.withDefault 0
        |> String.fromInt


calcDistanceTo : Int -> Int -> Int
calcDistanceTo to from =
    abs (from - to)


calcCost : Int -> Int
calcCost distance =
    case distance of
        0 ->
            0

        _ ->
            (distance * (distance + 1)) // 2


calcFuelNeed : List Int -> Int -> Int
calcFuelNeed positions to =
    positions
        |> List.map (calcDistanceTo to)
        |> List.map calcCost
        |> List.sum
