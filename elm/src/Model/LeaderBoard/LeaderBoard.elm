module Model.LeaderBoard.LeaderBoard exposing (LeaderBoard, decode)

import Json.Decode as Decode
import Model.Contender.Contender as Contender exposing (Contender)
import Model.PublicKey exposing (PublicKey)
import Util.Decode as Util


type alias LeaderBoard =
    { authority : PublicKey
    , leader : Contender
    , race : List Contender
    , total : Int
    , totalFormatted : String
    , open : Bool
    , claim :
        { wallet :
            { bossOne : Vip
            , bossTwo : Vip
            , uploader : Vip
            }
        , claimed : Int
        , claimedFormatted : String
        }
    }


type alias Vip =
    { authenticated : Bool
    , claimed : Bool
    }


decode : String -> Result String LeaderBoard
decode string =
    Util.decode string decoder identity


decoder : Decode.Decoder LeaderBoard
decoder =
    Decode.map7 LeaderBoard
        (Decode.field "authority" Decode.string)
        (Decode.field "leader" Contender.decoder)
        (Decode.field "race" <| Decode.list Contender.decoder)
        (Decode.field "total" Decode.int)
        (Decode.field "totalFormatted" Decode.string)
        (Decode.field "open" Decode.bool)
        (Decode.field "claim" <|
            Decode.map3 (\w c cf -> { wallet = w, claimed = c, claimedFormatted = cf })
                (Decode.field "wallet" <|
                    Decode.map3 (\o t u -> { bossOne = o, bossTwo = t, uploader = u })
                        (Decode.field "bossOne" vipDecoder)
                        (Decode.field "bossTwo" vipDecoder)
                        (Decode.field "uploader" vipDecoder)
                )
                (Decode.field "claimed" Decode.int)
                (Decode.field "claimedFormatted" Decode.string)
        )


vipDecoder =
    Decode.map2 Vip
        (Decode.field "authenticated" Decode.bool)
        (Decode.field "claimed" Decode.bool)
