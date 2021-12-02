module Main exposing (main)

import Browser
import Dict exposing (update)
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html, input)
import Puzzles.Puzzle1 as Puzzle1
import Puzzles.Puzzle2 as Puzzle2
import Puzzles.Puzzle3 as Puzzle3



-- MAIN


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }


type alias Model =
    { inputText : String
    , outputText : String
    , selectedPuzzle : Puzzle
    }


type alias PuzzleInfo =
    { puzzle : Puzzle
    , displayText : String
    , initInput : String
    }


type Puzzle
    = Puzzle1
    | Puzzle2
    | Puzzle3


allPuzzles : List PuzzleInfo
allPuzzles =
    [ PuzzleInfo Puzzle1 "Puzzle 1 - Dez 1" "199\n200\n208\n210\n200\n207\n240\n269\n260\n263"
    , PuzzleInfo Puzzle2 "Puzzle 2 - Dez 2" "199\n200\n208\n210\n200\n207\n240\n269\n260\n263"
    , PuzzleInfo Puzzle3 "Puzzle 3 - Dez 3" "forward 5\ndown 5\nforward 8\nup 3\ndown 8\nforward 2"
    ]


type Msg
    = InputTextChanged String
    | SelectedPuzzleChanged Puzzle



-- INIT


init : Model
init =
    let
        initPuzzle_ =
            allPuzzles |> List.filter (\p -> p.puzzle == Puzzle3) |> List.head

        initPuzzle =
            initPuzzle_ |> Maybe.map .puzzle |> Maybe.withDefault Puzzle1

        initInput =
            initPuzzle_ |> Maybe.map .initInput |> Maybe.withDefault ""
    in
    { inputText = initInput
    , outputText = choosePuzzleSolution initPuzzle initInput
    , selectedPuzzle = initPuzzle
    }



-- UPDATE


update : Msg -> Model -> Model
update msg model =
    case msg of
        InputTextChanged input ->
            { model
                | inputText = input
                , outputText = choosePuzzleSolution model.selectedPuzzle input
            }

        SelectedPuzzleChanged puzzle ->
            { model
                | selectedPuzzle = puzzle
                , outputText = choosePuzzleSolution puzzle model.inputText
            }


choosePuzzleSolution : Puzzle -> (String -> String)
choosePuzzleSolution selectedPuzzle =
    case selectedPuzzle of
        Puzzle1 ->
            Puzzle1.solve

        Puzzle2 ->
            Puzzle2.solve

        Puzzle3 ->
            Puzzle3.solve



-- VIEW


view : Model -> Html Msg
view model =
    layout
        [ width fill
        , height fill
        ]
    <|
        column
            [ width fill
            , height fill
            , spacing 20
            , padding 20
            ]
            [ row [ width fill, alignTop ]
                [ row [ width <| fillPortion 1, spacing 20 ]
                    [ el [ Font.size 24, width fill ] <| text "Advent of Code 2021"
                    , viewPuzzles [ alignRight ] model.selectedPuzzle
                    ]
                , el [ width <| fillPortion 1 ] none
                ]
            , row
                [ width fill
                , height fill
                , spacing 20
                , Font.family
                    [ Font.external
                        { name = "Source Code Pro"
                        , url = "https://fonts.googleapis.com/css2?family=Source+Code+Pro:wght@300&display=swap"
                        }
                    ]
                ]
                [ Input.multiline [ height fill, width <| fillPortion 1 ]
                    { onChange = InputTextChanged
                    , text = model.inputText
                    , placeholder = Nothing
                    , label = Input.labelHidden ""
                    , spellcheck = False
                    }
                , column [ height fill, width <| fillPortion 1 ]
                    [ el [ height <| fillPortion 1 ] <| text model.outputText
                    , newTabLink [ height <| fillPortion 1, width fill, Background.image "https://github.com/JakobFerdinand/adventOfCode2021/raw/main/assets/adventOfCode.jpg" ]
                        { url = "https://adventofcode.com/2021", label = none }
                    ]
                ]
            ]


viewPuzzles : List (Attribute Msg) -> Puzzle -> Element Msg
viewPuzzles attributes selectedPuzzle =
    Input.radioRow
        (spacing 20 :: attributes)
        { onChange = SelectedPuzzleChanged
        , selected = Just selectedPuzzle
        , label = Input.labelHidden ""
        , options = allPuzzles |> List.map puzzleInfoOption
        }


puzzleInfoOption : PuzzleInfo -> Input.Option Puzzle msg
puzzleInfoOption info =
    Input.option info.puzzle <| text info.displayText
