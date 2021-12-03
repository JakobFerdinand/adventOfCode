module Puzzle exposing (..)

import Puzzles.Puzzle1 as Puzzle1
import Puzzles.Puzzle2 as Puzzle2
import Puzzles.Puzzle3 as Puzzle3
import Puzzles.Puzzle4 as Puzzle4
import Puzzles.Puzzle5 as Puzzle5
import Puzzles.Puzzle6 as Puzzle6


type Puzzle
    = Puzzle1
    | Puzzle2
    | Puzzle3
    | Puzzle4
    | Puzzle5
    | Puzzle6


all : List Puzzle
all =
    [ Puzzle1
    , Puzzle2
    , Puzzle3
    , Puzzle4
    , Puzzle5
    , Puzzle6
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
