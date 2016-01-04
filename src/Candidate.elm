module Candidate where
{-
  Candidate brief information.
-}

import Effects exposing (Effects)
import Html exposing (a, div, h2, h3, Html, i, li, p, span, text, ul)
import Html.Attributes exposing (attribute, class, height, href, src, width)
import Html.Events exposing (onClick, onKeyDown)
import Http
import Image
import Json.Decode as Json
import Task

import Debug

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
  { id = "feqkVgjJpYtjy"
  , number = 1
  , name = "张狗蛋"
  , intro = "宝坻电竞届的女神，LOL耀眼新星。张狗蛋生于大口屯，从小就展现出了她在电竞方面的独特天赋。七岁时的她就已经开始外出打野，邻居透露她曾对自家养鸡场的鸡连续补刀。"
  , image = Image.initDefault
  , votes = 50
  }

type Action 
  = Vote (Maybe Json.Value)
  | RequestVote

-- UPDATE

update : Action -> Model -> (Model, Effects Action)
update action model = 
  case action of

    Vote maybeResponse ->
      case maybeResponse of
        Nothing ->
          ( model, Effects.none )
        Just something ->
          ( { model | votes = model.votes + 1 }, Effects.none )

    RequestVote ->
      ( model, vote model )

-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  let xx = Debug.log "1" "1"
  in
  div
    [ class "grid__item", attribute "data-size" "400x400" ]
    [ a 
        [ href "http://placehold.it/400x400", class "img-wrap" ]
        [ Image.view model.image
        , div 
          [] 
          [ p [] [ text (toString model.number ++ "号  " ++ model.name) ] 
          , p [] [ text (toString model.votes ++ "票") ]
          ]
        , div 
            [ class "description description--grid" ]
            [ h3 [] [ text (toString model.number ++ "号  " ++ model.name) ] 
            , p [ onClick address RequestVote ] [ text model.intro ]
            , div 
              [ class "details" ]
              [ ul 
                  []
                  [ li
                      [] 
                      [ a [ class "hvr-grow fa fa-search", href ("/detail.html?id=" ++ model.id) ] [ span [] [ text "详细资料" ] ] ]
                  ]
              ]
            ]
        ]
    ]

-- EFFECTS

(=>) : a -> b -> (a, b)
(=>) = (,)

vote : Model -> Effects Action
vote model =
  Http.get voteResponseDecoder (voteAPI model)
    |> Task.toMaybe
    |> Task.map Vote
    |> Effects.task

{-
voteBody : Model -> Http.Body
voteBody model =
  Http.string """{ "sortBy": "coolness", "take": 10 }"""
  --Http.string ( "{ \"id\": \"" ++ model.id ++  "\" }" )
-}

voteAPI : Model -> String
voteAPI model = 
  Http.url "http://api.giphy.com/v1/gifs"
    [ "api_key" => "dc6zaTOxFJmzC"
    , "ids" => model.id
    ]

voteResponseDecoder : Json.Decoder Json.Value
voteResponseDecoder = Json.value