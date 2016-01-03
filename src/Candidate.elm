module Candidate where
{-
  Candidate brief information.
-}

import Html exposing (a, div, h2, h3, Html, i, li, p, span, text, ul)
import Html.Attributes exposing (attribute, class, height, href, src, width)
import Image

-- MODEL

type alias Model = 
  { id : String
  , number : Int
  , name : String
  , intro : String
  , image : Image.Model
  , votes : Int
  }

init : String -> Int -> String -> String -> String -> Int -> Model
init id number name intro imgUrl votes = 
  { id = id
  , number = number
  , name = name
  , intro = intro
  , image = Image.initWithSrc imgUrl
  , votes = votes
  }

initDefault : Model
initDefault =   
  { id = "9cyvbwecx7z6"
  , number = 1
  , name = "张狗蛋"
  , intro = "宝坻电竞届的女神，LOL耀眼新星。张狗蛋生于大口屯，从小就展现出了她在电竞方面的独特天赋。七岁时的她就已经开始外出打野，邻居透露她曾对自家养鸡场的鸡连续补刀。"
  , image = Image.initDefault
  , votes = 50
  }

-- UPDATE


-- VIEW

view : Model -> Html
view model =
  div
    [ class "grid__item", attribute "data-size" "400x400" ]
    [ a 
        [ href "http://placehold.it/400x400", class "img-wrap" ]
        [ Image.view model.image 
        , div 
            [ class "description description--grid" ]
            [ h3 [] [ text (toString model.number ++ "号  " ++ model.name) ] 
            , p [] [ text model.intro ]
            , div 
              [ class "details" ]
              [ ul 
                  []
                  [ li 
                      [] 
                      [ a [ class "hvr-grow fa fa-thumbs-o-up", href "#"] [ span [] [ text "投她一票" ] ] ]
                  , li
                      [] 
                      [ a [ class "hvr-grow fa fa-search", href "#"] [ span [] [ text "详细资料" ] ] ]
                  ]
              ]
            ]
        ]
    ]

{-
view : Model -> Html
view model =
  div 
    [ class "col-md-4" ]
    [ div
        [ class "col-md-6" ]
        [ div
            [ class "text-align: left" ]
            [ h2 [] [ text (toString model.number ++ "号") ] ]
        ]
    , div
        [ class "col-md-6" ]
        [ div
            [ class "text-align: right" ]
            [ h2 [] [ text model.name ] ]
        ]
    , Image.view model.image 
    , p [] [ text model.intro ]
    , p [] [ text (toString model.votes ++ "票")]
    ]
-}