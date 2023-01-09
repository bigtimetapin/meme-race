module Sub.Listener.Local.Degen.Listener exposing (Listener(..), fromString)


type Listener
    = Fetched


fromString : String -> Maybe Listener
fromString string =
    case string of
        "degen-fetched" ->
            Just Fetched

        _ ->
            Nothing
