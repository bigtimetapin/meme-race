module Model.LeaderBoard.State exposing (State(..))

import Model.LeaderBoard.LeaderBoard exposing (LeaderBoard)


type State
    = Almost
    | Top LeaderBoard
