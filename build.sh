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
            <a href=\"./$1.html\" class=\"post-link\">
                <span class=\"post-link\">$2</span>
            </a>
        </td>
    </tr>
    "
}

mkdir ./blog
cat > ./blog/index.html << EOF
<!DOCTYPE html>
<html lang="en">
<head>
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

echo -ne "$(intro)<table>" >> ./blog/index.html

posts=$(ls -t ./write)

for file_name in $posts; do
    file_path="./write/"$file_name
    file_id="${file_path##*/}"
    post_title=$(get_title "$file_name")
    post_date=$(date -r "$file_path" "+%b/%d - %Y")
    post_link=$(get_link "${file_id%.*}" "$post_title" "$post_date")
    echo -ne "$post_link" >> ./blog/index.html  # add post link to index
    id="${file_id%.*}" # file_name
    post_html=$(lowdown "$file_path")
    echo -e "$post_html" >> ./blog/"$id".html

done

cat >> ./blog/index.html << EOF
    </table>
    <div class="separator"></div>
    <div class="footer">
        <a href="https://github.com/nerdypepper">Github</a>
        <a href="mailto:nerdy@peppe.rs">Mail</a> 
        <a href="https://linkedin.com/in/nerdypepper">LinkedIn</a>
    </div>
    </div>
</div>
</body>
</html>
EOF