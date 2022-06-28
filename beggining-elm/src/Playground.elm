module Playground exposing (main)

import Html
-- import String exposing (length) -> Usage: length "coucou"
-- import String -> Usage: String.length "coucou"


computeSpeed distance time =
    distance / time


computeTime startTime endTime =
    endTime - startTime


escapeEarth myVelocity mySpeed fuelStatus =
    let
        escapeVelocityInKmPerSec =
            11.186
        orbitalSpeedInKmPerSec =
            7.67
        whereToLand  =
            if fuelStatus == "low" then
                "Land on droneship"

            else
                "Land on launchpad"
    in
    if myVelocity > escapeVelocityInKmPerSec then
        "Godspeed"

    else if mySpeed == orbitalSpeedInKmPerSec then
        "Stay in orbit"

    else
        whereToLand 


escapeEarth myVelocity mySpeed =
    let
        escapeVelocityInKmPerSec =
            11.186

        orbitalSpeedInKmPerSec =
            7.67
    in
    if myVelocity > escapeVelocityInKmPerSec then
        "Godspeed"

    else if mySpeed == orbitalSpeedInKmPerSec then
        "Stay in orbit"

    else
        "Come back"

add a b =
    a + b


multiply c d =
    c * d


divide e f =
    e / f

-- UGGLY
String.filter (\x -> if x == 'o' then True else False) "coucou"

-- NICE
String.filter ((==) 'o') "coucou"

main =
    -- UGGLY: Html.text (escapeEarth 11 (computeSpeed 7.67 (computeTime 2 3)))
    computeTime 2 3
        |> computeSpeed 7.67
        |> escapeEarth 11
        |> Html.text
--     UGGLY Html.text (
-- 	String.fromFloat (
-- 		add 5 (
-- 		multiply 10 (
-- 		divide 30 10)
-- 		)))
    divide 30 10
        |> multiply 10
	|> add 5
	|> String.fromFloat
	|> Html.text

    Html.text
        <| String.fromFloat
	<| add 5
	<| multiply 10
	<| divide 30 10

    escapeEarth 10 6.7 "low"
        |> Html.text