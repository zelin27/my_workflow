;;; core-org.el --- Configurations for Org-mode.

;; Author: Z.Wang

;; This file is not part of GNU Emacs.

;;; Commentary:

;; Configurations for Org-mode.

;;; Code:

(add-hook 'org-mode-hook
	  (lambda ()                                          
	    ;; org-indent-mode
	    (setq org-startup-indented t)                     

	    ;; set underscore as _, subscript as _{}.
	    (setq org-export-with-sub-superscripts (quote {}))

	    (setq org-src-fontify-natively t
                  org-src-preserve-indentation t
                  org-src-tab-acts-natively t)

	    ;; inline display image
	    (setq org-startup-with-inline-images t)

	    ;;if there is a #+ATTR.*: width="200", resize to 200, otherwise resize to 400
	    (setq org-image-actual-width '(400))

	    ;;; display/update images in the buffer after I evaluate
	    (add-hook 'org-babel-after-execute-hook 'org-display-inline-images 'append)

	    ;;don't prompt me to confirm everytime I want to evaluate a block
	    (setq org-confirm-babel-evaluate nil)

	    (which-key-add-key-based-replacements "SPC o" "org")
	    (which-key-add-key-based-replacements "SPC s" "code-to-session")
	    (evil-define-key '(normal visual motion) org-mode-map
	      (kbd "SPC ss") 'org-babel-switch-to-session-with-code)
	    (evil-define-key '(normal visual motion) org-src-mode-map
	      (kbd "SPC se") 'org-edit-src-exit
	      (kbd "SPC sa") 'org-edit-src-abort)

	    ;; publishing Org-mode files
	    (setq org-publish-project-alist
		  '(("org-html"
		     :base-directory "~/documents/myproject/mynotebook/org/"
		     :base-extension "org"
		     :publishing-directory "~/documents/myproject/mynotebook/html/"
		     :recursive t
		     :publishing-function org-html-publish-to-html
		     :headline-levels 6
		     :auto-preamble t)
		    ("org-html-images"
		     :base-directory "~/documents/myproject/mynotebook/org/img/"
		     :base-extension "jpg\\|gif\\|png\\|tiff"
		     :publishing-directory "~/documents/myproject/mynotebook/html/img/"
		     :publishing-function org-publish-attachment)
		    ("org-tex-pdf"
		     :base-directory "~/documents/myproject/mynotebook/org/"
		     :base-extension "org"
		     :publishing-directory "~/documents/myproject/mynotebook/latex-pdf/"
		     :publishing-function org-latex-publish-to-pdf)
		    ("all" :components ("org-html" "org-html-images" "org-tex-pdf"))))

	    ;; active Babel languages
	    (org-babel-do-load-languages 'org-babel-load-languages
			 '((emacs-lisp . t)
			   (python     . t)
			   (ipython    . t)
			   (C          . t)
			   (shell      . t)
			   (org        . t)))
	    ))

;; org-bullets
(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

;; org-present
(use-package org-present
  :ensure t
  :hook (org-mode-hook)
  :config
  (eval-after-load "org-present"
    '(progn
       (add-hook 'org-present-mode-hook
                 (lambda ()
                   (org-present-big)
                   (org-display-inline-images)
                   (org-present-hide-cursor)
                   (org-present-read-only)))
       (add-hook 'org-present-mode-quit-hook
                 (lambda ()
                   (org-present-small)
                   (org-remove-inline-images)
                   (org-present-show-cursor)
                   (org-present-read-write))))))

;; org-download --- Insertion of images
(use-package org-download
  :ensure t
  :hook (org-mode-hook))

;; org-projectile
(use-package org-projectile
  :ensure t
  :hook (org-mode-hook)
  :config
  (progn
    (setq org-projectile-projects-file
          "/Users/zwwang/Documents/myproject/mynotebook/todo.org")
    (setq org-agenda-files (append org-agenda-files (org-projectile-todo-files)))
    (push (org-projectile-project-todo-entry) org-capture-templates)))

;; ob-ipython
(use-package ob-ipython
  :ensure t
  :hook (org-mode-hook)
  :config
  (add-to-list 'company-backends 'company-ob-ipython))

;; ob-async --- execute org-babel src blocks asynchronously
(use-package ob-async
  :ensure t
  :hook (org-mode-hook)
  :config
  (ob-async))


(provide 'core-org)
;;; core-org.el ends here
