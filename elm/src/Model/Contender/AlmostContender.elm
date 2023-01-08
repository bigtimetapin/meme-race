module Model.Contender.AlmostContender exposing (AlmostContender, encode)

import Json.Encode as Encode
import Model.PublicKey exposing (PublicKey)


type alias AlmostContender =
    { pda : PublicKey
    }


encode : AlmostContender -> String
encode almostContender =
    Encode.encode 0 <|
        Encode.object
            [ ( "pda", Encode.string almostContender.pda )
            ]
