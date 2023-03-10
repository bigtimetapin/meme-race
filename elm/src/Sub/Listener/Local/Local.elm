module Sub.Listener.Local.Local exposing (ToLocal(..), fromString)

import Sub.Listener.Local.Contender.Contender as Contender
import Sub.Listener.Local.Degen.Listener as Degen
import Sub.Listener.Local.LeaderBoard.LeaderBoard as LeaderBoard


type ToLocal
    = LeaderBoard LeaderBoard.Listener
    | Contender Contender.Listener
    | Degen Degen.Listener


fromString : String -> Maybe ToLocal
fromString string =
    case LeaderBoard.fromString string of
        Just listener ->
            Just <| LeaderBoard listener

        Nothing ->
            case Contender.fromString string of
                Just listener ->
                    Just <| Contender listener

                Nothing ->
                    case Degen.fromString string of
                        Just listener ->
                            Just <| Degen listener

                        Nothing ->
                            Nothing
