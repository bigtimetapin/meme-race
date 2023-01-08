module Msg.Contender.Msg exposing (Msg(..), toString)


type Msg
    = Fetch


toString : Msg -> String
toString msg =
    case msg of
        Fetch ->
            "contender-fetch"
