module Main exposing (..)

import Model exposing (..)
import TitleLayout 
--import Wetterbericht
import Browser
import Browser.Events exposing (onClick)
import Html exposing (..)
import Html.Attributes exposing (src, class, attribute, id, href, style )
import Json.Decode as Decode
import Json.Decode exposing (Decoder, map2, map4, field, float, int, string, index)
import Http
import Svg
import Svg.Attributes exposing (style)
import Url
import Browser.Navigation as Nav
import Css exposing (..)

init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( { clickCoordinates = Nothing, apiData = "", weather = Nothing, status = Welcome , url = {url | fragment =  Just "welcome"} , key = key }, Cmd.none )



-- Update
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        {-GetClickCoordinates (x, y) ->
            update GetData { model | clickCoordinates = Just (x, y) }-}

        GetClickCoordinates (x, y) ->
            let
                updatedModel =
                    { model | clickCoordinates = Just (x, y) }
            in
            case model.status of
                Welcome ->
                    (updatedModel, Cmd.none)

                Wetterbericht ->
                    let
                        apiDataCmd =
                            Http.get
                                { url = coordsToRealCoords updatedModel
                                , expect = Http.expectString ApiDataResult
                                }
                    in
                    (updatedModel, apiDataCmd)

                Weltkarte ->
                    ({ model | status = Wetterbericht }, Cmd.none)
                   

        {-GetData ->
            let
                apiDataCmd =
                    Http.get
                        { url = coordsToRealCoords model
                        , expect = Http.expectString ApiDataResult
                        }
            in
            (model, apiDataCmd)-}

        ApiDataResult (Ok data) ->
            case Decode.decodeString weatherDecoder data of
                Ok weather ->
                    ({ model | weather = Just weather }, Cmd.none)

                Err _ ->
                    (model, Cmd.none)

        ApiDataResult (Err _) ->
            (model, Cmd.none)

        WelcomeScreenButtonPressed -> 
            let oldUrl = model.url in
            ({ model | status = Weltkarte, url =
                         { oldUrl | fragment = Just "weltkarte"}   
                         }, Cmd.none)
        {-CloseModal -> 
            let oldUrl = model.url in
            ({ model | status = Weltkarte, url =
                         { oldUrl | fragment = Just "weltkarte"}   
                         }, Cmd.none) -}

        {-OpenWetterbericht ->
            ({ model | status = Wetterbericht }, Cmd.none)-}

        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            let
                updatedModel =
                    { model | url = url }

                updatedModelWithStatus =
                    case url.fragment of
                        Just "welcome" ->
                            { updatedModel | status = Welcome }

                        Just "weltkarte" ->
                            { updatedModel | status = Weltkarte }

                        Just "wetterbericht" ->
                            { updatedModel | status = Wetterbericht }

                        _ ->
                            updatedModel
            in
                (updatedModelWithStatus, Cmd.none)

            {-case url.fragment of
                Nothing ->
                    ( { model | url =
                         { url | fragment = 
                                    case model.status of 
                                        Welcome ->
                                            Just "#welcome"
                                        Wetterbericht ->
                                            Just "#wetterbericht"
                                        Weltkarte ->
                                            Just "#weltkarte"
                         } 
                    }
                    , Cmd.none
                    )

                _ ->
                    ( { model | url = url }
                    , Cmd.none
                    )-}

                   

-- View


weatherInfo : Maybe Weather -> Html Msg
weatherInfo maybeWeather =
    case maybeWeather of
        Just weather ->
           div [class "boxNr1"]
                [ div[class "cityName"] [text weather.name]
                ,div [] [text weather.sub.description]
                , div[] [text ((String.fromFloat weather.main.temp) ++ " °C")]
              --  , div[] [button [ class "delete", Html.Attributes.attribute "aria-label" "close", onClick CloseModal]]
                ]

        Nothing ->
            div [] []


view : Model -> Browser.Document Msg
view model =
    case model.status of
        Welcome ->
            { title = "Welcome"
            , body = [ TitleLayout.view model ]
            }

        Wetterbericht ->
            { title = "Wetterbericht"
            , body =
                [ svgPng
                --, --div [] [ text (coordsToRealCoords model) ]
                , div []
                    [ {-text
                        (case model.clickCoordinates of
                            Just (x, y) ->
                                "Geklickt bei (" ++ String.fromFloat x ++ ", " ++ String.fromFloat y ++ ")"
                            Nothing ->
                                ""
                        )-}
                    ]
                , weatherInfo model.weather
                ]
            }

        Weltkarte ->
            { title = "Weltkarte"
            , body = [ svgPng ]
            }


navBar: Html Msg
navBar = 
    nav
        [ class "navbar"
        , attribute "role" "navigation"
        , attribute "aria-label" "main navigation"
        ]
        [ div
            [ id "navbarBasicExample"
            , class "navbar-menu"
            ]
            [ a [ class "navbar-item", href "#welcome" ] [ text "Welcome" ]
            , a [ class "navbar-item", href "#weltkarte" ] [ text "Weltkarte" ]
            , a [ class "navbar-item", href "#wetterbericht" ] [ text "Wetterbericht" ]
            ]
        ]

{-}        nav
        [ class "navbar"
        , attribute "role" "navigation"
        , attribute "aria-label" "main navigation"
        ]
        [div
            [ id "navbarBasicExample"
            , class "navbar-menu"
            ]
            [
              a [class "navbar-item" ][ 
                        div [ class "navbar-image-container" ]
                            [  Svg.svg [Svg.Attributes.width "1200"
                            , Svg.Attributes.height "600"
                            {-, Svg.Attributes.viewBox "0 0 2000 1000"-}
                            ] 
                            [ Svg.image [ 
                                          Svg.Attributes.width "1200"
                                          , Svg.Attributes.height "600"
                                          , Svg.Attributes.title "Weltmap"
                                          , Svg.Attributes.xlinkHref "Weltmap.png" 
                                        ] 
                                        [] 
                                ]
                            ]
                  ]
            {-, div
                [ class "navbar-start" ]
                [ a
                    [ class "navbar-item"
                    , href "#welcome"
                    ]
                    []
                , a
                    [ class "navbar-item"
                    , href "#weltkarte"
                    ]
                    []
                , a
                    [ class "navbar-item"
                    , href "#wetterbericht"
                    ]
                    []
                ]
            , div
                [ class "navbar-end" ]
                [ div
                    [ class "navbar-item" ]
                    []
                ]-}
            ]
        ]-}

svgPng : Html Msg
svgPng = 
    nav
    []
    [   div [class "pictureStyle" ][
            Svg.svg [
                Svg.Attributes.width "2560"
                , Svg.Attributes.height "1280"
               -- , Svg.Attributes.viewBox "0 0 2000 1000"
                ] 
                [ Svg.image [ 
                              Svg.Attributes.width "2560"
                              , Svg.Attributes.height "1280"
                              , Svg.Attributes.title "Weltmap"
                              , Svg.Attributes.xlinkHref "Weltmap.png" 
                            ] 
                            [] 
                ]
        ]
    ]



-- Koordinatenverarbeitung
coordsToRealCoords : Model -> String
coordsToRealCoords model =
    case model.clickCoordinates of
        Just (x, y) ->
            let
                lat = calculateLon y
                lon = calculateLat x
            in
            createAPIString lat lon

        Nothing ->
            "No coordinates available"


calculateLat : Float -> Float
calculateLat x =
     (x / 2560) * (360) - 180

calculateLon : Float -> Float
calculateLon y =
    (y / 1280) * (-180) + 90
createAPIString : Float -> Float -> String
createAPIString lat lon =
    "https://api.openweathermap.org/data/2.5/weather?lat=" ++ String.fromFloat lat ++ "&lon="++ String.fromFloat lon ++ "&appid=fd49d2ad5c202b4a099fd0ea90b77077&units=metric"

-- Subscriptions
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ onClick
            (Decode.andThen
                (\event ->
                    if isWithinClickArea event then
                        Decode.succeed (GetClickCoordinates (event.pageX, event.pageY))
                    else
                        Decode.fail "Outside click area"
                )
                (Decode.map2
                    (\pageX pageY -> { pageX = pageX, pageY = pageY })
                    (Decode.field "pageX" Decode.float)
                    (Decode.field "pageY" Decode.float)
                )
            )
        , Sub.none
        ]


isWithinClickArea : { pageX : Float, pageY : Float } -> Bool
isWithinClickArea event =
    let
        minX = 0.0
        minY = 0.0
        maxX = 2560
        maxY = 1280
    in
    event.pageX >= minX && event.pageX <= maxX && event.pageY >= minY && event.pageY <= maxY


-- Wetterfunktionen
subWeatherDecoder : Decoder SubWeather
subWeatherDecoder =
    Decode.map4 SubWeather
        (Decode.field "id" Decode.int)
        (Decode.field "main" Decode.string)
        (Decode.field "description" Decode.string)
        (Decode.field "icon" Decode.string)


weatherDecoder : Decoder Weather
weatherDecoder =
    Decode.map4 Weather
        (Decode.field "name" Decode.string)
        (Decode.field "timezone" Decode.float)
        (Decode.field "weather" (Decode.index 0 subWeatherDecoder))
        (Decode.field "main"  (Decode.map4 MainList
            (Decode.field "temp" Decode.float)
            (Decode.field "temp_min" Decode.float)
            (Decode.field "temp_max" Decode.float)
            (Decode.field "pressure" Decode.float)))

{-weatherDecoder : Decoder Weather
weatherDecoder =
    Decode.index 0 <|
        Decode.map2 Weather
        (Decode.field "name" Decode.string)
        (Decode.field "country" Decode.string)-}

main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }

   
