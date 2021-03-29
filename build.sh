# get post title from given file name
# remove underscores, file extensions and capitalize words 
get_title () {
    echo "$1" | sed -E -e "s/\..+$//g"  -e "s/_(.)/ \u\1/g" -e "s/^(.)/\u\1/g"
}

# 3 - date  
# 2 - post title
# echoes a link for given post id
get_link () {
    echo -ne "
    <li>
        $3:
        <a href=\"./posts/$1.html\">$2</a>
    </li>"
}

# echoes required meta data for a HTML file 
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

mkdir -p ./docs/
add_meta > ./docs/index.html

# write intro to index.html
cat >> ./docs/index.html << EOF
<title>Veera's Blog</title>
<body>
        <h1 class="heading">Core Dump</h1>
    <nav>
        <a href="https://github.com/veera-sivarajan">Github</a>
        <a href="mailto:sveera.2001@gmail.com">Email</a>
        <a href="https://linkedin.com/in/veera-sivarajan">Linkedin</a>
    </nav>  
        <div class="posts">
<div class="intro">
<p>Hello, I'm Veera. I study computer science at UMass Amherst. I'm mostly interested in compilers, programming languages and operating systems. </p>
   </div>
EOF


. kural.sh  # load get_kural script
get_kural | pandoc -t html >> ./docs/index.html # convert to html and write to index

# start of post links
echo "<ul>" >> ./docs/index.html
posts=$(ls -t ./drafts) # list files sorted by newest first 
mkdir -p ./docs/posts

# iteratively read all markdown files, convert to HTML and write 
for file_name in $posts; do # iterate over every markdown file
    file_path="./drafts/"$file_name
    file_id="${file_path##*/}"
    post_title=$(get_title "$file_name")
    post_date=$(date -r "$file_path" "+%Y-%b-%d")
    post_link=$(get_link "${file_id%.*}" "$post_title" "$post_date")
    echo -ne "$post_link" >> ./docs/index.html  # add post link to index
    id="${file_id%.*}" # file_name
    add_meta > ./docs/posts/"$id".html # add meta HTML to post
    echo "<title>$post_title</title>" >> ./docs/posts/"$id".html # add post title

    # add date to post
    echo -e "<span class=\"date\">$post_date</span>" >> ./docs/posts/"$id".html 

    # convert markdown to html and append to file
    pandoc "$file_path" -t html >> ./docs/posts/"$id".html
done

# add contact details and close all tags in index.html
cat >> ./docs/index.html << EOF
    </ul>
</div>
</body>
</html>
EOF
