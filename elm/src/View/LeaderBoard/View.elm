module View.LeaderBoard.View exposing (view)

import Html exposing (Html)
import Html.Attributes exposing (class, href, src, target)
import Html.Events exposing (onClick)
import Model.Contender.State as ContenderState
import Model.LeaderBoard.State exposing (..)
import Model.State.Local.Local as Local
import Model.Wallet as Wallet
import Msg.LeaderBoard.Msg as LeaderBoardMsg
import Msg.Msg exposing (Msg(..))


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
                    let
                        row contender =
                            let
                                rank =
                                    case contender.rank of
                                        Just r ->
                                            Html.text <| String.fromInt r

                                        Nothing ->
                                            Html.div
                                                []
                                                []

                                wager =
                                    case contender.wager of
                                        Just w ->
                                            Html.div
                                                []
                                                [ Html.text <|
                                                    String.concat
                                                        [ "$BONK"
                                                        , ": "
                                                        , w
                                                        ]
                                                , Html.div
                                                    []
                                                    [ Html.a
                                                        [ class "has-sky-blue-text"
                                                        , Local.href <|
                                                            Local.Contender <|
                                                                ContenderState.Almost <|
                                                                    { pda = contender.pda }
                                                        ]
                                                        [ Html.text "add to your wager 🚀"
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
                                                            ContenderState.Almost <|
                                                                { pda = contender.pda }
                                                    ]
                                                    [ Html.text "place wager 🚀"
                                                    ]
                                                ]
                            in
                            Html.tr
                                []
                                [ Html.th
                                    []
                                    [ rank
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
                                , Html.td
                                    []
                                    [ wager
                                    ]
                                , Html.td
                                    []
                                    [ Html.a
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
                                , Html.td
                                    []
                                    [ Html.a
                                        [ Local.href <|
                                            Local.Contender <|
                                                ContenderState.Almost <|
                                                    { pda = contender.pda }
                                        ]
                                        [ Html.img
                                            [ src contender.url
                                            ]
                                            []
                                        ]
                                    ]
                                ]

                        rows =
                            Html.tbody
                                []
                            <|
                                List.map
                                    row
                                    leaderBoard.race

                        table =
                            Html.div
                                []
                                [ Html.table
                                    [ class "table is-fullwidth is-striped is-bordered is-hoverable"
                                    ]
                                    [ Html.thead
                                        []
                                        [ Html.tr
                                            []
                                            [ Html.th
                                                []
                                                [ Html.text "rank 🏅"
                                                ]
                                            , Html.th
                                                []
                                                [ Html.text "wager total 💰"
                                                ]
                                            , Html.th
                                                []
                                                [ Html.text "your wager 🌱"
                                                ]
                                            , Html.th
                                                []
                                                [ Html.text "uploader 📩"
                                                ]
                                            , Html.th
                                                []
                                                [ Html.text "meme 😄"
                                                ]
                                            ]
                                        ]
                                    , Html.tfoot
                                        []
                                        [ Html.tr
                                            []
                                            [ Html.th
                                                []
                                                [ Html.text "rank 🏅"
                                                ]
                                            , Html.th
                                                []
                                                [ Html.text "wager total 💰"
                                                ]
                                            , Html.th
                                                []
                                                [ Html.text "your wager 🌱"
                                                ]
                                            , Html.th
                                                []
                                                [ Html.text "uploader 📩"
                                                ]
                                            , Html.th
                                                []
                                                [ Html.text "meme 😄"
                                                ]
                                            ]
                                        ]
                                    , rows
                                    ]
                                ]
                    in
                    Html.div
                        []
                        [ Html.div
                            [ class "is-family-secondary has-text-centered"
                            ]
                            [ Html.div
                                [ class "mb-4"
                                ]
                                [ Html.h2
                                    [ class "is-size-5"
                                    ]
                                    [ Html.text <|
                                        String.concat
                                            [ "Pot Total"
                                            , ":"
                                            ]
                                    , Html.b
                                        [ class "is-bold"
                                        ]
                                        [ Html.text <|
                                            String.concat
                                                [ " "
                                                , "$BONK"
                                                , " "
                                                , leaderBoard.totalFormatted
                                                ]
                                        ]
                                    , Html.a
                                        [ class "has-sky-blue-text ml-3 mb-6"
                                        , onClick <|
                                            FromLeaderBoard <|
                                                LeaderBoardMsg.Fetch
                                        ]
                                        [ Html.text "refresh"
                                        ]
                                    ]
                                ]
                            , Html.div
                                []
                                [ Html.h2
                                    [ class "is-size-5"
                                    ]
                                    [ Html.text <|
                                        String.concat
                                            [ "Race closes at"
                                            , " "
                                            , "Thursday, Jan. 12th at 11:59pm EST"
                                            ]
                                    ]
                                ]
                            ]
                        , Html.div
                            [ class "mt-6"
                            ]
                            [ table
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
                                        , leaderBoard.totalFormatted
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
