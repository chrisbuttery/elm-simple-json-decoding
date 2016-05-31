import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Json exposing ((:=))
import Task

-- https://api.myjson.com/bins/1mny6

-- {
--   "title": "This is an amazing title",
--   "data": [
--     {
--       "id": 1,
--       "name": "foo"
--     },
--     {
--       "id": 2,
--       "name": "bar"
--     },
--     {
--       "id": 3,
--       "name": "baz"
--     }
--   ],
--   "obj": {
--     "title": "I'm a nested object"
--   }
-- }

main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL


type alias Model =
  { url : String
  , result : String
  }


initialModel : Model
initialModel = {
  url = ""
  , result = ""
  }


init : (Model, Cmd Msg)
init =
  (initialModel, Cmd.none)


-- UPDATE


type Msg
  = FetchTitle
  | FetchSucceed String
  | StoreURL String
  | FetchFail Http.Error


update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    FetchTitle ->
      (model, makeRequest model.url)

    FetchSucceed str ->
      ({ model | result = str }, Cmd.none)

    StoreURL url ->
      ({ model | url = url }, Cmd.none)

    FetchFail _ ->
      (model, Cmd.none)


-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ input [
        placeholder "Enter a URL",
        onInput StoreURL
      ] []
      , button [ onClick FetchTitle ] [ text "Fetch!" ]
      , div [] [ text (toString model) ]
    ]


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


-- HTTP


makeRequest : String -> Cmd Msg
makeRequest url =
  Task.perform FetchFail FetchSucceed (Http.get decodeTitle url)


decodeTitle : Json.Decoder String
decodeTitle =
  Json.at ["title"] Json.string
