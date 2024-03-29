module View.Hero exposing (view)

import Html exposing (Html)
import Html.Attributes exposing (class, href, style, target)
import Html.Events exposing (onClick)
import Model.State.Exception.Exception as Exception exposing (Exception)
import Model.State.Global.Global exposing (Global)
import Msg.Msg exposing (Msg(..))
import View.Footer
import View.Header


view : Exception -> Global -> Html Msg -> Html Msg
view exception global body =
    let
        modal html =
            Html.div
                [ class "modal is-active"
                ]
                [ Html.div
                    [ class "modal-background"
                    ]
                    []
                , Html.div
                    [ class "modal-content"
                    ]
                    [ html
                    ]
                , Html.button
                    [ class "modal-close is-large"
                    , onClick CloseExceptionModal
                    ]
                    []
                ]

        exceptionModal =
            case exception of
                Exception.Open message maybeHref ->
                    let
                        exception_ =
                            case maybeHref of
                                Just href_ ->
                                    case href_.internal of
                                        True ->
                                            Html.div
                                                []
                                                [ Html.div
                                                    []
                                                    [ Html.text message
                                                    ]
                                                , Html.div
                                                    []
                                                    [ Html.div
                                                        []
                                                        [ Html.text
                                                            """If you're on a mobile device & have the phantom app installed ⬇️
                                                            """
                                                        ]
                                                    , Html.a
                                                        [ class "has-sky-blue-text is-underlined"
                                                        , href href_.url
                                                        , target "_blank"
                                                        ]
                                                        [ Html.text "click here"
                                                        ]
                                                    ]
                                                , Html.div
                                                    []
                                                    [ Html.div
                                                        []
                                                        [ Html.text
                                                            """Otherwise, join the party ⬇️
                                                            """
                                                        ]
                                                    , Html.div
                                                        []
                                                        [ Html.a
                                                            [ class "has-sky-blue-text is-underlined"
                                                            , href "https://phantom.app/"
                                                            , target "_blank"
                                                            ]
                                                            [ Html.text "create new solana wallet 😎"
                                                            ]
                                                        ]
                                                    ]
                                                ]

                                        False ->
                                            Html.div
                                                []
                                                [ Html.div
                                                    []
                                                    [ Html.text message
                                                    ]
                                                , Html.div
                                                    []
                                                    [ Html.a
                                                        [ class "has-sky-blue-text"
                                                        , href href_.url
                                                        , target "_blank"
                                                        ]
                                                        [ Html.text href_.url
                                                        ]
                                                    ]
                                                ]

                                Nothing ->
                                    Html.div
                                        []
                                        [ Html.text message
                                        ]
                    in
                    modal <|
                        Html.div
                            [ class "mx-6 has-text-white"
                            ]
                            [ exception_
                            ]

                Exception.Waiting ->
                    modal <|
                        Html.div
                            [ class "is-loading"
                            ]
                            []

                Exception.Closed ->
                    Html.div
                        []
                        []
    in
    Html.section
        [ class "hero is-fullheight is-family-primary"
        ]
        [ Html.div
            [ class "hero-head"
            ]
            [ View.Header.view global
            ]
        , Html.div
            [ class "mx-6 my-6"
            ]
            [ Html.h1
                [ class "is-family-secondary has-text-centered is-size-2 mb-6"
                ]
                [ Html.text "MEME RACE"
                ]
            , body
            , exceptionModal
            ]
        , Html.div
            [ class "hero-foot mx-6"
            , style "margin-top" "100px"
            ]
            [ View.Footer.view
            ]
        ]
