module Sub.Listener.Local.Contender.Contender exposing (Listener(..), fromString)


type Listener
    = Fetched
    | WagerPlaced


fromString : String -> Maybe Listener
fromString string =
    case string of
        "contender-fetched" ->
            Just Fetched

        "contender-wager-placed" ->
            Just WagerPlaced

        _ ->
            Nothing
