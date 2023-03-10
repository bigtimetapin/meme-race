module View.Contender.View exposing (view)

import Html exposing (Html)
import Html.Attributes exposing (class, default, href, placeholder, src, style, target)
import Html.Events exposing (onClick, onInput)
import Model.Contender.NewWagerForm as NewWagerForm
import Model.Contender.State exposing (State(..))
import Model.Wallet as Wallet
import Msg.Contender.Msg as ContenderMsg
import Msg.Msg exposing (Msg(..))


view : State -> Html Msg
view state =
    let
        html =
            case state of
                Almost _ ->
                    Html.div
                        []
                        []

                Top contender ->
                    let
                        ( wager, wagerPct ) =
                            case contender.wager of
                                Just w ->
                                    ( Html.div
                                        []
                                        [ Html.text w.formatted
                                        , Html.button
                                            [ class "ml-3"
                                            , onClick <|
                                                FromContender <|
                                                    ContenderMsg.StartNewWager
                                                        contender
                                            ]
                                            [ Html.text
                                                """add 2 your wager 😉
                                                """
                                            ]
                                        ]
                                    , Html.div
                                        []
                                        [ Html.text w.percentage
                                        ]
                                    )

                                Nothing ->
                                    ( Html.div
                                        []
                                        [ Html.button
                                            [ onClick <|
                                                FromContender <|
                                                    ContenderMsg.StartNewWager
                                                        contender
                                            ]
                                            [ Html.text
                                                """place wager
                                                """
                                            ]
                                        ]
                                    , Html.div
                                        []
                                        []
                                    )
                    in
                    Html.div
                        [ class "mt-6"
                        ]
                        [ Html.table
                            [ class "table-pink is-fullwidth"
                            ]
                            [ Html.tbody
                                []
                                [ Html.tr
                                    []
                                    [ Html.td
                                        []
                                        [ Html.text "pot total 💰"
                                        ]
                                    , Html.td
                                        []
                                        [ Html.text <|
                                            String.concat
                                                [ "$BONK"
                                                , ": "
                                                , contender.score
                                                ]
                                        ]
                                    ]
                                , Html.tr
                                    []
                                    [ Html.td
                                        []
                                        [ Html.text "your wager 🌱"
                                        ]
                                    , Html.td
                                        []
                                        [ wager
                                        ]
                                    ]
                                , Html.tr
                                    []
                                    [ Html.td
                                        []
                                        [ Html.text "your wager pct ➗"
                                        ]
                                    , Html.td
                                        []
                                        [ wagerPct
                                        ]
                                    ]
                                , Html.tr
                                    []
                                    [ Html.td
                                        []
                                        [ Html.text "uploader 📩"
                                        ]
                                    , Html.td
                                        []
                                        [ Html.a
                                            [ class "has-sky-blue-text"
                                            , href <|
                                                String.concat
                                                    [ "https://solscan.io/account/"
                                                    , contender.authority.address
                                                    ]
                                            , target "_blank"
                                            ]
                                            [ Html.text <|
                                                Wallet.slice contender.authority.address
                                            ]
                                        ]
                                    ]
                                , Html.tr
                                    []
                                    [ Html.td
                                        []
                                        [ Html.text "meme 😄"
                                        ]
                                    , Html.td
                                        []
                                        [ Html.img
                                            [ src contender.url
                                            ]
                                            []
                                        ]
                                    ]
                                ]
                            ]
                        ]

                NewWager newWagerForm contender ->
                    let
                        input =
                            let
                                table wager burn burnPct =
                                    Html.table
                                        [ class "table"
                                        ]
                                        [ Html.tbody
                                            []
                                            [ Html.tr
                                                []
                                                [ Html.td
                                                    []
                                                    [ Html.text
                                                        """wager size 💰
                                                        """
                                                    ]
                                                , Html.td
                                                    []
                                                    [ wager
                                                    ]
                                                ]
                                            , Html.tr
                                                []
                                                [ Html.td
                                                    []
                                                    [ Html.text
                                                        """burn size 🔥
                                                        """
                                                    ]
                                                , Html.td
                                                    []
                                                    [ burn
                                                    ]
                                                ]
                                            , Html.tr
                                                []
                                                [ Html.td
                                                    []
                                                    [ Html.text
                                                        """burn pct ➗
                                                        """
                                                    ]
                                                , Html.td
                                                    []
                                                    [ burnPct
                                                    ]
                                                ]
                                            ]
                                        ]
                            in
                            case newWagerForm.newWager of
                                Just newWager ->
                                    Html.div
                                        []
                                        [ Html.input
                                            [ onInput <|
                                                \s ->
                                                    FromContender <|
                                                        ContenderMsg.TypingNewWager
                                                            s
                                                            newWagerForm
                                                            contender
                                            ]
                                            []
                                        , Html.div
                                            [ class "my-2"
                                            ]
                                            [ table
                                                (Html.div
                                                    []
                                                    [ Html.text <|
                                                        String.concat
                                                            [ "$BONK"
                                                            , ": "
                                                            , newWager.wager.formatted
                                                            ]
                                                    ]
                                                )
                                                (Html.div
                                                    []
                                                    [ Html.text <|
                                                        String.concat
                                                            [ "$BONK"
                                                            , ": "
                                                            , newWager.burn.formatted
                                                            ]
                                                    ]
                                                )
                                                (Html.div
                                                    []
                                                    [ Html.text <|
                                                        String.concat
                                                            [ String.fromFloat <| 100 * newWagerForm.burn
                                                            , "%"
                                                            ]
                                                    ]
                                                )
                                            ]
                                        , Html.div
                                            []
                                            [ Html.button
                                                [ onClick <|
                                                    FromContender <|
                                                        ContenderMsg.PlaceNewWager
                                                            newWager
                                                            contender
                                                ]
                                                [ Html.text
                                                    """place wager 🤑
                                                    """
                                                ]
                                            ]
                                        ]

                                Nothing ->
                                    Html.div
                                        []
                                        [ Html.input
                                            [ onInput <|
                                                \s ->
                                                    FromContender <|
                                                        ContenderMsg.TypingNewWager
                                                            s
                                                            newWagerForm
                                                            contender
                                            , placeholder "new wager"
                                            ]
                                            []
                                        , Html.div
                                            [ class "mt-2"
                                            ]
                                            [ table
                                                (Html.div
                                                    []
                                                    [ Html.text <|
                                                        String.concat
                                                            [ "$BONK"
                                                            , ": 0"
                                                            ]
                                                    ]
                                                )
                                                (Html.div
                                                    []
                                                    [ Html.text <|
                                                        String.concat
                                                            [ "$BONK"
                                                            , ": 0"
                                                            ]
                                                    ]
                                                )
                                                (Html.div
                                                    []
                                                    [ Html.text <|
                                                        String.concat
                                                            [ String.fromFloat <| 100 * newWagerForm.burn
                                                            , "%"
                                                            ]
                                                    ]
                                                )
                                            ]
                                        ]
                    in
                    Html.div
                        [ class "box-pink"
                        ]
                        [ Html.div
                            [ class "columns"
                            ]
                            [ Html.div
                                [ class "column is-half"
                                ]
                                [ input
                                ]
                            , Html.div
                                [ class "column is-half"
                                ]
                                [ Html.img
                                    [ src contender.url
                                    ]
                                    []
                                ]
                            ]
                        ]
    in
    Html.div
        [ class "box"
        ]
        [ Html.div
            [ style "margin-bottom" "100px"
            ]
            [ Html.h3
                [ class "is-family-secondary has-text-centered is-size-4"
                ]
                [ Html.text
                    """CONTENDER
                    """
                ]
            ]
        , Html.div
            [ style "margin-bottom" "50px"
            ]
            [ html
            ]
        ]
