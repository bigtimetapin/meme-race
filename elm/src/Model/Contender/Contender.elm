module Model.Contender.Contender exposing (Contender, decode, decoder)

import Json.Decode as Decode
import Model.PublicKey exposing (PublicKey)
import Util.Decode as Util


type alias Contender =
    { score : Int
    , url : String
    , authority : PublicKey
    }


decode : String -> Result String Contender
decode string =
    Util.decode string decoder identity


decoder : Decode.Decoder Contender
decoder =
    Decode.map3 Contender
        (Decode.field "score" Decode.int)
        (Decode.field "url" Decode.string)
        (Decode.field "authority" Decode.string)
