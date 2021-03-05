#!/bin/bash

function get_kural () {
  num=`shuf -i 1-1330 -n 1` # generate random number in range 1-1330 inclusive
  # num=$((${1:-${randNum}}-1)) # use argument or random number-1
  oneTag='> '
  echo ${oneTag}$((${num})) > ./kural.md # write s.no to file
  echo -en '\n' >> ./kural.md
  # tag='## ' 
  line=`jq --argjson index "$num" '.kural[$index] | .Line1 + " " + .Line2' /home/veera/Projects/.ThirukkuralAPI/thirukkural.json | sed -e 's/^"//' -e 's/"$//'` # get thirukural from json obj
  fullLine=${tag}${line}
  dash="- "


  # get all translations
  # trans1=$(jq --argjson index "$num" '.kural[$index] | .mk' /home/veera/Projects/.ThirukkuralAPI/thirukkural.json | sed -e 's/^"//' -e 's/"$//')
  # trans2=$(jq --argjson index "$num" '.kural[$index] | .sp' /home/veera/Projects/.ThirukkuralAPI/thirukkural.json | sed -e 's/^"//' -e 's/"$//')
  # trans3=$(jq --argjson index "$num" '.kural[$index] | .mv' /home/veera/Projects/.ThirukkuralAPI/thirukkural.json | sed -e 's/^"//' -e 's/"$//')
  trans4=$(jq --argjson index "$num" '.kural[$index] | .Translation' /home/veera/Projects/.ThirukkuralAPI/thirukkural.json | sed -e 's/^"//' -e 's/"$//')

  echo ">" "$line" >> ./kural.md
  echo -en '\n' >> ./kural.md
  echo ">" "$trans4" >> ./kural.md
  #append all details to the file
  # echo ${fullLine} >> /home/veera/Projects/.ThirukkuralAPI/kural.md
  # echo ${dash}${trans1} >> /home/veera/Projects/.ThirukkuralAPI/kural.md
  # echo ${dash}${trans2} >> /home/veera/Projects/.ThirukkuralAPI/kural.md
  # echo ${dash}${trans3} >> /home/veera/Projects/.ThirukkuralAPI/kural.md
  # echo ${dash}${trans4} >> /home/veera/Projects/.ThirukkuralAPI/kural.md

  # # open the file in okular
  # open=`ps -fe | grep "okular /home/veera/Projects/.ThirukkuralAPI/kural.md" | grep -vc grep`
  # if [ $open -eq 0 ]; then
  #     (okular /home/veera/Projects/.ThirukkuralAPI/kural.md &)
  # fi
}

