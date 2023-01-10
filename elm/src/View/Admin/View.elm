module View.Admin.View exposing (view)

import Html exposing (Html)
import Html.Events exposing (onClick)
import Msg.Admin.Msg as AdminMsg
import Msg.Msg exposing (Msg(..))


view : Html Msg
view =
    Html.div
        []
        [ Html.button
            [ onClick <|
                FromAdmin <|
                    AdminMsg.Init
            ]
            [ Html.text
                """init
                """
            ]
        ]
