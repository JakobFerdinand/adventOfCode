module Puzzle exposing (..)

import Puzzles.Puzzle1 as Puzzle1
import Puzzles.Puzzle11 as Puzzle11
import Puzzles.Puzzle12 as Puzzle12
import Puzzles.Puzzle2 as Puzzle2
import Puzzles.Puzzle3 as Puzzle3
import Puzzles.Puzzle4 as Puzzle4
import Puzzles.Puzzle5 as Puzzle5
import Puzzles.Puzzle6 as Puzzle6
import Puzzles.Puzzle7 as Puzzle7
import Puzzles.Puzzle8 as Puzzle8
import Puzzles.Puzzle9 as Puzzle9


type Puzzle
    = Puzzle1
    | Puzzle2
    | Puzzle3
    | Puzzle4
    | Puzzle5
    | Puzzle6
    | Puzzle7
    | Puzzle8
    | Puzzle9
    | Puzzle11
    | Puzzle12


all : List Puzzle
all =
    [ Puzzle1
    , Puzzle2
    , Puzzle3
    , Puzzle4
    , Puzzle5
    , Puzzle6
    , Puzzle7
    , Puzzle8
    , Puzzle9
    , Puzzle11
    , Puzzle12
    ]


toString : Puzzle -> String
toString puzzle =
    case puzzle of
        Puzzle1 ->
            "Puzzle 1"

        Puzzle2 ->
            "Puzzle 2"

        Puzzle3 ->
            "Puzzle 3"

        Puzzle4 ->
            "Puzzle 4"

        Puzzle5 ->
            "Puzzle 5"

        Puzzle6 ->
            "Puzzle 6"

        Puzzle7 ->
            "Puzzle 7"

        Puzzle8 ->
            "Puzzle 8"

        Puzzle9 ->
            "Puzzle 9"

        Puzzle11 ->
            "Puzzle 11"

        Puzzle12 ->
            "Puzzle 12"


choosePuzzleSolution : Puzzle -> (String -> String)
choosePuzzleSolution puzzle =
    case puzzle of
        Puzzle1 ->
            Puzzle1.solve

        Puzzle2 ->
            Puzzle2.solve

        Puzzle3 ->
            Puzzle3.solve

        Puzzle4 ->
            Puzzle4.solve

        Puzzle5 ->
            Puzzle5.solve

        Puzzle6 ->
            Puzzle6.solve

        Puzzle7 ->
            Puzzle7.solve

        Puzzle8 ->
            Puzzle8.solve

        Puzzle9 ->
            Puzzle9.solve

        Puzzle11 ->
            Puzzle11.solve

        Puzzle12 ->
            Puzzle12.solve


sampleData : Puzzle -> String
sampleData puzzle =
    case puzzle of
        Puzzle1 ->
            "199\n200\n208\n210\n200\n207\n240\n269\n260\n263"

        Puzzle2 ->
            "199\n200\n208\n210\n200\n207\n240\n269\n260\n263"

        Puzzle3 ->
            "forward 5\ndown 5\nforward 8\nup 3\ndown 8\nforward 2"

        Puzzle4 ->
            "forward 5\ndown 5\nforward 8\nup 3\ndown 8\nforward 2"

        Puzzle5 ->
            "00100\n11110\n10110\n10111\n10101\n01111\n00111\n11100\n10000\n11001\n00010\n01010"

        Puzzle6 ->
            "00100\n11110\n10110\n10111\n10101\n01111\n00111\n11100\n10000\n11001\n00010\n01010"

        Puzzle7 ->
            "7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1\n\n22 13 17 11  0\n 8  2 23  4 24\n21  9 14 16  7\n 6 10  3 18  5\n 1 12 20 15 19\n\n 3 15  0  2 22\n 9 18 13 17  5\n19  8  7 25 23\n20 11 10 24  4\n14 21 16 12  6\n\n14 21 17 24  4\n10 16 15  9 19\n18  8 23 26 20\n22 11 13  6  5\n 2  0 12  3  7"

        Puzzle8 ->
            "7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1\n\n22 13 17 11  0\n 8  2 23  4 24\n21  9 14 16  7\n 6 10  3 18  5\n 1 12 20 15 19\n\n 3 15  0  2 22\n 9 18 13 17  5\n19  8  7 25 23\n20 11 10 24  4\n14 21 16 12  6\n\n14 21 17 24  4\n10 16 15  9 19\n18  8 23 26 20\n22 11 13  6  5\n 2  0 12  3  7"

        Puzzle9 ->
            "0,9 -> 5,9\n8,0 -> 0,8\n9,4 -> 3,4\n2,2 -> 2,1\n7,0 -> 7,4\n6,4 -> 2,0\n0,9 -> 2,9\n3,4 -> 1,4\n0,0 -> 8,8\n5,5 -> 8,2"

        Puzzle11 ->
            "3,4,3,1,2"

        Puzzle12 ->
            "3,4,3,1,2"
