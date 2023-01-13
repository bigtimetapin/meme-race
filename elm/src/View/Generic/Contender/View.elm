module View.Generic.Contender.View exposing (singleton)

import Html exposing (Html)
import Html.Attributes exposing (class, href, src, target)
import Model.Contender.Contender exposing (Contender)
import Model.Contender.State as ContenderState
import Model.State.Local.Local as Local
import Model.Wallet as Wallet
import Msg.Msg exposing (Msg)


singleton : Contender -> Html Msg
singleton contender =
    let
        ( wager, wagerPct ) =
            getWager contender
    in
    Html.div
        []
        [ Html.table
            [ class "table"
            ]
            [ Html.tbody
                []
                [ Html.tr
                    []
                    [ Html.td
                        []
                        [ Html.text "wager total 💰"
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
                ]
            ]
        ]


getWager : Contender -> ( Html Msg, Html Msg )
getWager contender =
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



-- row contender =
--     Html.table
--             [ class "table"
--             ]
--             [ Html.thead
--                 []
--                 [ Html.tr
--                     []
--                     [ Html.th
--                         []
--                         [ Html.text "wager total 💰"
--                         ]
--                     , Html.th
--                         []
--                         [ Html.text "your wager 🌱"
--                         ]
--                     , Html.th
--                         []
--                         [ Html.text "your wager pct ➗"
--                         ]
--                     , Html.th
--                         []
--                         [ Html.text "uploader 📩"
--                         ]
--                     , Html.th
--                         []
--                         [ Html.text "meme 😄"
--                         ]
--                     ]
--                 ]
--             , Html.tbody
--                 []
--                 [ Html.tr
--                     []
--                     [ Html.td
--                         []
--                         [ Html.text <|
--                             String.concat
--                                 [ "$BONK"
--                                 , ": "
--                                 , contender.score
--                                 ]
--                         ]
--                         , Html.td
--                             []
--                             [ wager
--                             ]
--                         , Html.td
--                             []
--                             [ wagerPct
--                             ]
--                         , Html.td
--                             []
--                             [ Html.a
--                                 [ class "has-sky-blue-text"
--                                 , href <|
--                                     String.concat
--                                         [ "https://solscan.io/account/"
--                                         , contender.authority.address
--                                         ]
--                                 , target "_blank"
--                                 ]
--                                 [ Html.text <|
--                                     Wallet.slice contender.authority.address
--                                 ]
--                             ]
--                         , Html.td
--                             []
--                             [ Html.a
--                                 [ Local.href <|
--                                     Local.Contender <|
--                                         ContenderState.Almost <|
--                                             { pda = contender.pda }
--                                 ]
--                                 [ Html.img
--                                     [ src contender.url
--                                     ]
--                                     []
--                                 ]
--                             ]
--                     ]
--                 ]
--             ]
