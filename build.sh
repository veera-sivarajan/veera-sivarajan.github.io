intro () {
    echo -ne "
    <div class="intro">
        <p>Intor para 1</p>
        <p>Intro para 2 </p>
        <p>Email links</p>
    </div>
    "
}

get_title () {
    echo "$1" | sed -E -e "s/\..+$//g"  -e "s/_(.)/ \u\1/g" -e "s/^(.)/\u\1/g"
}

get_link () {
    # 1 - id
    # 2 - title
    # 3 - date
    echo -ne "
    <tr>
        <td class="table-post">
            <div class=\"date\">
                $3
            </div>
            <a href=\"./posts/$1.html\" class=\"post-link\">
                <span class=\"post-link\">$2</span>
            </a>
        </td>
    </tr>
    "
}

cat > ./index.html << EOF
<!DOCTYPE html>
<html lang="en">
<head>
<link rel="stylesheet" href="./style.css">
<meta charset="UTF-8">
<meta name="viewport" content="initial-scale=1">
<meta name="HandheldFriendly" content="true">
<meta property="og:title" content="veera">
<meta property="og:type" content="website">
<meta property="og:description" content="Blog">
<title>Veera's Blog</title>
<body>
        <h1 class="heading">Veera's Blog</h1>
        <h4 class="subheading">Title</h4>
        <div class="posts">
        <div class="posts">
EOF

echo -ne "$(intro)<table>" >> ./index.html

posts=$(ls -t ./write)
mkdir -p ./posts

for file_name in $posts; do
    file_path="./write/"$file_name
    file_id="${file_path##*/}"
    post_title=$(get_title "$file_name")
    post_date=$(date -r "$file_path" "+%b/%d - %Y")
    post_link=$(get_link "${file_id%.*}" "$post_title" "$post_date")
    echo -ne "$post_link" >> ./index.html  # add post link to index
    id="${file_id%.*}" # file_name
    # post_html=$(pandoc "$file_path")
    echo -e "<!DOCTYPE html>" >> ./posts/"$id".html
    echo -e "<link rel=\"stylesheet\" href=\"../style.css\">" >> ./posts/"$id".html
    # echo -ne "$post_html" >> ./posts/"$id".html
    pandoc "$file_path" >> ./posts/"$id".html

done

cat >> ./index.html << EOF
    </table>
    <div class="separator"></div>
    <div class="footer">
        <a href="https://github.com/veera-sivarajan">Github</a>
        <a href="mailto:sveera.2001@gmail.com">Mail</a> 
        <a href="https://linkedin.com/in/veera-sivarajan">LinkedIn</a>
    </div>
    </div>
</div>
</body>
</html>
EOF
