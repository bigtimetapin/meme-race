module Main exposing (main)

-- MAIN

import Browser
import Browser.Navigation as Nav
import File
import File.Select as Select
import FormatNumber as FormatNumber
import FormatNumber.Locales exposing (usLocale)
import Model.Contender.AlmostContender as AlmostContender
import Model.Contender.Contender as Contender
import Model.Contender.NewWagerForm as NewWagerForm
import Model.Contender.State as ContenderState
import Model.Degen.Degen as Degen
import Model.Degen.NewContenderForm as NewContenderForm
import Model.Degen.State as DegenState
import Model.LeaderBoard.LeaderBoard as LeaderBoard
import Model.LeaderBoard.State as LeaderBoardState
import Model.Model as Model exposing (Model)
import Model.State.Exception.Exception as Exception
import Model.State.Global.Global as Global
import Model.State.Local.Local as Local exposing (Local)
import Msg.Admin.Msg as AdminMsg
import Msg.Contender.Msg as ContenderMsg
import Msg.Degen.Msg as DegenMsg
import Msg.Js as JsMsg
import Msg.LeaderBoard.Msg as LeaderBoardMsg
import Msg.Msg exposing (Msg(..), resetViewport)
import Sub.Listener.Global.Global as ToGlobal
import Sub.Listener.Listener as Listener
import Sub.Listener.Local.Contender.Contender as ContenderListener
import Sub.Listener.Local.Degen.Listener as DegenListener
import Sub.Listener.Local.LeaderBoard.LeaderBoard as LeaderBoardListener
import Sub.Listener.Local.Local as ToLocal
import Sub.Sender.Ports exposing (sender)
import Sub.Sender.Sender as Sender
import Sub.Sub as Sub
import Task
import Url
import View.Admin.View
import View.Contender.View
import View.Degen.View
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
                Local.LeaderBoard LeaderBoardState.Almost ->
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

                ContenderMsg.StartNewWager contender ->
                    ( { model
                        | state =
                            { local =
                                Local.Contender <|
                                    ContenderState.NewWager
                                        NewWagerForm.default
                                        contender
                            , global = model.state.global
                            , exception = model.state.exception
                            }
                      }
                    , Cmd.none
                    )

                ContenderMsg.TypingNewWager string form contender ->
                    case String.toInt string of
                        Just int ->
                            ( { model
                                | state =
                                    { local =
                                        Local.Contender <|
                                            ContenderState.NewWager
                                                { form
                                                    | newWager =
                                                        Just <|
                                                            { wager = int
                                                            , formatted = FormatNumber.format usLocale (Basics.toFloat int)
                                                            }
                                                }
                                                contender
                                    , global = model.state.global
                                    , exception = model.state.exception
                                    }
                              }
                            , Cmd.none
                            )

                        Nothing ->
                            ( model
                            , Cmd.none
                            )

                ContenderMsg.PlaceNewWager newWager contender ->
                    ( { model
                        | state =
                            { local = model.state.local
                            , global = model.state.global
                            , exception = Exception.Waiting
                            }
                      }
                    , sender <|
                        Sender.encode <|
                            { sender = Sender.Contender fromContender
                            , more = NewWagerForm.encode newWager contender
                            }
                    )

        FromDegen fromDegen ->
            case fromDegen of
                DegenMsg.ToTop degen ->
                    ( { model
                        | state =
                            { local = Local.Degen <| DegenState.Top degen
                            , global = model.state.global
                            , exception = model.state.exception
                            }
                      }
                    , Cmd.none
                    )

                DegenMsg.RefreshShadowBalance ->
                    ( { model
                        | state =
                            { local = model.state.local
                            , global = model.state.global
                            , exception = Exception.Waiting
                            }
                      }
                    , sender <|
                        Sender.encode0 <|
                            Sender.Degen fromDegen
                    )

                DegenMsg.StartNewContenderForm degen ->
                    ( { model
                        | state =
                            { local = Local.Degen <| DegenState.NewContender Nothing degen
                            , global = model.state.global
                            , exception = model.state.exception
                            }
                      }
                    , Cmd.none
                    )

                DegenMsg.SelectMeme degen ->
                    ( { model
                        | state =
                            { local = model.state.local
                            , global = model.state.global
                            , exception = Exception.Waiting
                            }
                      }
                    , Select.file
                        [ "image/jpeg"
                        , "image/jpeg"
                        , "image/png"
                        , "image/gif"
                        , "image/avif"
                        , "image/bmp"
                        , "image/svg+xml"
                        ]
                        (\file ->
                            FromDegen <| DegenMsg.MemeSelected degen file
                        )
                    )

                DegenMsg.MemeSelected degen file ->
                    ( model
                    , Task.perform
                        (\dataUrl ->
                            FromDegen <| DegenMsg.MemeRead degen dataUrl
                        )
                        (File.toUrl file)
                    )

                DegenMsg.MemeRead degen dataUrl ->
                    ( { model
                        | state =
                            { local =
                                Local.Degen <|
                                    DegenState.NewContender
                                        (Just dataUrl)
                                        degen
                            , global = model.state.global
                            , exception = Exception.Closed
                            }
                      }
                    , Cmd.none
                    )

                DegenMsg.AddNewContender dataUrl ->
                    ( { model
                        | state =
                            { local = model.state.local
                            , global = model.state.global
                            , exception = Exception.Waiting
                            }
                      }
                    , sender <|
                        Sender.encode <|
                            { sender = Sender.Degen fromDegen
                            , more = NewContenderForm.encode dataUrl
                            }
                    )

        FromAdmin fromAdmin ->
            case fromAdmin of
                AdminMsg.Init ->
                    ( model
                    , sender <|
                        Sender.encode0 <|
                            Sender.Admin fromAdmin
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

                                                ToLocal.Degen degenListener ->
                                                    case degenListener of
                                                        DegenListener.Fetched ->
                                                            let
                                                                f degen =
                                                                    { model
                                                                        | state =
                                                                            { local =
                                                                                Local.Degen <|
                                                                                    DegenState.Top degen
                                                                            , global =
                                                                                Global.HasDegen degen
                                                                            , exception = Exception.Closed
                                                                            }
                                                                    }
                                                            in
                                                            Listener.decode model json Degen.decode f

                                                        DegenListener.RefreshedShadowBalance ->
                                                            let
                                                                f degen =
                                                                    { model
                                                                        | state =
                                                                            { local =
                                                                                Local.Degen <|
                                                                                    DegenState.NewContender
                                                                                        Nothing
                                                                                        degen
                                                                            , global = model.state.global
                                                                            , exception = Exception.Closed
                                                                            }
                                                                    }
                                                            in
                                                            Listener.decode model json Degen.decode f

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

                Local.Contender contender ->
                    hero <| View.Contender.View.view contender

                Local.Degen degen ->
                    hero <| View.Degen.View.view degen

                Local.Admin _ ->
                    hero <| View.Admin.View.view

                Local.Error error ->
                    hero <| View.Error.Error.body error
    in
    { title = "meme-race.com"
    , body =
        [ html
        ]
    }
