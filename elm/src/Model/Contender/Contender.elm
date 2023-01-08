module Model.Contender.Contender exposing (Contender, decode, decoder)

import Json.Decode as Decode
import Model.PublicKey exposing (PublicKey)
import Util.Decode as Util


type alias Contender =
    { score : String
    , wager : Maybe String
    , url : String
    , authority : PublicKey
    , pda : PublicKey
    }


decode : String -> Result String Contender
decode string =
    Util.decode string decoder identity


decoder : Decode.Decoder Contender
decoder =
    Decode.map5 Contender
        (Decode.field "score" Decode.string)
        (Decode.maybe <| Decode.field "wager" Decode.string)
        (Decode.field "url" Decode.string)
        (Decode.field "authority" Decode.string)
        (Decode.field "pda" Decode.string)
