module Model.Contender.State exposing (State(..))

import Model.Contender.AlmostContender exposing (AlmostContender)
import Model.Contender.Contender exposing (Contender)


type State
    = Almost AlmostContender
    | Invalid String
    | Top Contender
