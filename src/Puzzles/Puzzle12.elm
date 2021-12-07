-- Thanks to bukkfrig!! The solution is from him
-- https://github.com/bukkfrig/AoC2021/blob/7a476981425ae49cc464d0ca3a6217fb960eaa05/06-2/src/Main.elm
-- My solution ended in OutOfMemoryExceptions after a long time of waiting.


module Puzzles.Puzzle12 exposing (solve)

import Dict exposing (Dict)
import Dict.Extra


solve : String -> String
solve input =
    input
        |> String.split ","
        |> List.filterMap String.toInt
        |> Dict.Extra.groupBy identity
        |> Dict.map (\_ fishes -> List.length fishes)
        |> iterate 256 step
        |> Dict.values
        |> List.sum
        |> String.fromInt


iterate : Int -> (Dict Int Int -> Dict Int Int) -> Dict Int Int -> Dict Int Int
iterate times f xs =
    case times of
        0 ->
            xs

        _ ->
            iterate (times - 1) f (f xs)


step : Dict Int Int -> Dict Int Int
step fishes =
    let
        old n =
            Dict.get n fishes |> Maybe.withDefault 0
    in
    Dict.fromList
        [ ( 0, old 1 )
        , ( 1, old 2 )
        , ( 2, old 3 )
        , ( 3, old 4 )
        , ( 4, old 5 )
        , ( 5, old 6 )
        , ( 6, old 7 + old 0 )
        , ( 7, old 8 )
        , ( 8, old 0 )
        ]
