get_title () {
    echo "$1" | sed -E -e "s/\..+$//g"  -e "s/_(.)/ \u\1/g" -e "s/^(.)/\u\1/g"
}

# get_link () {
#     # 1 - id
#     # 2 - title
#     # 3 - date
#     echo -ne "
#     <tr>
#         <td class="table-post">
#             <div class=\"date\">
#                 $3
#             </div>
#             <a href=\"./posts/$1.html\" class=\"post-link\">
#                 <span class=\"post-link\">$2</span>
#             </a>
#         </td>
#     </tr>
#     "
# }

get_link () {
    echo -ne "
    <li>
        $3:
        <a href=\"./posts/$1.html\">$2</a>
    </li>"
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
        <div class="posts">
        <div class="posts">
<div class="intro">
<p>Hello, I'm Veera. I study computer science at UMass Amherst. I'm mostly interested in compilers, programming languages and operating systems. </p>
   </div>
EOF

. Random-Kural.sh 
get_kural
pandoc kural.md >> ./index.html
cat >> ./index.html << EOF
<ul>
EOF
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
    # post_html=$(pandoc "$file_path")
    echo -e "<!DOCTYPE html>" > ./posts/"$id".html
    echo -e "<link rel=\"stylesheet\" href=\"../style.css\">" >> ./posts/"$id".html
    # echo -ne "$post_html" >> ./posts/"$id".html
    pandoc "$file_path" >> ./posts/"$id".html

done

cat >> ./index.html << EOF
    </ul>
    <nav>
        <a href="https://github.com/veera-sivarajan">Github</a>&emsp;&emsp;&emsp;&emsp;
        <a href="mailto:sveera.2001@gmail.com">Mail</a>&emsp;&emsp;&emsp;&emsp;
        <a href="https://linkedin.com/in/veera-sivarajan">LinkedIn</a>
    </nav>  
</div>
</body>
</html>
EOF
