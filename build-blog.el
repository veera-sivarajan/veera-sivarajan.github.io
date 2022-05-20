;; ox-html.el.gz has to be evaluated everytime to get
;; correct syntax highlighting. 
(require 'ox-rss)

(load-file "/home/veera/.emacs.d/elpa/org-plus-contrib-20210705/ox-html.el") 

;; setting to nil, avoids "Author: x" at the bottom
(setq org-export-with-section-numbers nil
      org-export-with-smart-quotes t
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

(defun me/website-html-preamble (plist)
  "PLIST: An entry."
  (if (org-export-get-date plist this-date-format)
      (plist-put plist
                 :subtitle (format "%s"
                               (org-export-get-date plist this-date-format))))
  (if (string= (substring (buffer-name) 0 5) "index")
      (with-temp-buffer
        (insert-file-contents "~/Projects/Blog/html/preamble.html")
        (buffer-string))
    (with-temp-buffer
      (insert-file-contents "~/Projects/Blog/html/nav.html")
      (buffer-string)))) 

(defun me/website-html-postamble (plist)
  "PLIST."
  (concat (format
           (with-temp-buffer
             (insert-file-contents
              "~/Projects/Blog/html/postamble.html") (buffer-string))
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
         :base-directory "~/Projects/Blog/local/"
         :base-extension "org"
         :recursive nil 
         :publishing-function org-html-publish-to-html
         :publishing-directory "~/Projects/Blog/docs/"
         :exclude ,(regexp-opt '("README.org" "draft" "404.org"))
         :html-preamble me/website-html-preamble
         :html-postamble me/website-html-postamble
         :auto-sitemap t
         :sitemap-filename "index.org"
         :sitemap-title "Core Dump"
         :sitemap-format-entry me/org-sitemap-format-entry
         :sitemap-style list
         :sitemap-sort-files anti-chronologically)
        ("about"
         :base-directory "~/Projects/Blog/local/about/"
         :base-extension "org"
         :exclude ,(regexp-opt '("README.org" "draft"))
         :index-filename "index.org"
         :recursive nil
         :publishing-function org-html-publish-to-html
         :publishing-directory "~/Projects/Blog/docs/about"
         :html-preamble me/website-html-preamble
         :html-postamble me/website-html-postamble)
        ("css"
         :base-directory "~/Projects/Blog/local/css/"
         :base-extension "css"
         :publishing-function org-publish-attachment
         :publishing-directory "~/Projects/Blog/docs/css/"
         :recursive nil)
        ("images"
         :base-directory "~/Projects/Blog/local/imgs/"
         :base-extension ,site-attachments
         :publishing-directory "~/Projects/Blog/docs/imgs/"
         :publishing-function org-publish-attachment
         :recursive t)
        ("all" :components ("posts" "about" "css"  "images"))))

