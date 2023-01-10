module Sub.Listener.Local.Degen.Listener exposing (Listener(..), fromString)


type Listener
    = Fetched
    | RefreshedShadowBalance


fromString : String -> Maybe Listener
fromString string =
    case string of
        "degen-fetched" ->
            Just Fetched

        "degen-refreshed-shadow-balance" ->
            Just RefreshedShadowBalance

        _ ->
            Nothing
