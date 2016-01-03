module CandidatesList where
{-
  A list of candidates.
-}

import Candidate
import Effects exposing (Effects, Never)
import Html exposing (div, Html)
import Html.Attributes exposing (class)
import Http
import Json.Decode as Json exposing ((:=))
import Result
import StartApp
import String
import Task

import Debug

-- MODEL

type alias Model = List Candidate.Model

init : (Model, Effects Action)
init = ( [], getCandidates )

-- UPDATE

type Action 
  = LoadCandidates (Maybe (List Candidate.Model))
  | RequestCandidates

update : Action -> Model -> (Model, Effects Action)
update action model = 
  case action of

    LoadCandidates maybeCandidates ->
      let
        l = List.length (Maybe.withDefault [] maybeCandidates)
        ll = Debug.log "length" l
        mbFst = List.head (Maybe.withDefault [] maybeCandidates)
        firstCandidate = (Maybe.withDefault Candidate.initDefault mbFst)
        dbg = Debug.log "result" firstCandidate.id
      in
        ( Maybe.withDefault [] maybeCandidates
        , Effects.none
        )

    RequestCandidates ->
      ( model, getCandidates )


-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  div 
    [ class "container" ] 
    (List.map Candidate.view model)


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
  Debug.log "url"
  (Http.url "http://api.giphy.com/v1/gifs/search"
    [ "api_key" => "dc6zaTOxFJmzC"
    , "q" => "cats"
    , "limit" => "10"
    ])

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
    { init = init
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
