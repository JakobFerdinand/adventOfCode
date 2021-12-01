module Main exposing (..)

import Browser
import Dict exposing (update)
import Element exposing (..)
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html, input)



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
            { model | inputText = input }

        SelectedPuzzleChanged puzzle ->
            { model | selectedPuzzle = puzzle }



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
                , el [ height fill, width <| fillPortion 1 ] <| text ""
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
