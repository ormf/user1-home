(require 'package)
;; (require 'melpa)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)
(require 'browse-cltl2)
;;;(require 'company-anywhere)
(setq url-http-attempt-keepalives nil)

(defvar clamps-packages
  '(rainbow-delimiters paredit company company-fuzzy eldoc wdired
                       magit sly-repl-ansi-color sly-quicklisp
                       sly-named-readtables sly-macrostep)
  "A list of packages to ensure are installed at launch.")

;; (require 'sly-autoloads)

(defun clamps-packages-installed-p ()
  (cl-loop for p in clamps-packages
           when (not (package-installed-p p)) do (cl-return nil)
           finally (cl-return t)))

(unless (clamps-packages-installed-p)
  ;; check for new packages (package versions)
  (message "%s" "Emacs is now refreshing its package database for Clamps...")
  (package-refresh-contents)
  (message "%s" " done.")
  ;; install the missing packages
  (dolist (p clamps-packages)
    (when (not (package-installed-p p))
      (package-install p))))

(provide 'clamps-packages)

;;; browse-cltl2
