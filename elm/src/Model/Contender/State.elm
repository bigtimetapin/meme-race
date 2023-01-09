module Model.Contender.State exposing (State(..))

import Model.Contender.AlmostContender exposing (AlmostContender)
import Model.Contender.Contender exposing (Contender)
import Model.Contender.NewWagerForm exposing (NewWagerForm)


type State
    = Almost AlmostContender
    | Top Contender
    | NewWager NewWagerForm Contender
