module Puzzles.Puzzle7 exposing (solve)

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


type alias Board =
    List (List Bet)


parseBoards : String -> List Board
parseBoards input =
    let
        parseRow : String -> List Int
        parseRow line =
            line
                |> String.split " "
                |> List.filterMap String.toInt

        createBoard : List String -> Board
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


markChoosen : Int -> Board -> Board
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
    board
        |> List.map (List.map update)


checkBoard : Board -> Maybe (List Int)
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
            Just unchoosen

        Nothing ->
            checkDataSet columns


play : List Int -> List Board -> Maybe Int
play numbers boards =
    numbers
        |> List.head
        |> Maybe.andThen
            (\n ->
                let
                    updatedBoard =
                        boards |> List.map (markChoosen n)

                    wonBoard =
                        updatedBoard |> List.filterMap checkBoard |> List.head
                in
                case wonBoard of
                    Just result ->
                        Just ((result |> List.sum) * n)

                    Nothing ->
                        play
                            (numbers |> List.drop 1)
                            updatedBoard
            )
