module Sub.Listener.Local.Contender.Contender exposing (Listener(..), fromString)


type Listener
    = Fetched


fromString : String -> Maybe Listener
fromString string =
    case string of
        "contender-fetched" ->
            Just Fetched

        _ ->
            Nothing
