module Sub.Listener.Local.Local exposing (ToLocal(..), fromString)

import Sub.Listener.Local.Collector.Collector as ToCollector exposing (ToCollector)


type ToLocal
    = Collect ToCollector


fromString : String -> Maybe ToLocal
fromString string =
    case ToCollector.fromString string of
        Just toCollector ->
            Just <| Collect toCollector

        Nothing ->
            Nothing
