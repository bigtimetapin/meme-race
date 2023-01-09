module Model.Contender.NewWagerForm exposing (NewWager, NewWagerForm, default, encode)

import Json.Encode as Encode
import Model.Contender.Contender exposing (Contender)


type alias NewWagerForm =
    { newWager : Maybe NewWager
    }


type alias NewWager =
    { wager : Int
    , formatted : String
    }


default : NewWagerForm
default =
    { newWager = Nothing
    }


encode : NewWager -> Contender -> String
encode newWager contender =
    Encode.encode 0 <|
        Encode.object
            [ ( "wager", Encode.int newWager.wager )
            , ( "contender"
              , Encode.object
                    [ ( "authority", Encode.string contender.authority )
                    ]
              )
            ]
