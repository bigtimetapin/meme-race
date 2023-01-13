module Msg.LeaderBoard.Msg exposing (Msg(..), toString)


type Msg
    = Fetch
    | ClaimWithWager
    | ClaimAsUploader
    | ClaimAsBoss


toString : Msg -> String
toString msg =
    case msg of
        Fetch ->
            "leader-board-fetch"

        ClaimWithWager ->
            "leader-board-claim-with-wager"

        ClaimAsUploader ->
            "leader-board-claim-as-uploader"

        ClaimAsBoss ->
            "leader-board-claim-as-boss"
