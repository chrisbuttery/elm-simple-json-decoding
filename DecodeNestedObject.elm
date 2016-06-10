import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Json exposing ((:=))
import Task

-- https://api.myjson.com/bins/yws2

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
--   },
--   "members": [
--     {
--       "id": 4,
--       "name": "garply",
--       "profile": {
--         "avatar": "some_path_to_garply"
--       }
--     },
--     {
--       "id": 5,
--       "name": "waldo",
--       "profile": {
--         "avatar": "some_path_to_waldo"
--       }
--     },
--     {
--       "id": 6,
--       "name": "fred",
--       "profile": {
--         "avatar": "some_path_to_fred"
--       }
--     }
--   ]
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
  , error : Bool
  }

initialModel : Model
initialModel = {
  url = ""
  , result = ""
  , error = False
  }


init : (Model, Cmd Msg)
init =
  (initialModel, Cmd.none)


-- UPDATE


type Msg
  = StoreURL String
  | FetchData
  | FetchSucceed String
  | FetchFail Http.Error


update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    StoreURL url ->
      ({ model | url = url }, Cmd.none)

    FetchData ->
      (model, makeRequest model.url)

    FetchSucceed str ->
      ({ model | result = str, error = False }, Cmd.none)

    FetchFail _ ->
      ({ model | error = True }, Cmd.none)


-- VIEW


view : Model -> Html Msg
view model =
  let
    response =
      if model.error == True
      then "There was an error"
      else if model.result /= ""
      then "I just found: " ++ model.result
      else ""
  in
    div []
      [ h1 [] [ text "Nested object"]
      , p [] [ text "Here I want to grab the nested 'title' from 'obj'"]
      , p [] [ text "Demo URL: https://api.myjson.com/bins/1mny6"]
      , input [
          placeholder "Enter a URL",
          onInput StoreURL
        ] []
        , button [ onClick FetchData ] [ text "Fetch!" ]
        , p [] [ text response ]
        , div [] [ text (toString model) ]
      ]


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


-- HTTP


makeRequest : String -> Cmd Msg
makeRequest url =
  Task.perform FetchFail FetchSucceed (Http.get decodeNestedObject url)

-- decodeNestedObject
-- return at the value from 'obj' > 'title'

decodeNestedObject : Json.Decoder String
decodeNestedObject =
    Json.at ["obj", "title"] Json.string
