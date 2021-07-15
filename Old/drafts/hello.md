# Hello!
After several failed attempts to create a blog, I finally managed to make one by writing a static site generator in Bash based on nerdypepper's [post](https://peppe.rs/posts/static_sites_with_bash/). To put it simply, the Bash script reads all markdown files from a directory, converts them into HTML using [Pandoc](https://pandoc.org/installing.html), adds some essential CSS and HTML to all the files and writes all resulting files in a specific directory. I also wrote a small script to add a random [Tirukkural](https://en.wikipedia.org/wiki/Tirukku%E1%B9%9Fa%E1%B8%B7) to my homepage whenever I update the blog. This script uses [jq](https://stedolan.github.io/jq/) to fetch a kural from a JSON database on my system. Finally, to update the blog, all I have to do is execute [build.sh](https://github.com/veera-sivarajan/veera-sivarajan.github.io/blob/master/build.sh) and push all files to remote.

I stole the CSS from [here](https://ambrevar.xyz/). If you are the author of that blog, a big thank you and also I really appreciate your posts about Emacs.

I look forward to writing regulary on this blog.
