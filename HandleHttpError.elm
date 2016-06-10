import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Json exposing ((:=))
import Task


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
  , error : String
  }


initialModel : Model
initialModel = {
  url = ""
  , result = ""
  , error = ""
  }


init : (Model, Cmd Msg)
init =
  (initialModel, Cmd.none)


-- UPDATE


type Msg
  = StoreURL String
  | FetchTitle
  | FetchSucceed String
  | FetchFail Http.Error


update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    StoreURL url ->
      ({ model | url = url }, Cmd.none)

    FetchTitle ->
      (model, makeRequest model.url)

    FetchSucceed str ->
      ({ model | result = str }, Cmd.none)

    -- handle Http.Error
    -- http://package.elm-lang.org/packages/evancz/elm-http/3.0.1/Http#Error
    FetchFail err ->
      case err of
        Http.Timeout ->
          ({ model | error = "Timeout" }, Cmd.none)

        Http.NetworkError ->
          ({ model | error = "Network Error" }, Cmd.none)

        Http.UnexpectedPayload error ->
          ({ model | error = error }, Cmd.none)

        Http.BadResponse code error ->
          ({ model | error = error }, Cmd.none)


-- VIEW


view : Model -> Html Msg
view model =
  let
    response =
      if model.error /= ""
      then "There was an error: " ++ model.error
      else ""
  in
    div []
      [ h1 [] [ text "Http Error"]
      , p [] [ text "Enter any random string"]
      , input [
          placeholder "Enter a URL",
          onInput StoreURL
        ] []
        , button [ onClick FetchTitle ] [ text "Fetch!" ]
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
  Task.perform FetchFail FetchSucceed (Http.get decodeTitle url)


-- decodeTitle
-- return the string from 'title'

decodeTitle : Json.Decoder String
decodeTitle =
  Json.at ["title"] Json.string
