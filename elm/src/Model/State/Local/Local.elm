module Model.State.Local.Local exposing (..)

import Html
import Html.Attributes
import Model.Admin.State as Admin
import Model.Contender.State as Contender
import Model.Degen.State as Degen
import Model.LeaderBoard.State as LeaderBoard
import Url
import Url.Parser as UrlParser exposing ((</>))


type Local
    = Error String
    | LeaderBoard LeaderBoard.State
    | Degen Degen.State
    | Contender Contender.State
    | Admin Admin.State


urlParser : UrlParser.Parser (Local -> c) c
urlParser =
    UrlParser.oneOf
        [ -- almost contender
          UrlParser.map
            (\s -> Contender <| Contender.Almost <| { pda = s })
            (UrlParser.s "contender" </> UrlParser.string)

        -- leader board
        , UrlParser.map
            (LeaderBoard <| LeaderBoard.Almost)
            UrlParser.top

        -- invalid literal
        , UrlParser.map
            (Error "Invalid state; Click to homepage.")
            (UrlParser.s "invalid")

        -- admin
        , UrlParser.map
            (Admin <| Admin.Top)
            (UrlParser.s "admin")
        ]


parse : Url.Url -> Local
parse url =
    let
        target =
            -- The RealWorld spec treats the fragment like a path.
            -- This makes it *literally* the path, so we can proceed
            -- with parsing as if it had been a normal path all along.
            { url | path = Maybe.withDefault "" url.fragment, fragment = Nothing }
    in
    case UrlParser.parse urlParser target of
        Just state ->
            state

        Nothing ->
            Error "404; Invalid Path"


path : Local -> String
path local =
    case local of
        Contender (Contender.Almost almost) ->
            String.concat
                [ "#/contender/"
                , almost.pda
                ]

        LeaderBoard LeaderBoard.Almost ->
            "#/"

        _ ->
            "#/invalid"


href : Local -> Html.Attribute msg
href local =
    Html.Attributes.href (path local)
