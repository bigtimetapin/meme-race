module Msg.LeaderBoard.Msg exposing (Msg(..), toString)


type Msg
    = Fetch


toString : Msg -> String
toString msg =
    case msg of
        Fetch ->
            "leader-board-fetch"
