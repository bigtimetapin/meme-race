module View.LeaderBoard.View exposing (view)

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
                                        , String.fromInt leaderBoard.total
                                        , " "
                                        , "😮\u{200D}💨"
                                        ]
                                ]
                            , Html.div
                                [ class "columns is-half"
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
                                                            [ href <|
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
                                                        [ Html.a
                                                            [ Local.href <|
                                                                Local.Contender <|
                                                                    ContenderState.Almost
                                                                        { pda = contender.pda
                                                                        }
                                                            ]
                                                            [ Html.text "place wager 🤔"
                                                            ]
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
                                [ class "columns is-half"
                                ]
                                [ Html.text <|
                                    String.concat
                                        [ "Race closed 🏁"
                                        ]
                                ]
                            ]
                        ]
