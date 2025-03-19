(add-to-list 'load-path "~/.emacs.d/custom/")
(add-to-list 'load-path "~/.emacs.d/custom/company-anywhere")
(require 'clamps-packages)

(fset 'yes-or-no-p 'y-or-n-p)
(tool-bar-mode -1)
(toggle-scroll-bar -1)
(scroll-bar-mode 1)
;;; start emacs server for emacsclient
(server-start)
(require 'recentf)
(require 'company-anywhere)
(require 'igrep)

(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

(load "common-lisp-config.el")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(deeper-blue))
 '(package-selected-packages
   '(magit sly-repl-ansi-color sly-quicklisp sly-named-readtables sly-macrostep rainbow-delimiters paredit company)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(rainbow-delimiters-depth-1-face ((t (:foreground "yellow" :inherit rainbow-delimiters-base-face))))
 '(rainbow-delimiters-depth-2-face ((t (:foreground "dark gray" :inherit rainbow-delimiters-base-face))))
 '(rainbow-delimiters-depth-3-face ((t (:foreground "deep pink" :inherit rainbow-delimiters-base-face))))
 '(rainbow-delimiters-depth-4-face ((t (:foreground "green yellow" :inherit rainbow-delimiters-base-face))))
 '(rainbow-delimiters-depth-5-face ((t (:foreground "deep sky blue" :inherit rainbow-delimiters-base-face))))
 '(rainbow-delimiters-depth-6-face ((t (:foreground "yellow1" :inherit rainbow-delimiters-base-face))))
 '(rainbow-delimiters-depth-7-face ((t (:foreground "gold3" :inherit rainbow-delimiters-base-face))))
 '(rainbow-delimiters-depth-8-face ((t (:foreground "orange3" :inherit rainbow-delimiters-base-face))))
 '(rainbow-delimiters-depth-9-face ((t (:foreground "DarkOrange4" :inherit rainbow-delimiters-base-face)))))
