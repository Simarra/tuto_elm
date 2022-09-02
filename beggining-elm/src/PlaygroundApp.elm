module PlaygroundApp exposing (ShoppingList)

import Browser
import Html exposing (Html, button, div, h3, li, text, ul)
import Html.Attributes exposing (type_)
import Html.Events exposing (onClick)
import Http


type alias ShoppingList =
    { articles : List String
    , errorMessages : Maybe String
    }


type Msg
    = SendHttpRequest
    | DataReceived (Result Http.Error String)

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
    "https://elm-lang.org/assets/public-opinion.txt"


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
        , expect = Http.expectString DataReceived
        }


update : Msg -> ShoppingList -> ( ShoppingList, Cmd Msg )
update msg model =
    case msg of
        SendHttpRequest ->
            ( model, getArticles )

        DataReceived (Ok articlesStr) ->
            let
                articles =
                    String.split "," articlesStr
            in
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
