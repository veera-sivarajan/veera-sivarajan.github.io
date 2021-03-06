#!/bin/bash

function get_kural () {
  num=`shuf -i 1-1330 -n 1` # generate random number in range 1-1330 inclusive
  kural=`jq --argjson index "$num" '.kural[$index] | .Line1 + " " + .Line2' /home/veera/Projects/.ThirukkuralAPI/thirukkural.json | sed -e 's/^"//' -e 's/"$//'` # get thirukural from json obj
  english_trans=$(jq --argjson index "$num" '.kural[$index] | .Translation' /home/veera/Projects/.ThirukkuralAPI/thirukkural.json | sed -e 's/^"//' -e 's/"$//')

  num=$(($num+1))
  echo "> " "$num"
  echo -en '\n' # >> ./kural.md
  echo ">" "$kural" # >> ./kural.md
  echo -en '\n' # >> ./kural.md
  echo ">" "$english_trans" # >> ./kural.md
}

