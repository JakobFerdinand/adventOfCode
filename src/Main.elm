module Main exposing (..)

import Browser
import Dict exposing (update)
import Element exposing (..)
import Element.Font as Font
import Html exposing (Html)



-- MAIN


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }


type alias Model =
    ()


type Msg
    = DoNothing



-- INIT


init : Model
init =
    ()



-- UPDATE


update : Msg -> b -> b
update msg model =
    case msg of
        DoNothing ->
            model



-- VIEW


view : Model -> Html msg
view model =
    layout
        [ width fill
        , height fill
        ]
    <|
        column
            [ centerX
            , centerY
            , spacing 20
            ]
            [ text "yo"
            ]
