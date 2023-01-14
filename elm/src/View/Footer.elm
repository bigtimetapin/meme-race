module View.Footer exposing (view)

import Html exposing (Html)
import Html.Attributes exposing (class, href, target)
import Msg.Msg exposing (Msg)


view : Html Msg
view =
    Html.footer
        [ class "level box-pink mb-6"
        ]
        [ Html.div
            [ class "level-item"
            ]
            [ Html.a
                [ class "has-sky-blue-text"
                , href "https://github.com/bigtimetapin/meme-race"
                , target "_blank"
                ]
                [ Html.text "github"
                ]
            ]
        , Html.div
            [ class "level-item"
            ]
            [ Html.a
                [ class "has-sky-blue-text"
                , href "https://medium.com/@memeracedotcom/how-to-meme-race-d875e966fde6"
                , target "_blank"
                ]
                [ Html.text "how-to"
                ]
            ]
        , Html.div
            [ class "level-item"
            ]
            [ Html.a
                [ class "has-sky-blue-text"
                , href "https://medium.com/@memeracedotcom/meme-race-contact-pages-44bb97a13c68"
                , target "_blank"
                ]
                [ Html.text "doxx"
                ]
            ]
        ]
