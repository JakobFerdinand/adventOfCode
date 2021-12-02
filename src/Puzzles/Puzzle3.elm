module Puzzles.Puzzle3 exposing (solve)


solve : String -> String
solve input =
    input
        |> String.split "\n"
        |> List.map parseMove
        |> List.filterMap (\m -> m)
        |> calculateTotalPosition
        |> String.fromInt


type Move
    = Forward Int
    | Down Int
    | Up Int


parseMove : String -> Maybe Move
parseMove line =
    let
        words =
            line
                |> String.split " "
                |> List.filter (\w -> String.isEmpty w == False)

        movement =
            words |> List.head

        steps =
            words
                |> List.drop 1
                |> List.head
                |> Maybe.andThen String.toInt

        movementToMove : String -> Maybe (Int -> Move)
        movementToMove m =
            case m of
                "forward" ->
                    Just Forward

                "down" ->
                    Just Down

                "up" ->
                    Just Up

                _ ->
                    Nothing
    in
    movement
        |> Maybe.andThen movementToMove
        |> Maybe.map2 (\s f -> f s) steps


calculateTotalPosition : List Move -> Int
calculateTotalPosition moves =
    let
        horizontal =
            moves
                |> List.filterMap
                    (\m ->
                        case m of
                            Forward forward ->
                                Just forward

                            _ ->
                                Nothing
                    )
                |> List.sum

        down =
            moves
                |> List.filterMap
                    (\m ->
                        case m of
                            Down d ->
                                Just d

                            _ ->
                                Nothing
                    )
                |> List.sum

        up =
            moves
                |> List.filterMap
                    (\m ->
                        case m of
                            Up u ->
                                Just u

                            _ ->
                                Nothing
                    )
                |> List.sum

        depth =
            down - up
    in
    horizontal * depth
