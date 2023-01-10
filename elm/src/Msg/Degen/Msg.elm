module Msg.Degen.Msg exposing (Msg(..), toString)

import File exposing (File)
import Model.Degen.Degen exposing (Degen)


type Msg
    = ToTop Degen
    | StartNewContenderForm Degen
    | RefreshShadowBalance
    | SelectMeme Degen
    | MemeSelected Degen File
    | MemeRead Degen DataUrl
    | AddNewContender DataUrl


type alias DataUrl =
    String


toString : Msg -> String
toString msg =
    case msg of
        AddNewContender _ ->
            "degen-add-new-contender"

        RefreshShadowBalance ->
            "degen-refresh-shadow-balance"

        _ ->
            "no-op"
