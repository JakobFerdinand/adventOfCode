module Puzzles.Puzzle11 exposing (solve)

import Html exposing (input)


solve : String -> String
solve input =
    input
        |> String.split ","
        |> List.filterMap String.toInt
        |> calcDays 80
        |> List.length
        |> String.fromInt


calcDays : Int -> List Int -> List Int
calcDays days input =
    if days == 0 then
        input

    else
        calcDays (days - 1) (calcDay input)


calcDay : List Int -> List Int
calcDay input =
    let
        process : Int -> List Int
        process fish =
            if fish == 0 then
                [ 7, 9 ]

            else
                [ fish ]
    in
    input
        |> List.map process
        |> List.concat
        |> List.map (\f -> f - 1)
