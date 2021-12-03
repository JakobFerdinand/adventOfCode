module Puzzles.Puzzle5 exposing (solve)

import Binary
import List.Extra as ListE


solve : String -> String
solve input =
    let
        values =
            input
                |> String.split "\n"
                |> List.map (String.split "")

        gamma =
            gammaRate values

        epsilon =
            epsilonRate values
    in
    gamma * epsilon |> String.fromInt


parse : List String -> List Int
parse =
    List.filterMap String.toInt


countOnBits : List Int -> Int
countOnBits bits =
    bits |> List.filter (\b -> b == 1) |> List.length


countOffBits : List Int -> Int
countOffBits bits =
    bits |> List.filter (\b -> b == 0) |> List.length


calculateRate : (List Int -> Int) -> List (List String) -> Int
calculateRate discriminator values =
    values
        |> List.map parse
        |> ListE.transpose
        |> List.map discriminator
        |> Binary.fromIntegers
        |> Binary.toDecimal


gammaRate : List (List String) -> Int
gammaRate allValues =
    let
        mostCommon : List Int -> Int
        mostCommon bits =
            if countOnBits bits > countOffBits bits then
                1

            else
                0
    in
    allValues |> calculateRate mostCommon


epsilonRate : List (List String) -> Int
epsilonRate allValues =
    let
        leastCommon : List Int -> Int
        leastCommon bits =
            if countOnBits bits < countOffBits bits then
                1

            else
                0
    in
    allValues |> calculateRate leastCommon
