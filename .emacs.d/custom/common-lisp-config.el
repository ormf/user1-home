;;; (load "slime-orm.el")
(load "sly-config.el")
(load "cl-font-lock-add-ons.el")

(require 'browse-cltl2)

(defun join-next-line ()
  (interactive)
  (forward-line)
  (join-line))

;;; lambda pretty-print:

(defun sm-greek-lambda ()
  (font-lock-add-keywords
   nil
   `(("\\<lambda\\>"
      (0 (progn
           (compose-region (match-beginning 0) (match-end 0)
                           ,(make-char 'greek-iso8859-7 107))
           nil))))))

(defun my-add-pretty-lambda ()
  "make some word or string show as pretty Unicode symbols"
  (setq prettify-symbols-alist
        '(
          ("lambda" . 955) ; λ
;;          ("->" . 8594)    ; →
;;          ("=>" . 8658)    ; ⇒
;;          ("map" . 8614)   ; ↦
          )))

(global-prettify-symbols-mode 1)

(add-hook 'lisp-mode-hook 'sm-greek-lambda)
(add-hook 'lisp-mode-hook 'my-add-pretty-lambda)
(add-hook 'clojure-mode-hook 'my-add-pretty-lambda)

;;; Use Common Lisp indentation (not ELISP)
(add-hook
 'lisp-mode-hook
 (lambda ()
   ;; (set (make-local-variable lisp-indent-function)
   ;;      'slime-indent-function)
   ;; (set (make-local-variable lisp-indent-function)
   ;;      'common-lisp-indent-function)
   (define-key lisp-mode-map (kbd "M-<tab>") 'company-complete)
   (define-key lisp-mode-map (kbd "<tab>") 'lisp-indent-line)
   (define-key lisp-mode-map (kbd "C-^") 'join-next-line)
   (define-key lisp-mode-map (kbd "C-c q") 'comment-region)
   (define-key lisp-mode-map (kbd "C-c w") 'uncomment-region)
   (define-key lisp-mode-map (kbd "C-.") 'incudine-hush)
   (define-key lisp-mode-map (kbd "C-c C-.") 'incudine-rt-stop)
   (define-key lisp-mode-map (kbd "C-c M-.") 'incudine-rt-start)
   (define-key lisp-mode-map (kbd "C-c t") 'test-midi)))

;; [M-iso-lefttab]

;;; Treat square brackets like round ones (useful for
;;; CLSQL syntax)
(modify-syntax-entry ?\[ "(]" lisp-mode-syntax-table)
(modify-syntax-entry ?\] ")[" lisp-mode-syntax-table)

(modify-syntax-entry ?# "' 14bp" lisp-mode-syntax-table)
(modify-syntax-entry ?| "_ 23b" lisp-mode-syntax-table)
(modify-syntax-entry ?\n ">a" lisp-mode-syntax-table)	
