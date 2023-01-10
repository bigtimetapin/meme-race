module View.LeaderBoard.View exposing (view)

import FormatNumber
import FormatNumber.Locales exposing (usLocale)
import Html exposing (Html)
import Html.Attributes exposing (class, href, src, target)
import Model.Contender.State as ContenderState
import Model.LeaderBoard.State exposing (..)
import Model.State.Local.Local as Local
import Model.Wallet as Wallet
import Msg.Msg exposing (Msg)


view : State -> Html Msg
view state =
    case state of
        Almost ->
            Html.div
                []
                []

        Top leaderBoard ->
            case leaderBoard.open of
                True ->
                    Html.div
                        []
                        [ Html.div
                            [ class "columns"
                            ]
                            [ Html.div
                                [ class "column is-half"
                                ]
                                [ Html.text <|
                                    String.concat
                                        [ "Total Pot Size"
                                        , ": "
                                        , "$BONK"
                                        , " "
                                        , FormatNumber.format usLocale (Basics.toFloat leaderBoard.total)
                                        , " "
                                        , "🎉"
                                        ]
                                ]
                            , Html.div
                                [ class "column is-half"
                                ]
                                [ Html.text <|
                                    String.concat
                                        [ "Race closes at"
                                        , " "
                                        , "Thursday, Jan. 12th at 11:59pm EST"
                                        , "👀"
                                        ]
                                ]
                            ]
                        , Html.div
                            []
                            [ Html.div
                                []
                                [ Html.h2
                                    []
                                    [ Html.text
                                        """Leader Board 🏅
                                        """
                                    ]
                                ]
                            , Html.div
                                []
                              <|
                                List.map
                                    (\contender ->
                                        let
                                            wager =
                                                case contender.wager of
                                                    Just w ->
                                                        Html.div
                                                            []
                                                            [ Html.div
                                                                []
                                                                [ Html.text <|
                                                                    String.concat
                                                                        [ "your current wager"
                                                                        , ": "
                                                                        , "$BONK"
                                                                        , " "
                                                                        , w
                                                                        ]
                                                                ]
                                                            , Html.div
                                                                []
                                                                [ Html.a
                                                                    [ class "has-sky-blue-text"
                                                                    , Local.href <|
                                                                        Local.Contender <|
                                                                            ContenderState.Almost
                                                                                { pda = contender.pda
                                                                                }
                                                                    ]
                                                                    [ Html.text "add to your wager 🤔"
                                                                    ]
                                                                ]
                                                            ]

                                                    Nothing ->
                                                        Html.div
                                                            []
                                                            [ Html.a
                                                                [ class "has-sky-blue-text"
                                                                , Local.href <|
                                                                    Local.Contender <|
                                                                        ContenderState.Almost
                                                                            { pda = contender.pda
                                                                            }
                                                                ]
                                                                [ Html.text "place wager 🤔"
                                                                ]
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
                                                    [ Html.div
                                                        []
                                                        [ Html.text <|
                                                            String.concat
                                                                [ "$BONK"
                                                                , " "
                                                                , contender.score
                                                                , " "
                                                                , "wagered on this meme by the community"
                                                                ]
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
                                                    , Html.div
                                                        []
                                                        [ wager
                                                        ]
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
                                    )
                                    leaderBoard.race
                            ]
                        ]

                False ->
                    let
                        wager =
                            case leaderBoard.leader.wager of
                                Just w ->
                                    Html.div
                                        []
                                        [ Html.button
                                            []
                                            [ Html.text
                                                """claim winnings 🎉
                                                """
                                            ]
                                        ]

                                Nothing ->
                                    Html.div
                                        []
                                        [ Html.text
                                            """Looks like you didn't place a wager on this meme
                                            better luck next time 🤝
                                            """
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
                                [ Html.text <|
                                    String.concat
                                        [ "Total Pot Size"
                                        , ": "
                                        , String.fromInt leaderBoard.total
                                        , " "
                                        , "😮\u{200D}💨"
                                        ]
                                ]
                            , Html.div
                                [ class "column is-half"
                                ]
                                [ Html.text <|
                                    String.concat
                                        [ "Race closed 🏁"
                                        ]
                                ]
                            ]
                        , Html.div
                            []
                            [ Html.div
                                []
                                [ Html.text "Winner 🏅"
                                ]
                            , Html.div
                                []
                                [ Html.div
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
                                                    , " "
                                                    , leaderBoard.leader.score
                                                    ]
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
                                                        , leaderBoard.leader.authority
                                                        ]
                                                , target "_blank"
                                                ]
                                                [ Html.text <|
                                                    Wallet.slice leaderBoard.leader.authority
                                                ]
                                            ]
                                        , Html.div
                                            []
                                            [ wager
                                            ]
                                        ]
                                    , Html.div
                                        [ class "column is-half"
                                        ]
                                        [ Html.img
                                            [ src leaderBoard.leader.url
                                            ]
                                            []
                                        ]
                                    ]
                                ]
                            ]
                        ]
