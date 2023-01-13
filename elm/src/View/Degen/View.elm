module View.Degen.View exposing (view)

import Html exposing (Html)
import Html.Attributes exposing (class, href, src, target)
import Html.Events exposing (onClick)
import Model.Contender.Contender exposing (Contender)
import Model.Contender.State as ContenderState
import Model.Degen.State exposing (State(..))
import Model.LeaderBoard.State as LeaderBoardState
import Model.State.Local.Local as Local
import Model.Wager exposing (Wager)
import Model.Wallet as Wallet
import Msg.Degen.Msg as DegenMsg
import Msg.Msg exposing (Msg(..))
import View.Generic.Contender.View


view : State -> Html Msg
view state =
    case state of
        Top degen ->
            let
                contender =
                    case degen.contender of
                        Just c ->
                            Html.div
                                [ class "columns box-pink"
                                ]
                                [ Html.div
                                    [ class "column is-half"
                                    ]
                                    [ Html.text
                                        """You've successfully added a meme to race 💰
                                        """
                                    , Html.div
                                        [ class "my-6"
                                        ]
                                        [ Html.text
                                            """Anyone can place a wager on your meme . . . including yourself 😉
                                            """
                                        ]
                                    , Html.div
                                        [ class "mb-6"
                                        ]
                                        [ Html.text
                                            """Share your
                                            """
                                        , Html.a
                                            [ class "has-sky-blue-text"
                                            , target "_blank"
                                            , Local.href <|
                                                Local.Contender <|
                                                    ContenderState.Almost
                                                        { pda = c.pda
                                                        }
                                            ]
                                            [ Html.text
                                                """contender-url
                                                """
                                            ]
                                        , Html.text
                                            """ on your socials & coordinate with your friends for initial discovery
                                            """
                                        ]
                                    , Html.div
                                        []
                                        [ Html.text
                                            """If you can collect enough wagers you'll end up on the
                                            """
                                        , Html.a
                                            [ class "has-sky-blue-text"
                                            , Local.href <|
                                                Local.LeaderBoard <|
                                                    LeaderBoardState.Almost
                                            ]
                                            [ Html.text "leader-board 🏆"
                                            ]
                                        ]
                                    ]
                                , Html.div
                                    [ class "column is-half"
                                    ]
                                    [ View.Generic.Contender.View.singleton c
                                    ]
                                ]

                        Nothing ->
                            Html.div
                                [ class "box-pink"
                                ]
                                [ Html.div
                                    [ class "mb-3"
                                    ]
                                    [ Html.text
                                        """Looks like you haven't added a meme to the race 😵
                                        """
                                    ]
                                , Html.div
                                    []
                                    [ Html.button
                                        [ class "button"
                                        , onClick <|
                                            FromDegen <|
                                                DegenMsg.StartNewContenderForm
                                                    degen
                                        ]
                                        [ Html.text "Upload meme 😎"
                                        ]
                                    ]
                                ]
            in
            Html.div
                [ class "mt-6"
                ]
                [ contender
                , Html.div
                    [ class "mt-6"
                    ]
                    [ viewWagers degen.wagers
                    ]
                ]

        NewContender newContenderForm degen ->
            let
                shadowBalance =
                    Html.div
                        []
                        [ Html.div
                            []
                            [ Html.text
                                """Your
                                """
                            , Html.a
                                [ class "has-sky-blue-text"
                                , href "https://solscan.io/token/SHDWyBxihqiCj6YekG2GUr7wqKLeLAMK1gHZck9pL6y"
                                , target "_blank"
                                ]
                                [ Html.text "$SHDW"
                                ]
                            , Html.text <|
                                String.concat
                                    [ " "
                                    , "balance"
                                    , ": "
                                    , String.fromFloat (Basics.toFloat degen.shadow.balance / 1000000000)
                                    ]
                            ]
                        ]

                upload =
                    case degen.shadow.balance >= 250000000 of
                        True ->
                            Html.div
                                []
                                [ Html.button
                                    [ onClick <|
                                        FromDegen <|
                                            DegenMsg.SelectMeme degen
                                    ]
                                    [ Html.text "select meme to upload"
                                    ]
                                ]

                        False ->
                            Html.div
                                []
                                [ Html.div
                                    []
                                    [ Html.text
                                        """It looks like you have an insufficient $SHDW balance 👀
                                        """
                                    ]
                                , Html.div
                                    []
                                    [ Html.text
                                        """We are using
                                        """
                                    , Html.a
                                        [ class "has-sky-blue-text"
                                        , href "https://docs.genesysgo.com/shadow/shadow-drive/before-you-begin"
                                        , target "_blank"
                                        ]
                                        [ Html.text "shadow-drive"
                                        ]
                                    , Html.text
                                        """ for decentralized storage of the meme you're gonna upload 🤪
                                        """
                                    ]
                                , Html.div
                                    []
                                    [ Html.text
                                        """Before uploading we require a minimum balance of 0.25 $SHDW which is
                                        equivalent to 1GB of permanent storage on the network.
                                        """
                                    ]
                                , Html.div
                                    []
                                    [ Html.text
                                        """Why this requirement? Because the max upload size is 1GB & we want your
                                        transaction to land the first time. Also, we're *long* $SHDW & you should be too.
                                        """
                                    ]
                                , Html.div
                                    []
                                    [ Html.a
                                        [ class "has-sky-blue-text"
                                        , href "https://jup.ag/swap/SOL-SHDW"
                                        , target "_blank"
                                        ]
                                        [ Html.text "$SOL --> $SHDW"
                                        ]
                                    ]
                                , Html.div
                                    []
                                    [ Html.button
                                        [ onClick <|
                                            FromDegen <|
                                                DegenMsg.RefreshShadowBalance
                                        ]
                                        [ Html.text "refresh"
                                        ]
                                    ]
                                ]

                form_ =
                    case newContenderForm of
                        Just dataUrl ->
                            Html.div
                                []
                                [ upload
                                , Html.div
                                    []
                                    [ Html.button
                                        [ onClick <|
                                            FromDegen <|
                                                DegenMsg.AddNewContender dataUrl
                                        ]
                                        [ Html.text
                                            """upload meme!
                                            """
                                        ]
                                    ]
                                , Html.div
                                    []
                                    [ Html.img
                                        [ src dataUrl
                                        ]
                                        []
                                    ]
                                ]

                        Nothing ->
                            Html.div
                                []
                                [ upload
                                ]
            in
            Html.div
                []
                [ shadowBalance
                , form_
                , Html.div
                    [ class "mt-6"
                    ]
                    [ viewWagers degen.wagers
                    ]
                ]


viewWagers : List Wager -> Html Msg
viewWagers wagers =
    case wagers of
        [] ->
            Html.div
                []
                []

        nel ->
            let
                row w =
                    Html.tr
                        []
                        [ Html.td
                            []
                            [ Html.text w.wagerSizeFormatted
                            , Html.div
                                []
                                [ Html.a
                                    [ class "has-sky-blue-text"
                                    , Local.href <|
                                        Local.Contender <|
                                            ContenderState.Almost
                                                { pda = w.contender.pda
                                                }
                                    ]
                                    [ Html.text "add to your wager 🤔"
                                    ]
                                ]
                            ]
                        , Html.td
                            []
                            [ Html.text w.wagerPercentage
                            ]
                        , Html.td
                            []
                            [ Html.text <| String.fromInt w.wagerCount
                            ]
                        , Html.td
                            []
                            [ Html.a
                                [ class "has-sky-blue-text"
                                , href <|
                                    String.concat
                                        [ "https://solscan.io/account/"
                                        , w.contender.uploader
                                        ]
                                , target "_blank"
                                ]
                                [ Html.text <|
                                    Wallet.slice w.contender.uploader
                                ]
                            ]
                        , Html.td
                            []
                            [ Html.img
                                [ src w.contender.url
                                ]
                                []
                            ]
                        ]
            in
            Html.div
                [ class "box-pink"
                ]
                [ Html.h3
                    [ class "mt-6 mb-3 is-family-secondary"
                    ]
                    [ Html.text "Here's your wager list you degen \u{1FAE1}"
                    ]
                , Html.div
                    []
                    [ Html.table
                        [ class "table"
                        ]
                        [ Html.thead
                            []
                            [ Html.tr
                                []
                                [ Html.th
                                    []
                                    [ Html.text "your wager 🌱"
                                    ]
                                , Html.th
                                    []
                                    [ Html.text "your wager pct of total ➗"
                                    ]
                                , Html.th
                                    []
                                    [ Html.text "# of sub-wagers 🔄"
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
                                    [ Html.text "wager total 💰"
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
                        , Html.tbody
                            []
                          <|
                            List.map
                                row
                                nel
                        ]
                    ]
                ]
