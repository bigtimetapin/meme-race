module View.Degen.View exposing (view)

import Html exposing (Html)
import Html.Attributes exposing (class, src)
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
                upload =
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

                form_ =
                    case newContenderForm of
                        Just dataUrl ->
                            Html.div
                                []
                                [ upload
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
                [ Html.div
                    []
                    [ form_
                    ]
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
