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
            , claimed : Bool
            }
    , url : String
    , authority :
        { address : PublicKey
        , claimed : Bool
        }
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
                Decode.map4 (\w p f c -> { wager = w, percentage = p, formatted = f, claimed = c })
                    (Decode.field "wager" Decode.int)
                    (Decode.field "percentage" Decode.string)
                    (Decode.field "formatted" Decode.string)
                    (Decode.field "claimed" Decode.bool)
        )
        (Decode.field "url" Decode.string)
        (Decode.field "authority" <|
            Decode.map2 (\a c -> { address = a, claimed = c })
                (Decode.field "address" Decode.string)
                (Decode.field "claimed" Decode.bool)
        )
        (Decode.field "pda" Decode.string)
