module App where
{-
  A list of candidates.
-}

import Candidate
import Effects exposing (Effects, Never)
import Html exposing (button, div, Html, i, span, text)
import Html.Attributes exposing (class)
import Http
import Json.Decode as Json exposing ((:=))
import Result
import StartApp
import String
import Task

-- MODEL

type alias Model = List Candidate.Model

init : (Model, Effects Action)
init = ( [], getCandidates )

initDefault : (Model, Effects Action)
initDefault = (List.repeat 10 Candidate.initDefault, Effects.none)

-- UPDATE

type Action 
  = LoadCandidates (Maybe (List Candidate.Model))
  | RequestCandidates

update : Action -> Model -> (Model, Effects Action)
update action model = 
  case action of

    LoadCandidates maybeCandidates ->
      ( Maybe.withDefault [] maybeCandidates
      , Effects.none
      )

    RequestCandidates ->
      ( model, getCandidates )


-- VIEW

{-
view : Signal.Address Action -> Model -> Html
view address model =
  div 
    [ class "container" ] 
    (List.map Candidate.view model)
-}

view : Signal.Address Action -> Model -> Html
view address model =
  div
    [ class "container" ]
    [ div 
        [ class "content" ]
        [ div
            [ class "grid" ]
            (List.map Candidate.view model)
        , div
            [ class "preview" ]
            [ button [ class "action action--close" ]
              [ i [ class "fa fa-times" ] []
              , span [ class "text-hidden" ] [ text "Close" ]
              ]
            , div [ class "description description--preview" ] []
            ]
        ]
    ]


-- EFFECTS

(=>) : a -> b -> (a, b)
(=>) = (,)

getCandidates : Effects Action
getCandidates =
  Http.get candidatesJsonDecoder candidatesAPI
    |> Task.toMaybe
    |> Task.map LoadCandidates
    |> Effects.task

-- API to get a list of candidates
candidatesAPI : String
candidatesAPI = 
  Http.url "http://api.giphy.com/v1/gifs/search"
    [ "api_key" => "dc6zaTOxFJmzC"
    , "q" => "cats"
    ]

{-
  { id : String
  , number : Int
  , name : String
  , intro : String
  , imgUrl : String
  , votes : Int
  }
-}
candidatesJsonDecoder : Json.Decoder (List Candidate.Model)
candidatesJsonDecoder = 
   "data" := (Json.list ( Json.object6 Candidate.init
                            ("id" := Json.string)
                            ( Json.map (\x -> Result.withDefault 0 (String.toInt x)) (Json.at ["images", "downsized", "height"] Json.string) )
                            ("type" := Json.string)
                            ("url" := Json.string)
                            (Json.at ["images", "downsized", "url"] Json.string)
                            ( Json.map (\x -> Result.withDefault 0 (String.toInt x)) (Json.at ["images", "downsized", "width"] Json.string) )
                        )
             )

-- MAIN

app : StartApp.App Model
app = 
  StartApp.start
    { init = initDefault
    , update = update
    , view = view
    , inputs = []
    }

main : Signal Html
main = 
  app.html

port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks
