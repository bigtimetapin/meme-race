module Msg.Contender.Msg exposing (Msg(..), toString)

import Model.Contender.Contender exposing (Contender)
import Model.Contender.NewWagerForm exposing (NewWager, NewWagerForm)


type Msg
    = Fetch
    | StartNewWager Contender
    | TypingNewWager String NewWagerForm Contender
    | PlaceNewWager NewWager Contender


toString : Msg -> String
toString msg =
    case msg of
        Fetch ->
            "contender-fetch"

        PlaceNewWager _ _ ->
            "contender-place-new-wager"

        _ ->
            "no-op"
