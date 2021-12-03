module Puzzles.Puzzle6 exposing (solve)

import Binary
import List.Extra as ListE


solve : String -> String
solve input =
    let
        binary =
            input
                |> String.split "\n"
                |> List.map (String.split "")
                |> List.map parse

        oxygen =
            binary |> oxygenGeneratorRating

        co2Scrubber =
            binary |> co2ScrubberRating
    in
    (oxygen * co2Scrubber) |> String.fromInt


parse : List String -> List Int
parse =
    List.filterMap String.toInt


countOnBits : List Int -> Int
countOnBits bits =
    bits |> List.filter (\b -> b == 1) |> List.length


countOffBits : List Int -> Int
countOffBits bits =
    bits |> List.filter (\b -> b == 0) |> List.length


atIndex : Int -> List a -> Maybe a
atIndex index list =
    list |> List.drop index |> List.head


column : Int -> List (List int) -> List int
column index input =
    input
        |> ListE.transpose
        |> atIndex index
        |> Maybe.withDefault []


calcRating : (List (List Int) -> Int -> Int) -> List (List Int) -> Int
calcRating discriminator values =
    let
        calc : Int -> List (List Int) -> List (List Int)
        calc index input =
            let
                isInMostCommon : List Int -> Bool
                isInMostCommon bits =
                    bits
                        |> atIndex index
                        |> Maybe.map (\b -> b == discriminator input index)
                        |> Maybe.withDefault False

                remaining =
                    input
                        |> List.filter isInMostCommon
            in
            if List.length input == 1 then
                input

            else
                calc (index + 1) remaining
    in
    values
        |> calc 0
        |> List.head
        |> Maybe.withDefault []
        |> Binary.fromIntegers
        |> Binary.toDecimal


oxygenGeneratorRating : List (List Int) -> Int
oxygenGeneratorRating values =
    let
        mostCommon : List (List Int) -> Int -> Int
        mostCommon input index =
            if countOnBits (column index input) > countOffBits (column index input) then
                1

            else if countOnBits (column index input) == countOffBits (column index input) then
                1

            else
                0
    in
    values |> calcRating mostCommon


co2ScrubberRating : List (List Int) -> Int
co2ScrubberRating values =
    let
        mostCommon : List (List Int) -> Int -> Int
        mostCommon input index =
            if countOnBits (column index input) > countOffBits (column index input) then
                0

            else if countOnBits (column index input) == countOffBits (column index input) then
                0

            else
                1
    in
    values |> calcRating mostCommon
