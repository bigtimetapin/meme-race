module Model.Model exposing (Model, init)

import Browser.Navigation as Nav
import Model.Contender.AlmostContender as AlmostContender
import Model.Contender.State as Contender
import Model.LeaderBoard.State as LeaderBoard
import Model.State.Exception.Exception as Exception
import Model.State.Global.Global as Global
import Model.State.Local.Local as Local exposing (Local)
import Model.State.State exposing (State)
import Msg.Contender.Msg as ContenderMsg
import Msg.LeaderBoard.Msg as LeaderBoardMsg
import Msg.Msg exposing (Msg(..))
import Sub.Sender.Ports exposing (sender)
import Sub.Sender.Sender as Sender
import Url


type alias Model =
    { state : State
    , url : Url.Url
    , key : Nav.Key
    }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    let
        local : Local
        local =
            Local.parse url

        model : Model
        model =
            { state =
                { local = local
                , global = Global.default
                , exception = Exception.Closed
                }
            , url = url
            , key = key
            }
    in
    case local of
        Local.Contender (Contender.Almost almostContender) ->
            ( { model
                | state =
                    { local = model.state.local
                    , global = model.state.global
                    , exception = Exception.Waiting
                    }
              }
            , sender <|
                Sender.encode <|
                    { sender = Sender.Contender <| ContenderMsg.Fetch
                    , more = AlmostContender.encode almostContender
                    }
            )

        Local.LeaderBoard (LeaderBoard.Top _) ->
            ( { model
                | state =
                    { local = model.state.local
                    , global = model.state.global
                    , exception = Exception.Waiting
                    }
              }
            , sender <|
                Sender.encode0 <|
                    Sender.LeaderBoard <|
                        LeaderBoardMsg.Fetch
            )

        _ ->
            ( model
            , Cmd.none
            )
