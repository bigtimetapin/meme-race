module View.Header exposing (view)

import Html exposing (Html)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Model.State.Global.Global exposing (Global(..))
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
                        []
                        [ Html.div
                            [ class "is-text-container-4"
                            ]
                            [ Html.text "DAP.COOL"
                            , Html.text "🆒"
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
                        [ viewWallet global
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


viewWallet : Global -> Html Msg
viewWallet global =
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
                [ Html.text "no-wallet-yet"
                ]

        WalletMissing ->
            Html.div
                []
                [ Html.text "no-wallet-installed"
                ]

        HasWallet wallet ->
            Html.div
                []
                [ Html.div
                    []
                    [ Html.text <|
                        String.concat
                            [ "wallet:"
                            , " "
                            , Wallet.slice wallet
                            ]
                    ]
                , Html.div
                    []
                    [ Html.text
                        """no-handle-yet
                        """
                    , Html.div
                        []
                        [ Html.a
                            [ class "has-sky-blue-text"
                            ]
                            [ Html.text "create-handle-now"
                            ]
                        ]
                    ]
                ]

        HasDegen wallet _ ->
            Html.div
                []
                [ Html.div
                    []
                    [ Html.text <|
                        String.concat
                            [ "wallet:"
                            , " "
                            , Wallet.slice wallet
                            ]
                    ]
                ]
