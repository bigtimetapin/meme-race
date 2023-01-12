module View.Header exposing (view)

import Html exposing (Html)
import Html.Attributes exposing (class, src, style, width)
import Html.Events exposing (onClick)
import Model.LeaderBoard.State as LeaderBoardState
import Model.State.Global.Global exposing (Global(..))
import Model.State.Local.Local as Local
import Model.Wallet as Wallet
import Msg.Degen.Msg as DegenMsg
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
                        [ Html.img
                            [ src "./images/logo.jpg"
                            , width 250
                            ]
                            []
                        ]
                    ]
                ]
            ]
        , Html.div
            [ class "level-right mx-5 my-3"
            ]
            [ Html.div
                [ class "level-item"
                ]
                [ connect global
                ]
            ]
        ]


connect : Global -> Html Msg
connect global =
    case global of
        NoWalletYet ->
            Html.button
                [ class "button is-light-text-container-4"
                , style "width" "100%"
                , onClick <| Msg.Global FromGlobal.Connect
                ]
                [ Html.text "Connect Wallet"
                ]

        WalletMissing ->
            Html.div
                []
                [ Html.text "no-wallet-installed"
                ]

        HasDegen degen ->
            let
                contender =
                    case degen.contender of
                        Just _ ->
                            Html.div
                                []
                                [ Html.button
                                    [ class "button"
                                    , style "width" "100%"
                                    , onClick <|
                                        FromDegen <|
                                            DegenMsg.ToTop
                                                degen
                                    ]
                                    [ Html.text <|
                                        """degen page 🚀
                                        """
                                    ]
                                ]

                        Nothing ->
                            Html.div
                                []
                                [ Html.button
                                    [ class "button"
                                    , style "width" "100%"
                                    , onClick <|
                                        FromDegen <|
                                            DegenMsg.ToTop
                                                degen
                                    ]
                                    [ Html.text <|
                                        """add meme 2 race 🏎️
                                        """
                                    ]
                                ]
            in
            Html.div
                []
                [ Html.div
                    [ class "button is-static"
                    , style "width" "100%"
                    ]
                    [ Html.text <|
                        String.concat
                            [ "wallet:"
                            , " "
                            , Wallet.slice degen.wallet
                            ]
                    ]
                , Html.div
                    []
                    [ Html.button
                        [ class "button is-light-text-container-4"
                        , style "width" "100%"
                        , onClick <| Msg.Global FromGlobal.Disconnect
                        ]
                        [ Html.text "Disconnect"
                        ]
                    ]
                , contender
                ]
