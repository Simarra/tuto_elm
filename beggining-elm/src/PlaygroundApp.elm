module PlaygroundApp exposing (ShoppingList)

import Browser
import Html exposing (Html, button, div, h3, li, text, ul)
import Html.Attributes exposing (type_)
import Html.Events exposing (onClick)
import Http

import Json.Decode exposing (Decoder, Error(..), decodeString, list, string)


type alias ShoppingList =
    { articles : List String
    , errorMessages : Maybe String
    }


type Msg
    = SendHttpRequest
    | DataReceived (Result Http.Error ( List String) )

view : ShoppingList -> Html Msg
view shopList =
    div []
        [ button [ onClick SendHttpRequest, type_ "button" ]
            [ text "Obtenir la liste des courses." ]
        , viewArticlesOrError shopList        ]

viewArticlesOrError : ShoppingList -> Html Msg
viewArticlesOrError model = 
  case model.errorMessages of 
    Just message ->
      viewError message 
    Nothing ->
      viewArticles model.articles

viewError : String -> Html Msg
viewError errorMessage =
  let errorHeading = "Could not fetch articles"
  in div [] 
    [ h3 [] [text errorHeading]
    , text ( "Error:" ++ errorMessage)]

viewArticles : List String -> Html Msg
viewArticles shopList = 
  div [] [
    h3 [] [ text "List of articles"]
    , ul [] ( List.map ( \y -> li [] [ text y] ) shopList)
  ]




url : String
url =
    "http://localhost:5019/articles"


buildErrorMessages : Http.Error -> String
buildErrorMessages msg =
  case msg of
    Http.BadUrl message ->
      message
    Http.Timeout ->
      "Request timed Out"
    Http.BadBody message ->
      "Error on the Body" ++ "\n" ++ message
    Http.NetworkError ->
      "Network not available."
    Http.BadStatus message ->
      "Wrong status" ++ ( String.fromInt message ) ++ " Not expected"

getArticles : Cmd Msg
getArticles =
    Http.get
        { url = url
        , expect = Http.expectJson DataReceived articlesDecoder
        }

articlesDecoder : Decoder (List String)
articlesDecoder =
   list string

handleJsonError : Json.Decode.Error -> Maybe String
handleJsonError err =
  case err of 
    Failure errMessage _ ->
      Just errMessage
    _ ->
      Just "Generic Json error. For more detail, please implement it"
      


update : Msg -> ShoppingList -> ( ShoppingList, Cmd Msg )
update msg model =
    case msg of
        SendHttpRequest ->
            ( model, getArticles )

        DataReceived (Ok articles) ->
            ( { model | articles = articles }, Cmd.none )

        DataReceived (Err httpError) ->
            ( { model | errorMessages = Just (buildErrorMessages httpError) } , Cmd.none )


main : Program () ShoppingList Msg
main =
    Browser.element
        { init = \_ -> ( { articles = [], errorMessages = Nothing }, Cmd.none )
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
