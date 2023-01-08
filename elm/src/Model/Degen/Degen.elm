module Model.Degen.Degen exposing (Degen, decode)

import Json.Decode as Decode
import Model.Contender.Contender as Contender exposing (Contender)
import Model.PublicKey exposing (PublicKey)
import Model.Wager as Wager exposing (Wager)
import Util.Decode as Util


type alias Degen =
    { wallet : PublicKey
    , contender : Maybe Contender
    , wagers : List Wager
    }


decode : String -> Result String Degen
decode string =
    Util.decode string decoder identity


decoder : Decode.Decoder Degen
decoder =
    Decode.map3 Degen
        (Decode.field "wallet" Decode.string)
        (Decode.maybe <|
            Decode.field "contender" Contender.decoder
        )
        (Decode.field "wagers" <| Decode.list Wager.decoder)
