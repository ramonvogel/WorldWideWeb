module Model exposing (..)

import Http
import Html exposing (..)
import Url
import Browser.Navigation as Nav
import Browser

type alias Model =
    { clickCoordinates : Maybe (Float, Float)
    , apiData : String
    , weather : Maybe Weather
    , status : Status
    , key : Nav.Key
    , url : Url.Url
    }

type alias Document msg =
  { title : String
  , body : List (Html msg)
  }

type alias Weather =
    { name : String
    , timezone : Float
    , sub : SubWeather
    , main : MainList
    }

type alias SubWeather =
    { id : Int
    , main : String
    , description : String
    , icon : String
    }

type alias MainList =
    { temp : Float
    , temp_min : Float
    , temp_max : Float
    , pressure : Float
    }

type Status
 = Welcome 
 | Weltkarte
 | Wetterbericht

type Msg
    = GetClickCoordinates (Float, Float)
    --| GetData
    | ApiDataResult (Result Http.Error String)
    | WelcomeScreenButtonPressed
  --  | OpenWetterbericht
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    --| ClickedOnMap
  --  | CloseModal
