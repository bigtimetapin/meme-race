module Model.Wager exposing (Wager, decode, decoder)

import Json.Decode as Decode
import Model.PublicKey exposing (PublicKey)
import Util.Decode as Util


type alias Wager =
    { wagerSize : Int
    , wagerSizeFormatted : String
    , wagerPercentage : String
    , wagerCount : Int
    , contender :
        { pda : PublicKey
        , uploader : PublicKey
        , url : String
        }
    }


decode : String -> Result String Wager
decode string =
    Util.decode string decoder identity


decoder : Decode.Decoder Wager
decoder =
    Decode.map5 Wager
        (Decode.field "wagerSize" Decode.int)
        (Decode.field "wagerSizeFormatted" Decode.string)
        (Decode.field "wagerPercentage" Decode.string)
        (Decode.field "wagerCount" Decode.int)
        (Decode.field "contender" <|
            Decode.map3 (\pda uploader url -> { pda = pda, uploader = uploader, url = url })
                (Decode.field "pda" Decode.string)
                (Decode.field "uploader" Decode.string)
                (Decode.field "url" Decode.string)
        )
