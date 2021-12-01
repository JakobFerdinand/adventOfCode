module Main exposing (..)

import Browser
import Dict exposing (update)
import Element exposing (..)
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html, input)
import Puzzles.Puzzle1 as Puzzle1



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


type Puzzle
    = Puzzle1


type Msg
    = InputTextChanged String
    | SelectedPuzzleChanged Puzzle



-- INIT


init : Model
init =
    { inputText = ""
    , outputText = ""
    , selectedPuzzle = Puzzle1
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
            [ viewPuzzles model.selectedPuzzle
            , row
                [ width fill
                , height fill
                , spacing 20
                ]
                [ Input.multiline [ height fill, width <| fillPortion 1 ]
                    { onChange = InputTextChanged
                    , text = model.inputText
                    , placeholder = Nothing
                    , label = Input.labelHidden ""
                    , spellcheck = False
                    }
                , el [ height fill, width <| fillPortion 1 ] <| text model.outputText
                ]
            ]


viewPuzzles selectedPuzzle =
    Input.radioRow
        [ spacing 20 ]
        { onChange = SelectedPuzzleChanged
        , selected = Just selectedPuzzle
        , label = Input.labelHidden ""
        , options =
            [ Input.option Puzzle1 <| text "Puzzle 1 - Dez 1" ]
        }
