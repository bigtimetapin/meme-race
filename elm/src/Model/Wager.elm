module Model.Wager exposing (Wager, decode, decoder)

import Json.Decode as Decode
import Model.Contender.Contender as Contender exposing (Contender)
import Util.Decode as Util


type alias Wager =
    { wagerSize : Int
    , wagerSizeFormatted : String
    , wagerCount : Int
    , contender : Contender
    }


decode : String -> Result String Wager
decode string =
    Util.decode string decoder identity


decoder : Decode.Decoder Wager
decoder =
    Decode.map4 Wager
        (Decode.field "wagerSize" Decode.int)
        (Decode.field "wagerSizeFormatted" Decode.string)
        (Decode.field "wagerCount" Decode.int)
        (Decode.field "contender" Contender.decoder)
