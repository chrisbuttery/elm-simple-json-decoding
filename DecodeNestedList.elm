import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Json exposing ((:=))
import Task
import String

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


-- Types


type alias Model =
  { url : String
  , result : (List Item)
  , error : Bool
  }


type alias Item =
  { name: String
  , id: Int
  }


-- MODEL


initialModel : Model
initialModel = {
  url = ""
  , result = []
  , error = False
  }


init : (Model, Cmd Msg)
init =
  (initialModel, Cmd.none)


-- UPDATE


type Msg
  = FetchData
  | FetchSucceed (List Item)
  | StoreURL String
  | FetchFail Http.Error


update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    FetchData ->
      (model, makeRequest model.url)

    FetchSucceed results ->
      ({ model | result = results, error = False }, Cmd.none)

    StoreURL url ->
      ({ model | url = url }, Cmd.none)

    FetchFail _ ->
      ({ model | error = True }, Cmd.none)


-- VIEW


renderError : Html Msg
renderError =
  p [] [ text "There was an error" ]


renderResult : Item -> Html Msg
renderResult item =
  li [] [ text ( "Item " ++ (toString item.id) ++ ": " ++ item.name) ]


renderResults : Model  -> Html Msg
renderResults model =
  ul [] (List.map renderResult model.result)


view : Model -> Html Msg
view model =
  let
    response =
      if model.error == True
      then renderError
      else renderResults model
  in
    div []
      [ h1 [] [ text "Nested list"]
      , p [] [ text "Here I want to each object nested inside of 'data'"]
      , p [] [ text "Demo URL: https://api.myjson.com/bins/1mny6"]
      , input [
          placeholder "Enter a URL",
          onInput StoreURL
        ] []
        , button [ onClick FetchData ] [ text "Fetch!" ]
        , response
        , div [] [ text (toString model) ]
      ]


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


-- HTTP


makeRequest : String -> Cmd Msg
makeRequest url =
  Task.perform FetchFail FetchSucceed (Http.get decoder url)


-- decoder
-- decode the contents of 'data' with nestedListDecoder

decoder: Json.Decoder (List Item)
decoder =
  Json.at ["data"] (Json.list nestedListDecoder)


-- nestedListDecoder
-- get the name and id from each object

nestedListDecoder : Json.Decoder Item
nestedListDecoder =
  Json.object2 Item
    ("name" := Json.string)
    ("id" := Json.int)
