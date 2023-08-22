(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)

(add-to-list 'load-path "~/.emacs.d/custom-packages/")

(require 'igrep)

(require 'lilypond-mode)
(load "/usr/share/emacs/site-lisp/lilypond-init.el")

;; ======== SLIME ============================================================

(load (expand-file-name "~/quicklisp/slime-helper.el"))
  ;; Replace "sbcl" with the path to your implementation
(setq inferior-lisp-program "/usr/bin/sbcl")

;; (setq inferior-lisp-program "/usr/bin/sbcl --dynamic-space-size 1700")
;; (setq inferior-lisp-program "/usr/local/bin/ecl")
;;; (setq inferior-lisp-program "/usr/local/bin/eql")
;; (add-to-list 'load-path "~/hacking/lisp/slime/")  ; your SLIME directory
;;(require 'slime-autoloads)
(slime-setup '(slime-fancy))

;; (add-to-list 'load-path "/LISP/slime/")
;; (add-to-list 'load-path "/LISP/slime/contrib")
; (slime-setup '(slime-c-p-c))

;;; (add-hook 'slime-load-hook (lambda () (require 'slime-fuzzy)))

;;; (add-hook 'slime-load-hook (lambda () (require 'slime-fuzzy) (require 'slime-listener-hooks)))

(setq slime-enable-evaluate-in-emacs t)
;; (setq slime-lisp-implementations
;;       ;;  name   (path arg*)  :coding-system :init
;;       '(
;; 	(sbcl    ("/usr/bin/sbcl") :coding-system utf-8-unix)
;; 	(cm      ("/usr/bin/sbcl" "--load" "/tmp/cm-startup.lisp") :coding-system utf-8-unix)
;; ;;	(cm      ("/usr/bin/sbcl") :coding-system utf-8-unix)
;; ;;        (cm      ("/LISP/cm2/cm/bin/cm.sh" "-l" "sbcl") :coding-system utf-8-unix)
;; 
;; 	;; (allegro ("/LISP/acl70_trial/alisp"))
;; 	;; (openmcl ("/usr/bin/openmcl"))
;; 	;; (cmucl   ("/opt/cmucl/bin/lisp"))
;; 	;; (clisp   ("clisp" "-q"))
;; 	;; (xclisp  ("clisp" "-q" "-M" "/tmp/x.mem")
;; 	;; 	 :init (lambda (file _) 
;; 	;; 		 (format "(swank:start-server %S)\n\n" file)))
;;         ))

;;(setq slime-default-lisp 'sbcl)
;; (setq slime-default-lisp 'cm)

;;; Let slime handle all LISP files
(require 'slime-indentation)
(add-hook 'lisp-mode-hook (lambda () (slime-mode t)))
(add-hook 'lisp-mode-hook (lambda () (recentf-mode t)))
(add-hook 'lisp-mode-hook (lambda () (company-mode t)))
(add-hook 'lisp-mode-hook (lambda () (rainbow-delimiters-mode t)))
(add-hook 'lisp-mode-hook (lambda () (paredit-mode t)))


;;; lambda pretty-print:

(defun sm-greek-lambda ()
       (font-lock-add-keywords nil `(("\\<lambda\\>"
           (0 (progn (compose-region (match-beginning 0) (match-end 0)
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

(defun join-next-line ()
  (interactive)
  (forward-line)
  (join-line))

;;; Use Common Lisp indentation (not ELISP)
(add-hook 'lisp-mode-hook (lambda () (set (make-local-variable lisp-indent-function)
					  'common-lisp-indent-function)
                            (define-key lisp-mode-map (kbd "M-<tab>") 'company-complete)
                            (define-key lisp-mode-map (kbd "C-^") 'join-next-line)
                            (define-key lisp-mode-map (kbd "C-c C-a") 'slime-flock-show-audio-preset)
                            (define-key lisp-mode-map (kbd "C-c v") 'view-mode)))

;; [M-iso-lefttab]



;;; Be smart about symbol completition (TAB)
(setq slime-complete-symbol-function (quote slime-fuzzy-complete-symbol))

(setq slime-conservative-indentation nil)

(setq slime-display-compilation-output nil)

;;; Treat square brackets like round ones (useful for
;;; CLSQL syntax)
(modify-syntax-entry ?\[ "(]" lisp-mode-syntax-table)
(modify-syntax-entry ?\] ")[" lisp-mode-syntax-table)

(modify-syntax-entry ?# "' 14bp" lisp-mode-syntax-table)
(modify-syntax-entry ?| "_ 23b" lisp-mode-syntax-table)
(modify-syntax-entry ?\n ">a" lisp-mode-syntax-table)	
(global-set-key (kbd "C-c s") 'slime-selector)

(defun slime-description-fontify ()
  "Fontify sections of SLIME Description."
  (with-current-buffer "*slime-description*"
    (highlight-regexp
     (concat "function:\\|"
             "Lambda-list:\\|"
             "symbol\\|"
             "Derived type:\\|"
             "Documentation:\\|"
             "Source file:"
             )
     'hi-green-b)))

;;    "Source file:"
;;    "Derived type:"
;;             "^Macro-function:\\|"

;; 
             ;; "^Its associated name.+?) is\\|"
             ;; "^The .+'s arguments are:\\|"
             ;; "^ *Its.+\\(is\\|are\\):\\|"
;;             "list"

(defadvice slime-show-description (after slime-description-fontify activate)
  "Fontify sections of SLIME Description."
  (slime-description-fontify))

(add-hook 'slime-repl-mode-hook (lambda () (company-mode t)))
(add-hook 'slime-repl-mode-hook (lambda () (rainbow-delimiters-mode t)))
(add-hook 'slime-repl-mode-hook (lambda () (paredit-mode t)))

;; (defun slime-eval-last-expression-in-repl (prefix)
;;   "Evaluates last expression in the Slime REPL.
;; 
;; Switches REPL to current package of the source buffer for the duration. If
;; used with a prefix argument (C-u), doesn't switch back afterwards."
;;   (interactive "P")
;;   (let ((expr (slime-last-expression))
;;         (buffer-name (buffer-name (current-buffer)))
;;         (new-package (slime-current-package))
;;         (old-package (slime-lisp-package))
;;         (slime-repl-suppress-prompt t)
;;         (yank-back nil))
;;     (with-current-buffer (slime-output-buffer)
;;       (unless (eq (current-buffer) (window-buffer))
;;         (pop-to-buffer (current-buffer) t))
;;       (goto-char (point-max))
;;       ;; Kill pending input in the REPL
;;       (when (< (marker-position slime-repl-input-start-mark) (point))
;;         (kill-region slime-repl-input-start-mark (point))
;;         (setq yank-back t))
;;       (unwind-protect
;;           (progn
;;             (insert-before-markers (format "\n;;; from %s\n" buffer-name))
;;             (when new-package
;;               (slime-repl-set-package new-package))
;;             (let ((slime-repl-suppress-prompt nil))
;;               (slime-repl-insert-prompt))
;;             (insert expr)
;;             (slime-repl-return))
;;         (unless (or prefix (equal (slime-lisp-package) old-package))
;;           ;; Switch back.
;;           (slime-repl-set-package old-package)
;;           (let ((slime-repl-suppress-prompt nil))
;;             (slime-repl-insert-prompt))))
;;       ;; Put pending input back.
;;       (when yank-back
;;         (yank)))))

(defun slime-eval-expression-in-repl (expr)
  "Evaluates expression in the Slime REPL.

Switches REPL to current package of the source buffer for the duration. If
used with a prefix argument (C-u), doesn't switch back afterwards."
  (interactive "P")
  (let ((buffer-name (buffer-name (current-buffer)))
        (new-package (slime-current-package))
        (old-package (slime-lisp-package))
        (slime-repl-suppress-prompt t)
        (yank-back nil))
    (with-current-buffer (slime-output-buffer)
      (unless (eq (current-buffer) (window-buffer))
        (pop-to-buffer (current-buffer) t))
      (goto-char (point-max))
      ;; Kill pending input in the REPL
      (when (< (marker-position slime-repl-input-start-mark) (point))
        (kill-region slime-repl-input-start-mark (point))
        (setq yank-back t))
      (unwind-protect
          (progn
            (insert-before-markers (format "\n;;; from %s\n" buffer-name))
            (when new-package
              (slime-repl-set-package new-package))
            (let ((slime-repl-suppress-prompt nil))
              (slime-repl-insert-prompt))
            (insert expr)
            (slime-repl-return)))
      ;; Put pending input back.
      (when yank-back
        (yank)))))

;; (defun slime-eval-last-expression ()
;;   "Evaluate the expression preceding point."
;;   (interactive)
;;   (slime-interactive-eval (slime-last-expression)))

(defun slime-eval-print-last-sexp ()
  (interactive)
  (newline)
  (insert (concat ";;; -> " (cadr (slime-eval `(swank:eval-and-grab-output ,(slime-last-expression))))))
  (newline))

;;; (cadr (slime-eval `(swank:eval-and-grab-output "(luftstrom-display::next-preset)")))

;; (defun slime-flock-show-audio-preset ()
;;   (interactive)
;;   (cadr (slime-eval `(swank:eval-and-grab-output (luftstrom-display::show-audio-preset ,(slime-last-expression))))))


;;; ,(slime-last-expression)
;;(setq slime-enable-evaluate-in-emacs t)

;; ======== END SLIME ==============================================


(load "~/quicklisp/clhs-use-local.el" t)
(add-to-list 'load-path "~/quicklisp/local-projects/cm/etc/emacs" t)
(require 'cm)
(slime)
(server-start)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ediff-even-diff-A ((t (:background "light grey" :foreground "black"))))
 '(ediff-even-diff-Ancestor ((t (:background "Grey" :foreground "black"))))
 '(ediff-even-diff-B ((t (:background "Grey" :foreground "black"))))
 '(ediff-even-diff-C ((t (:background "light grey" :foreground "black"))))
 '(ediff-fine-diff-A ((t (:background "#aa2222" :foreground "black"))))
 '(ediff-fine-diff-Ancestor ((t (:background "#009591" :foreground "black"))))
 '(ediff-fine-diff-B ((t (:background "#22aa22" :foreground "black"))))
 '(ediff-fine-diff-C ((t (:background "#aaaa22" :foreground "black"))))
 '(ediff-odd-diff-A ((t (:background "Grey" :foreground "black"))))
 '(ediff-odd-diff-B ((t (:background "light grey" :foreground "black"))))
 '(ediff-odd-diff-C ((t (:background "Grey" :foreground "black"))))
 '(eval-sexp-fu-flash ((t (:background "royal blue" :foreground "white" :weight bold))))
 '(info-menu-header ((t (:weight bold))))
 '(rainbow-delimiters-depth-1-face ((t (:foreground "yellow"))))
 '(rainbow-delimiters-depth-2-face ((t (:foreground "dark gray"))))
 '(rainbow-delimiters-depth-3-face ((t (:foreground "deep pink"))))
 '(rainbow-delimiters-depth-4-face ((t (:foreground "green yellow"))))
 '(rainbow-delimiters-depth-5-face ((t (:foreground "deep sky blue"))))
 '(rainbow-delimiters-depth-6-face ((t (:foreground "yellow1"))))
 '(rainbow-delimiters-depth-7-face ((t (:foreground "gold3"))))
 '(rainbow-delimiters-depth-8-face ((t (:foreground "orange3"))))
 '(rainbow-delimiters-depth-9-face ((t (:foreground "DarkOrange4")))))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(magit company paredit-everywhere paredit rainbow-delimiters)))
