module Msg.Admin.Msg exposing (Msg(..), toString)


type Msg
    = Init


toString : Msg -> String
toString msg =
    case msg of
        Init ->
            "admin-init"
