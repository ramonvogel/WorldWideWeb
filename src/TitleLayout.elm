module TitleLayout exposing (..)

import Model exposing (..)
import Element exposing (..)
import Element.Border as Border
import Element.Font as Font
import Html exposing (Html, div, img, a, nav)
import Html.Attributes exposing (src, class, attribute, id, href )
import Browser
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Input as Input






backgroundImage : String
backgroundImage =
    "https://upload.wikimedia.org/wikipedia/commons/thumb/2/23/Blue_Marble_2002.png/2560px-Blue_Marble_2002.png"

backgroundPosition : String
backgroundPosition =
    "center" -- Adjust the position as needed



view : Model -> Html Msg
view model =
    layout [ width fill, padding 50 , Background.image backgroundImage] <|
        column [ spacing 40, width fill ]
            [ el [ centerX, centerY, padding 50 , width fill ] <|
                 paragraph
                [ Font.size 56,Font.color color.white, Font.center ]
                [ text "Wetter "
                , el [ Font.italic ] <| text "aus"
                , text " aller Welt!"
                ]     
            , Input.button
                [ padding 10 , centerX, centerY
                , Border.width 3
                , Border.rounded 6
                , Border.color color.blue
                , Background.color color.lightBlue
                , Font.variant Font.smallCaps
                , mouseDown
                    [ Background.color color.blue
                    , Border.color color.blue
                    , Font.color color.white
                    ]
                , mouseOver
                    [ Background.color color.white
                    , Border.color color.lightGrey
                    ]
                ]
                { onPress = Just WelcomeScreenButtonPressed, label = text "zur Weltkarte" }
            ]  

            
color =
    { blue = rgb255 0x72 0x9F 0xCF
    , darkCharcoal = rgb255 0x2E 0x34 0x36
    , lightBlue = rgb255 0xC5 0xE8 0xF7
    , lightGrey = rgb255 0xE0 0xE0 0xE0
    , white = rgb255 0xFF 0xFF 0xFF}