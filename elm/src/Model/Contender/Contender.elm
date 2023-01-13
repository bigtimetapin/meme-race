module Model.Contender.Contender exposing (Contender, decode, decoder)

import Json.Decode as Decode
import Model.PublicKey exposing (PublicKey)
import Util.Decode as Util


type alias Contender =
    { score : String
    , rank : Maybe Int
    , wager :
        Maybe
            { wager : Int
            , percentage : String
            , formatted : String
            }
    , url : String
    , authority : PublicKey
    , pda : PublicKey
    }


decode : String -> Result String Contender
decode string =
    Util.decode string decoder identity


decoder : Decode.Decoder Contender
decoder =
    Decode.map6 Contender
        (Decode.field "score" Decode.string)
        (Decode.maybe <| Decode.field "rank" Decode.int)
        (Decode.maybe <|
            Decode.field "wager" <|
                Decode.map3 (\w p f -> { wager = w, percentage = p, formatted = f })
                    (Decode.field "wager" Decode.int)
                    (Decode.field "percentage" Decode.string)
                    (Decode.field "formatted" Decode.string)
        )
        (Decode.field "url" Decode.string)
        (Decode.field "authority" Decode.string)
        (Decode.field "pda" Decode.string)
