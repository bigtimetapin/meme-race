module View.LeaderBoard.View exposing (view)

import Html exposing (Html)
import Html.Attributes exposing (class, href, src, style, target)
import Html.Events exposing (onClick)
import Model.Contender.Contender exposing (Contender)
import Model.Contender.State as ContenderState
import Model.LeaderBoard.State as LeaderBoardState exposing (..)
import Model.State.Local.Local as Local
import Model.Wallet as Wallet
import Msg.LeaderBoard.Msg as LeaderBoardMsg
import Msg.Msg exposing (Msg(..))


view : State -> Html Msg
view state =
    let
        html =
            case state of
                Almost ->
                    Html.div
                        []
                        []

                Top leaderBoard ->
                    case leaderBoard.open of
                        True ->
                            let
                                row : Contender -> Html Msg
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

                                        ( wager, wagerPct ) =
                                            case contender.wager of
                                                Just w ->
                                                    ( Html.div
                                                        []
                                                        [ Html.text <|
                                                            String.concat
                                                                [ "$BONK"
                                                                , ": "
                                                                , w.formatted
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
                                                    , Html.div
                                                        []
                                                        [ Html.text w.percentage
                                                        ]
                                                    )

                                                Nothing ->
                                                    ( Html.div
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
                                                    , Html.div
                                                        []
                                                        []
                                                    )
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
                                            [ wagerPct
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
                                        , Html.td
                                            []
                                            [ Html.a
                                                [ Local.href <|
                                                    Local.Contender <|
                                                        ContenderState.Almost <|
                                                            { pda = contender.pda }
                                                , target "_blank"
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
                                        [ class "table-container"
                                        ]
                                        [ Html.table
                                            [ class "table-pink is-fullwidth is-striped is-bordered is-hoverable"
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
                                                        [ Html.text "pot total 💰"
                                                        ]
                                                    , Html.th
                                                        []
                                                        [ Html.text "your wager 🌱"
                                                        ]
                                                    , Html.th
                                                        []
                                                        [ Html.text "your wager pct ➗"
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
                                                        [ Html.text "pot total 💰"
                                                        ]
                                                    , Html.th
                                                        []
                                                        [ Html.text "your wager 🌱"
                                                        ]
                                                    , Html.th
                                                        []
                                                        [ Html.text "your wager pct ➗"
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
                                        [ style "margin-bottom" "50px"
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
                                                , Local.href <|
                                                    Local.LeaderBoard <|
                                                        LeaderBoardState.Almost
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
                                                    , "Sunday, Jan. 22nd at 11:59pm EST"
                                                    ]
                                            ]
                                        ]
                                    ]
                                , Html.div
                                    [ style "margin-top" "50px"
                                    ]
                                    [ table
                                    ]
                                ]

                        False ->
                            let
                                wager =
                                    case leaderBoard.leader.wager of
                                        Just w ->
                                            case w.claimed of
                                                True ->
                                                    Html.div
                                                        []
                                                        [ Html.text <|
                                                            String.concat
                                                                [ "You've successfully claimed your"
                                                                , " "
                                                                , w.percentage
                                                                , " "
                                                                , "share of the winner's pot ❤️"
                                                                ]
                                                        ]

                                                False ->
                                                    Html.div
                                                        []
                                                        [ Html.div
                                                            []
                                                            [ Html.text <|
                                                                String.concat
                                                                    [ "Looks like you wagered"
                                                                    , " "
                                                                    , "$BONK"
                                                                    , ": "
                                                                    , w.formatted
                                                                    , " "
                                                                    , "on this meme 💰"
                                                                    ]
                                                            , Html.div
                                                                []
                                                                [ Html.text <|
                                                                    String.concat
                                                                        [ "which makes up"
                                                                        , " "
                                                                        , w.percentage
                                                                        , " "
                                                                        , "of the total wagers placed on this candidate 👀"
                                                                        ]
                                                                ]
                                                            ]
                                                        , Html.button
                                                            [ onClick <|
                                                                FromLeaderBoard <|
                                                                    LeaderBoardMsg.ClaimWithWager
                                                            ]
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

                                uploader =
                                    case ( leaderBoard.claim.wallet.uploader.authenticated, leaderBoard.claim.wallet.uploader.claimed ) of
                                        ( True, True ) ->
                                            Html.div
                                                []
                                                [ Html.text
                                                    """You've successfully claimed your 10% share of the winner's pot as
                                                    delegated for uploading the winning meme ❤️
                                                    """
                                                ]

                                        ( True, False ) ->
                                            Html.div
                                                []
                                                [ Html.text
                                                    """It looks like you uploaded the winning meme 👀
                                                    """
                                                , Html.div
                                                    []
                                                    [ Html.text
                                                        """which means you've been delegated 10% of the winner's pot
                                                        """
                                                    ]
                                                , Html.div
                                                    []
                                                    [ Html.button
                                                        [ onClick <|
                                                            FromLeaderBoard <|
                                                                LeaderBoardMsg.ClaimAsUploader
                                                        ]
                                                        [ Html.text "claim winnings"
                                                        ]
                                                    ]
                                                ]

                                        _ ->
                                            Html.div
                                                []
                                                []

                                boss f =
                                    let
                                        selected =
                                            f leaderBoard.claim.wallet
                                    in
                                    case ( selected.authenticated, selected.claimed ) of
                                        ( True, True ) ->
                                            Html.div
                                                []
                                                [ Html.text
                                                    """You've successfully claimed your 10% share of the winner's pot as
                                                    delegated with boss credentials ❤️
                                                    """
                                                ]

                                        ( True, False ) ->
                                            Html.div
                                                []
                                                [ Html.text
                                                    """It looks like you've got boss credentials 👀
                                                    """
                                                , Html.div
                                                    []
                                                    [ Html.text
                                                        """which means you've been delegated 10% of the winner's pot
                                                        """
                                                    ]
                                                , Html.div
                                                    []
                                                    [ Html.button
                                                        [ onClick <|
                                                            FromLeaderBoard <|
                                                                LeaderBoardMsg.ClaimAsBoss
                                                        ]
                                                        [ Html.text "claim winnings"
                                                        ]
                                                    ]
                                                ]

                                        _ ->
                                            Html.div
                                                []
                                                []
                            in
                            Html.div
                                []
                                [ Html.div
                                    [ class "columns box-pink my-6"
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
                                        [ Html.div
                                            [ class "columns"
                                            ]
                                            [ Html.div
                                                [ class "column is-half box-pink"
                                                ]
                                                [ Html.div
                                                    [ class "mb-2"
                                                    ]
                                                    [ Html.text "Winner 🏅"
                                                    ]
                                                , Html.div
                                                    [ class "mb-2"
                                                    ]
                                                    [ Html.text <|
                                                        String.concat
                                                            [ "Pot Total"
                                                            , ": "
                                                            , "$BONK"
                                                            , " "
                                                            , leaderBoard.leader.score
                                                            ]
                                                    ]
                                                , Html.div
                                                    [ class "mb-2"
                                                    ]
                                                    [ Html.text <|
                                                        String.concat
                                                            [ "Uploaded by"
                                                            , ": "
                                                            ]
                                                    , Html.a
                                                        [ class "has-sky-blue-text"
                                                        , href <|
                                                            String.concat
                                                                [ "https://solscan.io/account/"
                                                                , leaderBoard.leader.authority.address
                                                                ]
                                                        , target "_blank"
                                                        ]
                                                        [ Html.text <|
                                                            Wallet.slice leaderBoard.leader.authority.address
                                                        ]
                                                    ]
                                                , Html.div
                                                    [ class "mt-6"
                                                    ]
                                                    [ wager
                                                    ]
                                                , Html.div
                                                    [ class "mt-6"
                                                    ]
                                                    [ uploader
                                                    ]
                                                , Html.div
                                                    [ class "mt-6"
                                                    ]
                                                    [ boss .bossOne
                                                    ]
                                                , Html.div
                                                    [ class "mt-6"
                                                    ]
                                                    [ boss .bossTwo
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
    in
    Html.div
        []
        [ Html.div
            [ style "margin-bottom" "100px"
            ]
            [ Html.h3
                [ class "is-family-secondary has-text-centered is-size-4"
                ]
                [ Html.text
                    """LEADERBOARD
                    """
                ]
            ]
        , Html.div
            []
            [ html
            ]
        ]
