module Model.Degen.NewContenderForm exposing (NewContenderForm, encode)

import Json.Encode as Encode


type alias NewContenderForm =
    Maybe DataUrl


type alias DataUrl =
    String


encode : DataUrl -> String
encode dataUrl =
    Encode.encode 0 <|
        Encode.object
            [ ( "dataUrl", Encode.string dataUrl )
            ]
