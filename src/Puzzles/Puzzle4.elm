module Puzzles.Puzzle4 exposing (solve)


solve : String -> String
solve input =
    input
        |> String.split "\n"
        |> List.map parseMove
        |> List.filterMap (\m -> m)
        |> calculateTotalPosition
        |> calculateResult
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


type alias Position =
    { horizontal : Int
    , depth : Int
    , aim : Int
    }


calculatePosition : Move -> Position -> Position
calculatePosition move currentPosition =
    case move of
        Forward forward ->
            { currentPosition
                | horizontal = currentPosition.horizontal + forward
                , depth = currentPosition.depth + (currentPosition.aim * forward)
            }

        Down down ->
            { currentPosition
                | aim = currentPosition.aim + down
            }

        Up up ->
            { currentPosition
                | aim = currentPosition.aim - up
            }


calculateTotalPosition : List Move -> Position
calculateTotalPosition moves =
    moves
        |> List.foldl calculatePosition (Position 0 0 0)


calculateResult : Position -> Int
calculateResult position =
    position.horizontal * position.depth
