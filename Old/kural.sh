#!/bin/bash

# TODO find a database with better english translations
function get_kural () {
    num=`shuf -i 1-1330 -n 1` # generate random number in range 1-1330 inclusive
    line1=$(jq --argjson index "$num" -r '.kural[$index] | .Line1' thirukkural.json)
    line2=$(jq --argjson index "$num" -r '.kural[$index] | .Line2' thirukkural.json)
    explain=$(jq --argjson index "$num" -r '.kural[$index] | .explanation' thirukkural.json)

    number=$(($num+1))
    echo "> " "Kural $number"
    echo -en '\n' # >> ./kural.md
    echo ">" "$line1" # >> ./kural.md
    echo ">" "$line2" # >> ./kural.md
    echo -en '\n' # >> ./kural.md
    echo ">" "$explain" # >> ./kural.md
}

