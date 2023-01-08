module Model.State.Global.Global exposing (Global(..), default)

import Model.Degen.Degen exposing (Degen)


type Global
    = NoWalletYet
    | WalletMissing -- no browser extension found
    | HasDegen Degen


default : Global
default =
    NoWalletYet
