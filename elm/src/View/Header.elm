module View.Header exposing (view)

import Html exposing (Html)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Model.Degen.State as DegenState
import Model.LeaderBoard.State as LeaderBoardState
import Model.State.Global.Global exposing (Global(..))
import Model.State.Local.Local as Local
import Model.Wallet as Wallet
import Msg.Global as FromGlobal
import Msg.Msg as Msg exposing (Msg(..))


view : Global -> Html Msg
view global =
    Html.nav
        [ class "level is-size-4" -- is-navbar level is-mobile is-size-4
        ]
        [ Html.div
            [ class "level-left ml-5 my-3"
            ]
            [ Html.div
                [ class "level-item"
                ]
                [ Html.h1
                    []
                    [ Html.a
                        [ Local.href <|
                            Local.LeaderBoard <|
                                LeaderBoardState.Almost
                        ]
                        [ Html.div
                            [ class "is-text-container-4"
                            ]
                            [ Html.text "MEME RACE"
                            , Html.text "🔥"
                            ]
                        ]
                    ]
                ]
            ]
        , Html.div
            [ class "level-right mr-5 my-3"
            ]
            [ Html.div
                [ class "level-item"
                ]
                [ Html.span
                    [ class "icon-text"
                    ]
                    [ Html.span
                        []
                        [ connect global
                        ]
                    , Html.span
                        [ class "icon"
                        ]
                        [ Html.i
                            [ class "fas fa-user"
                            ]
                            []
                        ]
                    ]
                ]
            , Html.div
                [ class "level-item"
                ]
                [ viewGlobal global
                ]
            ]
        ]


connect : Global -> Html Msg
connect global =
    case global of
        NoWalletYet ->
            Html.button
                [ class "is-light-text-container-4 mr-2"
                , onClick <| Msg.Global FromGlobal.Connect
                ]
                [ Html.text "Connect Wallet"
                ]

        WalletMissing ->
            Html.div
                []
                []

        _ ->
            Html.button
                [ class "is-light-text-container-4 mr-2"
                , onClick <| Msg.Global FromGlobal.Disconnect
                ]
                [ Html.text "Disconnect Wallet"
                ]


viewGlobal : Global -> Html Msg
viewGlobal global =
    case global of
        NoWalletYet ->
            Html.div
                []
                []

        WalletMissing ->
            Html.div
                []
                [ Html.text "no-wallet-installed"
                ]

        HasDegen degen ->
            let
                contender =
                    case degen.contender of
                        Just c ->
                            Html.div
                                []
                                [ Html.text <|
                                    String.concat
                                        [ "total $BONK wagered on your meme: "
                                        , c.score
                                        ]
                                ]

                        Nothing ->
                            Html.div
                                []
                                [ Html.text
                                    """you haven't added a meme to the race yet 🤨
                                    """
                                ]

                wagers =
                    case degen.wagers of
                        [] ->
                            Html.div
                                []
                                []

                        nel ->
                            Html.div
                                []
                                [ Html.text <|
                                    String.concat
                                        [ "you've placed wagers on"
                                        , " "
                                        , String.fromInt <| List.length nel
                                        , " "
                                        , "memes for a total of"
                                        , " "
                                        , "$BONK 🔥"
                                        , " "
                                        , String.fromInt <| List.sum (List.map (\w -> w.wagerSize) nel)
                                        ]
                                ]
            in
            Html.div
                []
                [ Html.div
                    []
                    [ Html.text <|
                        String.concat
                            [ "wallet:"
                            , " "
                            , Wallet.slice degen.wallet
                            ]
                    ]
                , Html.div
                    []
                    [ contender
                    , wagers
                    , Html.div
                        []
                        [ Html.a
                            [ class "has-sky-blue-text"
                            , Local.href <|
                                Local.Degen <|
                                    DegenState.Top <|
                                        degen
                            ]
                            [ Html.text <|
                                """degen page 😎
                                """
                            ]
                        ]
                    ]
                ]
