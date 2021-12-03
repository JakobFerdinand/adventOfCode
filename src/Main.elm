port module Main exposing (main)

import Browser
import Dropdown
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html, input)
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


type Msg
    = InputTextChanged String
    | SelectedPuzzleChanged (Maybe Puzzle)
    | Dropdown (Dropdown.Msg Puzzle)
    | CopyResultToClipboard
    | InsertSampleInput



-- INIT


init : () -> ( Model, Cmd Msg )
init _ =
    let
        initPuzzle =
            Puzzle6
    in
    ( { inputText = Puzzle.sampleData initPuzzle
      , outputText = Puzzle.choosePuzzleSolution initPuzzle (Puzzle.sampleData initPuzzle)
      , selectedPuzzle = Just initPuzzle
      , dropdownState = Dropdown.init "puzzles-dropdown"
      }
    , Cmd.none
    )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        updateModel input =
            { model
                | inputText = input
                , outputText = Puzzle.choosePuzzleSolution (model.selectedPuzzle |> Maybe.withDefault Puzzle1) input
            }
    in
    case msg of
        InputTextChanged input ->
            ( updateModel input
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

        InsertSampleInput ->
            ( case model.selectedPuzzle of
                Just puzzle ->
                    updateModel (Puzzle.sampleData puzzle)

                Nothing ->
                    model
            , Cmd.none
            )



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
            [ row [ width fill, alignTop, spacing 20 ]
                [ el [ width <| fillPortion 1 ] <| Dropdown.view dropDownConfig model model.dropdownState
                , row [ width <| fillPortion 1, spacing 20 ]
                    [ newTabLink
                        [ Font.color colors.green
                        , highliteMouseOver
                        , alignRight
                        ]
                        { url = "https://github.com/JakobFerdinand/adventOfCode2021"
                        , label =
                            text "[ github ]"
                        }
                    , newTabLink
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
                    [ row [ width fill ]
                        [ el [] <| text "Input:"
                        , el [ alignRight, Font.color colors.green, highliteMouseOver, Events.onClick InsertSampleInput ] <| text "[ insert sample ]"
                        ]
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
