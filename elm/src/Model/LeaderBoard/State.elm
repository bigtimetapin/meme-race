module Model.LeaderBoard.State exposing (State(..))

import Model.Contender.Contender exposing (Contender)


type State
    = Top (List Contender)
