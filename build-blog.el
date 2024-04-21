;; ox-html.el.gz has to be evaluated everytime to get
;; correct syntax highlighting. 
(require 'ox-rss)

;; (load-file "/home/veera/.emacs.d/elpa/org-plus-contrib-20210705/ox-html.el") 

;; setting to nil, avoids "Author: x" at the bottom
(setq org-export-with-smart-quotes t
      org-export-with-toc nil)

(defvar rw-url "https://veera.app/"
  "The URL where this site will be published.")

(defvar this-date-format "%Y-%b-%d") 

(setq org-export-html-postamble nil) 

(setq org-html-divs '((preamble "header" "top")
                      (content "main" "content")
                      (postamble "footer" "postamble"))
      org-html-container-element "section"
      org-html-metadata-timestamp-format this-date-format
      org-html-checkbox-type 'html
      org-html-html5-fancy t
      org-html-validation-link t
      org-html-doctype "html5"
      org-html-htmlize-output-type 'css)

(defun rw/org-rss-publish-to-rss (plist filename pub-dir)
  "Publish RSS with PLIST, only when FILENAME is 'rss.org'.
PUB-DIR is when the output will be placed."
  (if (equal "rss.org" (file-name-nondirectory filename))
      (org-rss-publish-to-rss plist filename pub-dir)))

(defun rw/format-rss-feed (title list)
  "Generate RSS feed, as a string.
TITLE is the title of the RSS feed.  LIST is an internal
representation for the files to include, as returned by
`org-list-to-lisp'.  PROJECT is the current project."
  (concat "#+TITLE: " title "\n\n"
          (org-list-to-subtree list 1 '(:icount "" :istart "")))) 

(defun rw/format-rss-feed-entry (entry style project)
  "Format ENTRY for the RSS feed.
ENTRY is a file name.  STYLE is either 'list' or 'tree'.
PROJECT is the current project."
  (cond ((not (directory-name-p entry))
         (let* ((file (org-publish--expand-file-name entry project))
                (title (org-publish-find-title entry project))
                (date (format-time-string "%Y-%m-%d" (org-publish-find-date entry project)))
                (link (concat (file-name-sans-extension entry) ".html")))
           (with-temp-buffer
             (insert (format "* %s\n" title))
             (org-set-property "RSS_PERMALINK" link)
             (org-set-property "PUBDATE" date)
             (insert-file-contents file)
             (buffer-string))))
        ((eq style 'tree)
         ;; Return only last subdir.
         (file-name-nondirectory (directory-file-name entry)))
        (t entry)))

(defun me/website-html-preamble (plist)
  "PLIST: An entry."
  (if (org-export-get-date plist this-date-format)
      (plist-put plist
                 :subtitle (format "%s"
                               (org-export-get-date plist this-date-format))))
  (if (string= (substring (buffer-name) 0 5) "index")
      (with-temp-buffer
        (insert-file-contents "~/projects/blog/html/preamble.html")
        (buffer-string))
    (with-temp-buffer
      (insert-file-contents "~/projects/blog/html/nav.html")
      (buffer-string)))) 

(defun me/website-html-postamble (plist)
  "PLIST."
  (concat (format
           (with-temp-buffer
             (insert-file-contents
              "~/projects/blog/html/postamble.html") (buffer-string))
           (format-time-string "%Y-%b-%d %a %H:%M")
           (plist-get plist :creator))))

(defvar site-attachments
  (regexp-opt '("jpg" "jpeg" "gif" "png" "svg"
                "ico" "cur" "css" "js" "woff" "html" "pdf"))
  "File types that are published as static files.")

(defun me/org-sitemap-format-entry (entry style project)
  "Format posts with author and published data in the index page.
ENTRY: file-name
STYLE:
PROJECT: `posts in this case."
  (message entry) 
  (message (org-publish-find-title entry project)) 
  (cond ((not (directory-name-p entry))
         (format "%s:
                 *[[file:%s][%s]]*"
                 (format-time-string this-date-format
                                     (org-publish-find-date entry project))
                 entry
                 (org-publish-find-title entry project) 
                 ))
        ((eq style 'tree) (file-name-nondirectory (directory-file-name entry)))
        (t entry)))

(setq org-publish-project-alist
      `(("posts"
         :base-directory "~/projects/blog/local/"
         :base-extension "org"
         :recursive nil 
         :publishing-function org-html-publish-to-html
         :publishing-directory "~/projects/blog/docs/"
         :exclude ,(regexp-opt '("README.org" "draft" "404.org" "rss.org"))
         :html-head-include-scripts nil
         :html-head-include-default-style nil
         :html-preamble me/website-html-preamble
         :html-postamble me/website-html-postamble
         :auto-sitemap t
         :sitemap-filename "index.org"
         :sitemap-title "Core Dump"
         :sitemap-format-entry me/org-sitemap-format-entry
         :sitemap-style list
         :sitemap-sort-files anti-chronologically)
        ("rss-feed"
         :base-directory "~/projects/blog/local/"
         :base-extension "org"
         :recursive nil
         :publishing-function rw/org-rss-publish-to-rss
         :publishing-directory "/home/veera/projects/blog/docs/"
         :exclude ,(regexp-opt '("README.org" "draft" "404.org" "index.org"))
         :rss-extension "xml"
         :html-link-home "https://veera.app/"
         :html-link-use-abs-url t
         :html-link-org-files-as-html t
         :auto-sitemap t
         :sitemap-filename "rss.org"
         :sitemap-title "core dump"
         :sitemap-style list
         :sitemap-sort-files anti-chronologically
         :sitemap-function rw/format-rss-feed
         :sitemap-format-entry rw/format-rss-feed-entry)
        ("about"
         :base-directory "~/projects/blog/local/about/"
         :base-extension "org"
         :exclude ,(regexp-opt '("README.org" "draft"))
         :index-filename "index.org"
         :recursive nil
         :publishing-function org-html-publish-to-html
         :publishing-directory "~/projects/blog/docs/about"
         :html-preamble me/website-html-preamble
         :html-postamble me/website-html-postamble)
        ("css"
         :base-directory "~/projects/blog/local/css/"
         :base-extension "css"
         :publishing-function org-publish-attachment
         :publishing-directory "~/projects/blog/docs/css/"
         :recursive nil)
        ("images"
         :base-directory "~/projects/blog/local/imgs/"
         :base-extension ,site-attachments
         :publishing-directory "~/projects/blog/docs/imgs/"
         :publishing-function org-publish-attachment
         :recursive t)
        ("all" :components ("posts" "about" "css"  "images" "rss-feed"))))

