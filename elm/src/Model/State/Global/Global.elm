module Model.State.Global.Global exposing (Global(..), default)

import Model.Degen.Degen exposing (Degen)
import Model.PublicKey exposing (PublicKey)


type Global
    = NoWalletYet
    | WalletMissing -- no browser extension found
    | HasWallet PublicKey
    | HasDegen PublicKey Degen


default : Global
default =
    NoWalletYet
