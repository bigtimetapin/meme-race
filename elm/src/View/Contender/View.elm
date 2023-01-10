module View.Contender.View exposing (view)

import Html exposing (Html)
import Html.Attributes exposing (class, default, href, placeholder, src, target)
import Html.Events exposing (onClick, onInput)
import Model.Contender.NewWagerForm as NewWagerForm
import Model.Contender.State exposing (State(..))
import Model.Wallet as Wallet
import Msg.Contender.Msg as ContenderMsg
import Msg.Msg exposing (Msg(..))


view : State -> Html Msg
view state =
    case state of
        Almost _ ->
            Html.div
                []
                []

        Top contender ->
            let
                ( wager, newWager ) =
                    case contender.wager of
                        Just w ->
                            ( Html.div
                                []
                                [ Html.text <|
                                    String.concat
                                        [ "You've personally wagered"
                                        , " "
                                        , "$BONK"
                                        , ": "
                                        , w
                                        , " "
                                        , "on this candidate 😏"
                                        ]
                                ]
                            , Html.div
                                []
                                [ Html.button
                                    [ onClick <|
                                        FromContender <|
                                            ContenderMsg.StartNewWager
                                                contender
                                    ]
                                    [ Html.text
                                        """you won't wager more on this candidate 😉
                                        """
                                    ]
                                ]
                            )

                        Nothing ->
                            ( Html.div
                                []
                                []
                            , Html.div
                                []
                                [ Html.button
                                    [ onClick <|
                                        FromContender <|
                                            ContenderMsg.StartNewWager
                                                contender
                                    ]
                                    [ Html.text
                                        """place a wager on this candidate 🤝
                                        """
                                    ]
                                ]
                            )
            in
            Html.div
                []
                [ Html.div
                    []
                    [ Html.h2
                        []
                        [ Html.text
                            """Contender 👑
                            """
                        ]
                    , Html.div
                        []
                        [ Html.text <|
                            String.concat
                                [ "uploaded by"
                                , ": "
                                ]
                        , Html.a
                            [ class "has-sky-blue-text"
                            , href <|
                                String.concat
                                    [ "https://solscan.io/account/"
                                    , contender.authority
                                    ]
                            , target "_blank"
                            ]
                            [ Html.text <|
                                Wallet.slice contender.authority
                            ]
                        ]
                    ]
                , Html.div
                    [ class "columns"
                    ]
                    [ Html.div
                        [ class "column is-half"
                        ]
                        [ Html.div
                            []
                            [ Html.text <|
                                String.concat
                                    [ "$BONK"
                                    , ": "
                                    , contender.score
                                    , " "
                                    , "in total wagered on this candidate"
                                    ]
                            ]
                        , wager
                        , newWager
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

        NewWager newWagerForm contender ->
            let
                input =
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
                                    []
                                    [ Html.text <|
                                        String.concat
                                            [ "$BONK"
                                            , ": "
                                            , newWager.formatted
                                            ]
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
                                ]
            in
            Html.div
                []
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
