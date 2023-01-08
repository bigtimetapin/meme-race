module Sub.Sender.Sender exposing (Sender(..), WithMore, encode, encode0)

import Json.Encode as Encode
import Msg.Collector.Collector as CollectorMsg exposing (FromCollector)
import Msg.Global as FromGlobal


type Sender
    = Collect FromCollector
    | Global FromGlobal.Global


type alias WithMore =
    { sender : Sender
    , more : Json
    }


encode : WithMore -> Json
encode withMore =
    let
        encoder =
            Encode.object
                [ ( "sender", Encode.string <| toString withMore.sender )
                , ( "more", Encode.string withMore.more )
                ]
    in
    Encode.encode 0 encoder


encode0 : Sender -> Json
encode0 role =
    let
        encoder =
            Encode.object
                [ ( "sender", Encode.string <| toString role )
                ]
    in
    Encode.encode 0 encoder


toString : Sender -> String
toString role =
    case role of
        Collect fromCollector ->
            CollectorMsg.toString fromCollector

        Global fromGlobal ->
            FromGlobal.toString fromGlobal


type alias Json =
    String
