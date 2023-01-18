module Model.Contender.NewWagerForm exposing (NewWager, NewWagerForm, decode, default, encode)

import Json.Decode as Decode
import Json.Encode as Encode
import Model.Contender.Contender as Contender exposing (Contender)
import Model.Degen.Degen as Degen exposing (Degen)
import Util.Decode as Util


type alias NewWagerForm =
    { newWager : Maybe NewWager
    , burn : Float
    }


type alias NewWager =
    { total : Int
    , wager : Tup
    , burn : Tup
    }


type alias Tup =
    { numeric : Float
    , formatted : String
    }


default : NewWagerForm
default =
    { newWager = Nothing
    , burn = 0.5
    }


encode : NewWager -> Contender -> String
encode newWager contender =
    Encode.encode 0 <|
        Encode.object
            [ ( "wager", Encode.int newWager.total )
            , ( "contender"
              , Encode.object
                    [ ( "pda", Encode.string contender.pda )
                    ]
              )
            ]


decode : String -> Result String { degen : Degen, contender : Contender }
decode string =
    Util.decode string decoder identity


decoder : Decode.Decoder { degen : Degen, contender : Contender }
decoder =
    Decode.map2 (\d c -> { degen = d, contender = c })
        (Decode.field "degen" Degen.decoder)
        (Decode.field "contender" Contender.decoder)
