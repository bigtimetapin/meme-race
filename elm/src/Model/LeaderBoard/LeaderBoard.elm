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
    , open : Bool
    }


decode : String -> Result String LeaderBoard
decode string =
    Util.decode string decoder identity


decoder : Decode.Decoder LeaderBoard
decoder =
    Decode.map5 LeaderBoard
        (Decode.field "authority" Decode.string)
        (Decode.field "leader" Contender.decoder)
        (Decode.field "race" <| Decode.list Contender.decoder)
        (Decode.field "total" Decode.int)
        (Decode.field "open" Decode.bool)
