module Main exposing (main)

-- MAIN

import Browser
import Browser.Navigation as Nav
import Model.Contender.AlmostContender as AlmostContender
import Model.Contender.Contender as Contender
import Model.Contender.State as ContenderState
import Model.Degen.Degen as Degen
import Model.LeaderBoard.LeaderBoard as LeaderBoard
import Model.LeaderBoard.State as LeaderBoardState
import Model.Model as Model exposing (Model)
import Model.State.Exception.Exception as Exception
import Model.State.Global.Global as Global
import Model.State.Local.Local as Local exposing (Local)
import Msg.Contender.Msg as ContenderMsg
import Msg.Js as JsMsg
import Msg.LeaderBoard.Msg as LeaderBoardMsg
import Msg.Msg exposing (Msg(..), resetViewport)
import Sub.Listener.Global.Global as ToGlobal
import Sub.Listener.Listener as Listener
import Sub.Listener.Local.Contender.Contender as ContenderListener
import Sub.Listener.Local.LeaderBoard.LeaderBoard as LeaderBoardListener
import Sub.Listener.Local.Local as ToLocal
import Sub.Sender.Ports exposing (sender)
import Sub.Sender.Sender as Sender
import Sub.Sub as Sub
import Url
import View.Error.Error
import View.Hero
import View.LeaderBoard.View


main : Program () Model Msg
main =
    Browser.application
        { init = Model.init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.subs
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        UrlChanged url ->
            let
                local : Local
                local =
                    Local.parse url

                bump : Model
                bump =
                    { model
                        | state =
                            { local = local
                            , global = model.state.global
                            , exception = model.state.exception
                            }
                        , url = url
                    }
            in
            case local of
                Local.Contender (ContenderState.Almost almostContender) ->
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

                _ ->
                    ( bump
                    , resetViewport
                    )

        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        FromLeaderBoard fromLeaderBoard ->
            case fromLeaderBoard of
                LeaderBoardMsg.Fetch ->
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
                                fromLeaderBoard
                    )

        FromContender fromContender ->
            case fromContender of
                -- handled by href
                ContenderMsg.Fetch ->
                    ( model
                    , Cmd.none
                    )

        FromJs fromJsMsg ->
            case fromJsMsg of
                -- JS sending success for decoding
                JsMsg.Success json ->
                    -- decode
                    case Listener.decode0 json of
                        -- decode success
                        Ok maybeListener ->
                            -- look for role
                            case maybeListener of
                                -- found role
                                Just listener ->
                                    -- which role?
                                    case listener of
                                        -- found msg for local update
                                        Listener.Local toLocal ->
                                            case toLocal of
                                                ToLocal.LeaderBoard leaderBoardListener ->
                                                    case leaderBoardListener of
                                                        LeaderBoardListener.Fetched ->
                                                            let
                                                                f leaderBoard =
                                                                    { model
                                                                        | state =
                                                                            { local =
                                                                                Local.LeaderBoard <|
                                                                                    LeaderBoardState.Top leaderBoard
                                                                            , global = model.state.global
                                                                            , exception = Exception.Closed
                                                                            }
                                                                    }
                                                            in
                                                            Listener.decode model json LeaderBoard.decode f

                                                ToLocal.Contender contenderListener ->
                                                    case contenderListener of
                                                        ContenderListener.Fetched ->
                                                            let
                                                                f contender =
                                                                    { model
                                                                        | state =
                                                                            { local =
                                                                                Local.Contender <|
                                                                                    ContenderState.Top contender
                                                                            , global = model.state.global
                                                                            , exception = Exception.Closed
                                                                            }
                                                                    }
                                                            in
                                                            Listener.decode model json Contender.decode f

                                        -- found msg for global
                                        Listener.Global toGlobal ->
                                            case toGlobal of
                                                ToGlobal.FoundWalletDisconnected ->
                                                    ( { model
                                                        | state =
                                                            { local = model.state.local
                                                            , global = Global.NoWalletYet
                                                            , exception = Exception.Closed
                                                            }
                                                      }
                                                    , Cmd.none
                                                    )

                                                -- TODO; open exception modal
                                                ToGlobal.FoundMissingWalletPlugin ->
                                                    ( { model
                                                        | state =
                                                            { local = model.state.local
                                                            , global = Global.WalletMissing
                                                            , exception = Exception.Closed
                                                            }
                                                      }
                                                    , Cmd.none
                                                    )

                                                ToGlobal.FoundDegen ->
                                                    let
                                                        f degen =
                                                            { model
                                                                | state =
                                                                    { local = model.state.local
                                                                    , global = Global.HasDegen degen
                                                                    , exception = Exception.Closed
                                                                    }
                                                            }
                                                    in
                                                    Listener.decode model json Degen.decode f

                                -- undefined role
                                Nothing ->
                                    let
                                        message =
                                            String.join
                                                " "
                                                [ "Invalid role sent from client:"
                                                , json
                                                ]
                                    in
                                    ( { model
                                        | state =
                                            { local = Local.Error message
                                            , global = model.state.global
                                            , exception = model.state.exception
                                            }
                                      }
                                    , Cmd.none
                                    )

                        -- error from decoder
                        Err string ->
                            ( { model
                                | state =
                                    { local = Local.Error string
                                    , global = model.state.global
                                    , exception = model.state.exception
                                    }
                              }
                            , Cmd.none
                            )

                -- JS sending exception to catch
                JsMsg.Exception string ->
                    case Exception.decode string of
                        Ok exception ->
                            ( { model
                                | state =
                                    { local = model.state.local
                                    , global = model.state.global
                                    , exception = Exception.Open exception.message exception.href
                                    }
                              }
                            , Cmd.none
                            )

                        Err jsonError ->
                            ( { model
                                | state =
                                    { local = Local.Error jsonError
                                    , global = model.state.global
                                    , exception = model.state.exception
                                    }
                              }
                            , Cmd.none
                            )

                -- JS sending error to raise
                JsMsg.Error string ->
                    ( { model
                        | state =
                            { local = Local.Error string
                            , global = model.state.global
                            , exception = model.state.exception
                            }
                      }
                    , Cmd.none
                    )

        Global fromGlobal ->
            ( { model
                | state =
                    { local = model.state.local
                    , global = model.state.global
                    , exception = Exception.Waiting
                    }
              }
            , sender <| Sender.encode0 <| Sender.Global fromGlobal
            )

        CloseExceptionModal ->
            ( { model
                | state =
                    { local = model.state.local
                    , global = model.state.global
                    , exception = Exception.Closed
                    }
              }
            , Cmd.none
            )



-- VIEW


view : Model -> Browser.Document Msg
view model =
    let
        hero =
            View.Hero.view model.state.exception model.state.global

        html =
            case model.state.local of
                Local.LeaderBoard leaderBoard ->
                    hero <| View.LeaderBoard.View.view leaderBoard

                Local.Error error ->
                    hero <| View.Error.Error.body error

                _ ->
                    hero <| View.Error.Error.body "todo;"
    in
    { title = "meme-race.com"
    , body =
        [ html
        ]
    }
