port module Main exposing (main)

import Browser
import Dropdown
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Puzzle exposing (Puzzle(..))



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { inputText : String
    , outputText : String
    , selectedPuzzle : Maybe Puzzle
    , dropdownState : Dropdown.State Puzzle
    }


type alias PuzzleInfo =
    { puzzle : Puzzle
    , initInput : String
    }


type Msg
    = InputTextChanged String
    | SelectedPuzzleChanged (Maybe Puzzle)
    | Dropdown (Dropdown.Msg Puzzle)
    | CopyResultToClipboard



-- INIT


init : () -> ( Model, Cmd Msg )
init _ =
    let
        allPuzzleInfos : List PuzzleInfo
        allPuzzleInfos =
            [ PuzzleInfo Puzzle1 "199\n200\n208\n210\n200\n207\n240\n269\n260\n263"
            , PuzzleInfo Puzzle2 "199\n200\n208\n210\n200\n207\n240\n269\n260\n263"
            , PuzzleInfo Puzzle3 "forward 5\ndown 5\nforward 8\nup 3\ndown 8\nforward 2"
            , PuzzleInfo Puzzle4 "forward 5\ndown 5\nforward 8\nup 3\ndown 8\nforward 2"
            , PuzzleInfo Puzzle5 "00100\n11110\n10110\n10111\n10101\n01111\n00111\n11100\n10000\n11001\n00010\n01010"
            ]

        initPuzzle_ =
            allPuzzleInfos |> List.filter (\p -> p.puzzle == Puzzle5) |> List.head

        initPuzzle =
            initPuzzle_ |> Maybe.map .puzzle

        initInput =
            initPuzzle_ |> Maybe.map .initInput |> Maybe.withDefault ""
    in
    ( { inputText = initInput
      , outputText = Puzzle.choosePuzzleSolution (initPuzzle |> Maybe.withDefault Puzzle1) initInput
      , selectedPuzzle = initPuzzle
      , dropdownState = Dropdown.init "puzzles-dropdown"
      }
    , Cmd.none
    )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        InputTextChanged input ->
            ( { model
                | inputText = input
                , outputText = Puzzle.choosePuzzleSolution (model.selectedPuzzle |> Maybe.withDefault Puzzle1) input
              }
            , Cmd.none
            )

        SelectedPuzzleChanged puzzle ->
            ( { model
                | selectedPuzzle = puzzle
                , outputText = Puzzle.choosePuzzleSolution (puzzle |> Maybe.withDefault Puzzle1) model.inputText
              }
            , Cmd.none
            )

        Dropdown dropdownMsg ->
            let
                ( updated, cmd ) =
                    Dropdown.update dropDownConfig dropdownMsg model model.dropdownState
            in
            ( { model | dropdownState = updated }
            , cmd
            )

        CopyResultToClipboard ->
            ( model, copyToClipboard model.outputText )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- PORTS


port copyToClipboard : String -> Cmd msg



-- VIEW


colors =
    { foreground = rgb255 204 204 204
    , background = rgb255 15 15 35
    , hover = rgb255 36 36 61
    , green = rgb255 3 171 18
    , highlite = rgb255 105 234 147
    }


highliteMouseOver : Attribute msg
highliteMouseOver =
    mouseOver [ Font.color colors.highlite, Font.glow colors.highlite 2 ]


dropDownConfig : Dropdown.Config Puzzle Msg Model
dropDownConfig =
    let
        itemToElement isSelected isHighlighted puzzle =
            row
                [ Background.color colors.hover
                , Font.color colors.green
                , highliteMouseOver
                , padding 5
                ]
                [ text ("[ " ++ Puzzle.toString puzzle ++ " ]")
                ]
    in
    Dropdown.basic
        { itemsFromModel = \_ -> Puzzle.all
        , selectionFromModel = .selectedPuzzle
        , dropdownMsg = Dropdown
        , onSelectMsg = SelectedPuzzleChanged
        , itemToPrompt =
            \p ->
                el
                    [ alignRight
                    , Font.color colors.green
                    , highliteMouseOver
                    ]
                <|
                    text ("[ " ++ Puzzle.toString p ++ " ]")
        , itemToElement = itemToElement
        }
        |> Dropdown.withContainerAttributes
            [ padding 5
            , alignRight
            ]


view : Model -> Html Msg
view model =
    layout
        [ width fill
        , height fill
        , Background.color colors.background
        , Font.color colors.foreground
        , Font.family
            [ Font.external
                { name = "Source Code Pro"
                , url = "https://fonts.googleapis.com/css2?family=Source+Code+Pro:wght@300&display=swap"
                }
            ]
        ]
    <|
        column
            [ width fill
            , height fill
            , spacing 20
            , padding 20
            ]
            [ row [ width fill, alignTop ]
                [ el [ width <| fillPortion 1 ] <| Dropdown.view dropDownConfig model model.dropdownState
                , el [ width <| fillPortion 1 ] <|
                    newTabLink
                        [ Font.size 24
                        , Font.color colors.green
                        , highliteMouseOver
                        , alignRight
                        ]
                        { url = "https://adventofcode.com/2021"
                        , label =
                            text "Advent of Code 2021"
                        }
                ]
            , row
                [ width fill
                , height fill
                , spacing 20
                ]
                [ column
                    [ width <| fillPortion 1
                    , height fill
                    , spacing 10
                    ]
                    [ el [] <| text "Input:"
                    , Input.multiline
                        [ height fill
                        , width fill
                        , Background.color colors.background
                        , focused [ Border.color colors.highlite, Border.glow colors.highlite 2 ]
                        ]
                        { onChange = InputTextChanged
                        , text = model.inputText
                        , placeholder = Nothing
                        , label = Input.labelHidden ""
                        , spellcheck = False
                        }
                    ]
                , column
                    [ height fill
                    , width <| fillPortion 1
                    , spacing 10
                    ]
                    [ el [] <| text "Result:"
                    , row
                        [ width fill
                        , spacing 20
                        ]
                        [ el
                            [ width fill
                            , padding 11
                            , Border.width 1
                            , Border.rounded 3
                            ]
                          <|
                            text model.outputText
                        , el
                            [ Font.color colors.green
                            , highliteMouseOver
                            , Events.onClick CopyResultToClipboard
                            ]
                          <|
                            text "[ copy ]"
                        ]
                    , image [ alignBottom, width fill ]
                        { src = "https://github.com/JakobFerdinand/adventOfCode2021/raw/main/assets/adventOfCode.jpg", description = "" }
                    ]
                ]
            ]
