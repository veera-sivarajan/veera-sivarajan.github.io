get_title () {
    echo "$1" | sed -E -e "s/\..+$//g"  -e "s/_(.)/ \u\1/g" -e "s/^(.)/\u\1/g"
}

# 3 - date  
# 2 - post title
get_link () {
    echo -ne "
    <li>
        $3:
        <a href=\"./posts/$1.html\">$2</a>
    </li>"
}

add_meta () {
    echo -ne "
<!DOCTYPE html>
<html lang=\"en\">
<link rel=\"stylesheet\" href=\"./style.css\">
<meta charset=\"UTF-8\">
<meta name=\"viewport\" content=\"initial-scale=1\">
<meta name=\"HandheldFriendly\" content=\"true\">
<meta property=\"og:title\" content=\"veera\">
<meta property=\"og:type\" content=\"website\">
<meta property=\"og:description\" content=\"Blog\">
"
}

add_meta > ./index.html

cat >> ./index.html << EOF
<title>Veera's Blog</title>
<body>
        <h1 class="heading">Core Dump</h1>
        <div class="posts">
<div class="intro">
<p>Hello, I'm Veera. I study computer science at UMass Amherst. I'm mostly interested in compilers, programming languages and operating systems. </p>
   </div>
EOF

. Random-Kural.sh 
get_kural | pandoc -t html >> ./index.html # convert kural to html 

echo "<ul>" >> ./index.html
posts=$(ls -t ./write)
mkdir -p ./posts

for file_name in $posts; do
    file_path="./write/"$file_name
    file_id="${file_path##*/}"
    post_title=$(get_title "$file_name")
    post_date=$(date -r "$file_path" "+%Y-%b-%d")
    post_link=$(get_link "${file_id%.*}" "$post_title" "$post_date")
    echo -ne "$post_link" >> ./index.html  # add post link to index
    id="${file_id%.*}" # file_name
    add_meta > ./posts/"$id".html
    pandoc "$file_path" >> ./posts/"$id".html

done

cat >> ./index.html << EOF
    </ul>
    <nav>
        <a href="https://github.com/veera-sivarajan">Github</a>
        <a href="mailto:sveera.2001@gmail.com">Email</a>
        <a href="https://linkedin.com/in/veera-sivarajan">LinkedIn</a>
    </nav>  
</div>
</body>
</html>
EOF
