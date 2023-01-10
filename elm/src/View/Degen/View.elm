module View.Degen.View exposing (view)

import Html exposing (Html)
import Html.Attributes exposing (class, href, src, target)
import Html.Events exposing (onClick)
import Model.Contender.State as ContenderState
import Model.Degen.State exposing (State(..))
import Model.State.Local.Local as Local
import Model.Wager exposing (Wager)
import Msg.Degen.Msg as DegenMsg
import Msg.Msg exposing (Msg(..))


view : State -> Html Msg
view state =
    case state of
        Top degen ->
            let
                contender =
                    case degen.contender of
                        Just c ->
                            let
                                wager =
                                    case c.wager of
                                        Just w ->
                                            Html.div
                                                []
                                                [ Html.text <|
                                                    String.concat
                                                        [ "$BONK"
                                                        , " "
                                                        , w
                                                        , " "
                                                        , "wagered by yourself on your own meme you dirty dog 😷"
                                                        ]
                                                ]

                                        Nothing ->
                                            Html.div
                                                []
                                                []
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
                                                    , c.score
                                                    , " "
                                                    , "wagered on your meme by the community"
                                                    ]
                                            ]
                                        , wager
                                        ]
                                    , Html.div
                                        [ class "column is-half"
                                        ]
                                        [ Html.img
                                            [ src c.url
                                            ]
                                            []
                                        ]
                                    ]
                                ]

                        Nothing ->
                            Html.div
                                []
                                [ Html.div
                                    []
                                    [ Html.text
                                        """Looks like you haven't added a meme to the race 😵
                                        """
                                    ]
                                , Html.div
                                    []
                                    [ Html.button
                                        [ onClick <|
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
                []
                [ contender
                , viewWagers degen.wagers
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
                , viewWagers degen.wagers
                ]


viewWagers : List Wager -> Html Msg
viewWagers wagers =
    case wagers of
        [] ->
            Html.div
                []
                []

        nel ->
            Html.div
                []
                [ Html.h3
                    []
                    [ Html.text "Here's your wager list you degen \u{1FAE1}"
                    ]
                , Html.div
                    []
                  <|
                    List.map
                        (\w ->
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
                                                    , w.wagerSizeFormatted
                                                    , " "
                                                    , "wagered in total"
                                                    ]
                                            ]
                                        , Html.div
                                            []
                                            [ Html.text <|
                                                String.concat
                                                    [ "distributed over"
                                                    , String.fromInt w.wagerCount
                                                    , " "
                                                    , "total wagers placed"
                                                    ]
                                            ]
                                        , Html.div
                                            []
                                            [ Html.a
                                                [ Local.href <|
                                                    Local.Contender <|
                                                        ContenderState.Almost
                                                            { pda = w.contender.pda
                                                            }
                                                ]
                                                [ Html.text "add to your wager 🤔"
                                                ]
                                            ]
                                        ]
                                    , Html.div
                                        [ class "column is-half"
                                        ]
                                        [ Html.div
                                            []
                                            [ Html.img
                                                [ src w.contender.url
                                                ]
                                                []
                                            ]
                                        ]
                                    ]
                                ]
                        )
                        nel
                ]
