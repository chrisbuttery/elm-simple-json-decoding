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


type alias User =
  { id: Int
  , name: String
  , avatar: String
  }


type alias Model =
  { url : String
  , result : List User
  , error : Bool
  , message : String
  }

initialModel : Model
initialModel = {
  url = ""
  , result = []
  , error = False
  , message = ""
  }


init : (Model, Cmd Msg)
init =
  (initialModel, Cmd.none)


-- UPDATE


type Msg
  = FetchData
  | FetchSucceed (List User)
  | StoreURL String
  | FetchFail Http.Error


update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    FetchData ->
      (model, makeRequest model.url)

    FetchSucceed members ->
      ({ model | result = members, error = False }, Cmd.none)

    StoreURL url ->
      ({ model | url = url }, Cmd.none)

    FetchFail err ->
      ({ model | error = True, message = toString err }, Cmd.none)


-- VIEW

renderMember members =
  ul [] (List.map (\member ->
    li [] [
      text (toString(member.id) ++ ": " ++ member.name ++ " " ++ member.avatar)
    ]
  ) members)

view : Model -> Html Msg
view model =
  let
    response =
      if model.error == True
      then "There was an error"
      else ""
  in
    div []
      [ h1 [] [ text "Oddly shaped object"]
      , p [] [ text "Here I want to grab every member's 'id', 'name' and path to their 'avatar' (nested in 'profile')"]
      , p [] [ text "Demo URL: https://api.myjson.com/bins/yws2"]
      , input [
          placeholder "Enter a URL",
          onInput StoreURL
        ] []
        , button [ onClick FetchData ] [ text "Fetch!" ]
        , p [] [ text response ]
        , renderMember model.result
        , div [] [ text (toString model) ]
      ]


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


-- HTTP


makeRequest : String -> Cmd Msg
makeRequest url =
  Task.perform FetchFail FetchSucceed (Http.get decodeMembersResponse url)


-- decodeMembersResponse
-- pluck out the members list from the makeRequest response
-- decode response with decodeMembers

decodeMembersResponse: Json.Decoder (List User)
decodeMembersResponse =
  Json.at ["members"] (Json.list decodeMembers)


-- decodeMembers
-- pluck out the id, name, name and avatar for each member

decodeMembers : Json.Decoder User
decodeMembers =
  Json.object3 User
    ("id" := Json.int)
    ("name" := Json.string)
    ("profile" := decodeAvatar)


-- decodeAvatar
-- pluck the avatar from profile

decodeAvatar : Json.Decoder String
decodeAvatar =
  Json.at ["avatar"] Json.string
