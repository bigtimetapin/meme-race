module Sub.Listener.Local.LeaderBoard.LeaderBoard exposing (Listener(..), fromString)


type Listener
    = Fetched


fromString : String -> Maybe Listener
fromString string =
    case string of
        "leader-board-fetched" ->
            Just Fetched

        _ ->
            Nothing
