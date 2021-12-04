module Puzzles.Puzzle8 exposing (solve)

import Html exposing (u)
import List.Extra as ListE


solve : String -> String
solve input =
    let
        numbers =
            parseNumbers input

        boards =
            parseBoards input
    in
    case play numbers boards of
        Just result ->
            result |> String.fromInt

        Nothing ->
            "No winner yet."


isNotEmpty : String -> Bool
isNotEmpty s =
    String.isEmpty s == False


parseNumbers : String -> List Int
parseNumbers input =
    input
        |> String.split "\n"
        |> List.head
        |> Maybe.withDefault ""
        |> String.split ","
        |> List.filterMap String.toInt


buffer : Int -> List a -> List (List a)
buffer size list =
    if List.length list <= size then
        [ list ]

    else
        (list |> List.take size) :: buffer size (List.drop size list)


type Bet
    = Unchoosen Int
    | Choosen Int


type alias NotWonBoard =
    List (List Bet)


type Board
    = NotWon NotWonBoard
    | Won (List Int)


parseBoards : String -> List NotWonBoard
parseBoards input =
    let
        parseRow : String -> List Int
        parseRow line =
            line
                |> String.split " "
                |> List.filterMap String.toInt

        createBoard : List String -> NotWonBoard
        createBoard data =
            data
                |> List.map parseRow
                |> List.map (\r -> r |> List.map Unchoosen)
    in
    input
        |> String.split "\n"
        |> List.drop 2
        |> List.filter isNotEmpty
        |> buffer 5
        |> List.map createBoard


markChoosen : Int -> NotWonBoard -> NotWonBoard
markChoosen number board =
    let
        update : Bet -> Bet
        update bet =
            case bet of
                Choosen _ ->
                    bet

                Unchoosen n ->
                    if n == number then
                        Choosen n

                    else
                        bet
    in
    board |> List.map (List.map update)


checkBoard : NotWonBoard -> Board
checkBoard board =
    let
        allChoosen items =
            items
                |> List.all
                    (\i ->
                        case i of
                            Choosen _ ->
                                True

                            Unchoosen _ ->
                                False
                    )

        columns =
            board |> ListE.transpose

        rows =
            board

        unwrap bet =
            case bet of
                Choosen _ ->
                    0

                Unchoosen n ->
                    n

        checkDataSet dataSet =
            dataSet
                |> List.filter allChoosen
                |> List.head
                |> Maybe.map
                    (\r ->
                        dataSet
                            |> List.filter (\row -> row /= r)
                            |> List.concat
                            |> List.map unwrap
                    )
    in
    case checkDataSet rows of
        Just unchoosen ->
            Won unchoosen

        Nothing ->
            case checkDataSet columns of
                Just unchoosen ->
                    Won unchoosen

                Nothing ->
                    NotWon board


play : List Int -> List NotWonBoard -> Maybe Int
play numbers boards =
    numbers
        |> List.head
        |> Maybe.andThen
            (\n ->
                let
                    updatedBoards =
                        boards
                            |> List.map (markChoosen n)
                            |> List.map checkBoard

                    notWonBoards =
                        updatedBoards
                            |> List.filterMap
                                (\b ->
                                    case b of
                                        Won _ ->
                                            Nothing

                                        NotWon no ->
                                            Just no
                                )

                    wonBoard =
                        updatedBoards
                            |> List.filterMap
                                (\b ->
                                    case b of
                                        Won w ->
                                            Just w

                                        NotWon _ ->
                                            Nothing
                                )
                            |> List.head
                in
                case ( notWonBoards, wonBoard ) of
                    ( [], Just last ) ->
                        Just ((last |> List.sum) * n)

                    ( notwon, _ ) ->
                        play
                            (numbers |> List.drop 1)
                            notwon
            )
