module Model.State.Global.Global exposing (Global(..), default)


import Model.PublicKey exposing (PublicKey)


type Global
    = NoWalletYet
    | WalletMissing -- no browser extension found
    | HasWallet PublicKey


default : Global
default =
    NoWalletYet
