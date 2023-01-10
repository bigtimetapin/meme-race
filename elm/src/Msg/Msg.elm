module Msg.Msg exposing (Msg(..), resetViewport)

import Browser
import Browser.Dom as Dom
import Msg.Admin.Msg as Admin
import Msg.Contender.Msg as Contender
import Msg.Degen.Msg as Degen
import Msg.Global as FromGlobal
import Msg.Js exposing (FromJs)
import Msg.LeaderBoard.Msg as LeaderBoard
import Task
import Url


type
    Msg
    -- system
    = NoOp
    | UrlChanged Url.Url
    | LinkClicked Browser.UrlRequest
      -- wallet
    | Global FromGlobal.Global
      -- leader-board
    | FromLeaderBoard LeaderBoard.Msg
      -- contender
    | FromContender Contender.Msg
      -- degen
    | FromDegen Degen.Msg
      -- admin
    | FromAdmin Admin.Msg
      -- exception
    | CloseExceptionModal
      -- js ports
    | FromJs FromJs


resetViewport : Cmd Msg
resetViewport =
    Task.perform (\_ -> NoOp) (Dom.setViewport 0 0)
