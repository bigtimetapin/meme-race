module Model.Degen.State exposing (State(..))

import Model.Degen.Degen exposing (Degen)
import Model.Degen.NewContenderForm exposing (NewContenderForm)


type State
    = Top Degen
    | NewContender NewContenderForm Degen
