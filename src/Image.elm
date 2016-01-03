module Image where
{-
  Image is defined by its width, height and source link.
-}

import Html exposing (div, Html, img)
import Html.Attributes exposing (class, height, src, width)

-- MODEL

type alias Model = 
  { width : Int
  , height : Int
  , src : String
  }

defaultSize : Int
defaultSize = 400

initDefault : Model
initDefault = 
  { width = defaultSize
  , height = defaultSize 
  , src = "http://placehold.it/" ++ toString defaultSize ++ "x" ++ toString defaultSize
  }

initWithSrc : String -> Model
initWithSrc imgUrl = Model defaultSize defaultSize imgUrl

-- UPDATE

-- VIEW
view : Model -> Html
view model =
  img [ src model.src ] []

