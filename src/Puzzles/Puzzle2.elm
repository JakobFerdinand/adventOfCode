module Puzzles.Puzzle2 exposing (solve)


solve : String -> String
solve input =
    input
        |> String.split "\n"
        |> List.filterMap String.toInt
        |> buffer 3
        |> List.map List.sum
        |> mapMany selectCategory
        |> List.filter (\c -> c == Incresed)
        |> List.length
        |> String.fromInt


buffer : Int -> List a -> List (List a)
buffer size list =
    if List.length list <= size then
        [ list ]

    else
        [ list |> List.take size ] ++ buffer size (List.drop 1 list)


type Category
    = Incresed
    | Decresed
    | NoChange
    | NaN


selectCategory : Maybe Int -> Maybe Int -> Category
selectCategory first second =
    case ( first, second ) of
        ( Just f, Just s ) ->
            if f == s then
                NoChange

            else if f > s then
                Decresed

            else
                Incresed

        _ ->
            NaN


mapMany : (Maybe a -> Maybe a -> b) -> List a -> List b
mapMany fn list =
    let
        list_ =
            List.map Just list

        list1 =
            Nothing :: list_

        list2 =
            list_ ++ [ Nothing ]
    in
    List.map2 fn list1 list2
