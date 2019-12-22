;; If there are no archived package contents, refresh them
(when (not package-archive-contents)
  (package-refresh-contents))

;; Installs packages
;;
;; myPackages contains a list of package names
(defvar myPackages
  '(better-defaults                 ;; Set up some better Emacs defaults
    elpy                            ;; Emacs Lisp Python Environment
    flycheck                        ;; On the fly syntax checking
    py-autopep8                     ;; Run autopep8 on save
    blacken                         ;; Black formatting on safe (kind of autopep8)
    magit                           ;; Git integration
    ein                             ;; Emacs IPython Notebook
    )
  )

;; Scans the list in myPackages
;; If the package listed is not already installed, install it
(mapc #'(lambda (package)
          (unless (package-installed-p package)
            (package-install package)))
      myPackages)

;; ====================================
;; Development Setup
;; ====================================
;; Enable elpy
(elpy-enable)

;; Use IPython for REPL
(setq python-shell-interpreter "jupyter"
      python-shell-interpreter-args "console --simple-prompt"
      python-shell-prompt-detect-failure-warning nil)
(add-to-list 'python-shell-completion-native-disabled-interpreters
             "jupyter")

;; Enable Flycheck
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;; Enable autopep8
(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)

(setq scroll-conservatively 100)    ;; Keep from making huge jumps
(setq ring-bell-function 'ignore)   ;; Unable annoying sounds
(setq visible-bell 1)               ;; disable annoying windows sound
(setq inhibit-startup-message t)    ;; Hide the startup message
(setq-default display-line-numbers 'relative)
(use-package ivy
  :ensure t)
(use-package page-break-lines
  :ensure t
  :init
  (turn-on-page-break-lines-mode))
(setq electric-pair-pairs '(
                            (?\( . ?\))
                            (?\[ . ?\])
                            (?\" . ?\")
                            (?\{ . ?\})
                            ))
(electric-pair-mode t)

(tool-bar-mode -1)                  ;; Get rid of tool-bar
(menu-bar-mode -1)                  ;; Git rid of menu
(scroll-bar-mode -1)                ;; Get rid of scroll-bar

(defalias 'yes-or-no-p 'y-or-n-p)   ;; Replace yes questions to y

(when window-system (global-hl-line-mode t))            ;; Get a current line shadow in IDE

(use-package beacon
  :ensure t
  :init
  (beacon-mode 1))                  ;; Enable small light to show where current frame is

(use-package which-key
  :ensure t
  :init
  (which-key-mode))                 ;; Upon C-x get a list of possible options

(global-subword-mode 1)

(setq display-time-24hr-format t)
(display-time-mode 1)

(use-package popup-kill-ring
  :ensure t
  :bind ("M-y" . popup-kill-ring))

(when window-system
  (use-package pretty-mode
    :ensure t
    :config
    (add-hook 'prog-mode-hook 'pretty-mode)))

(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode))))

(setq org-src-window-setup 'current-window)
(add-to-list 'org-structure-template-alist
	     '("el" "#+BEGIN_SRC emacs-lisp\n?\n#+END_SRC"))
(add-to-list 'org-structure-template-alist
	     '("py" "#+BEGIN_SRC python\n?\n#+END_SRC"))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)))

(add-hook 'org-mode-hook 'org-indent-mode)

(setq ido-enable-flex-matching nil)
(setq ido-create-new-buffer 'always)
(setq ido-everywhere t)
(ido-mode 1)

(use-package ido-vertical-mode
  :ensure t
  :init
  (ido-vertical-mode 1))
(setq ido-vertical-define-keys 'C-n-and-C-p-only)

(use-package smex
  :ensure t
  :init (smex-initialize)
  :bind
  ("M-x" . smex))

(global-set-key (kbd "C-x C-b") 'ido-switch-buffer)

(global-set-key (kbd "C-x b") 'ibuffer)

(setq ibuffer-expert t)

(defun kill-curr-buffer ()
  (interactive)
  (kill-buffer (current-buffer)))
(global-set-key (kbd "C-x k") 'kill-curr-buffer)

(defun kill-all-buffers ()
  (interactive)
  (mapc 'kill-buffer (buffer-list)))
(global-set-key (kbd "C-M-s-k") 'kill-all-buffers)

(use-package avy
  :ensure t
  :bind
  ("M-s" . avy-goto-char))

(defun config-visit ()
  (interactive)
  (find-file "~/.emacs.d/config.org"))
(global-set-key (kbd "C-c e") 'config-visit)

(defun config-reload ()
  (interactive)
  (org-babel-load-file (expand-file-name "~/.emacs.d/config.org")))
(global-set-key (kbd "C-c r") 'config-reload)

(use-package rainbow-mode
  :ensure t
  :init (add-hook 'prog-mode-hook 'rainbow-mode))

(use-package rainbow-delimiters
  :ensure t
  :init
  (rainbow-delimiters-mode 1))

(use-package switch-window
  :ensure t
  :config
  (setq switch-window-input-style 'minibuffer)
  (setq switch-window-increase 4)
  (setq switch-window-threshold 2)
  (setq switch-window-shortcut-style 'qwerty)
  (setq switch-window-qwerty-shortcuts
	'("a" "s" "d" "f" "h" "j" "k" "l"))
  :bind
  ([remap other-window] . switch-window))

(defun split-and-follow-horizontally ()
  (interactive)
  (split-window-below)
  (balance-windows)
  (other-window 1))
(global-set-key (kbd "C-x 2") 'split-and-follow-horizontally)

(defun split-and-follow-vertically ()
  (interactive)
  (split-window-right)
  (balance-windows)
  (other-window 1))
(global-set-key (kbd "C-x 3") 'split-and-follow-vertically)

(defun kill-whole-word ()
  (interactive)
  (backward-word)
  (kill-word 1))
(global-set-key (kbd "C-c w w") 'kill-whole-word)

(defun copy-whole-line ()
  (interactive)
  (save-excursion
    (kill-new
     (buffer-substring
      (point-at-bol)
      (point-at-eol)))))
(global-set-key (kbd "C-c w l") 'copy-whole-line)

(use-package hungry-delete
  :ensure t
  :config (global-hungry-delete-mode))

(with-eval-after-load 'debug
  (defun debugger-setup-buffer (debugger-args)
    "Initialize the `*Backtrace*' buffer for entry to the debugger.
That buffer should be current already."
    (setq buffer-read-only nil)
    (erase-buffer)
    (set-buffer-multibyte t)        ;Why was it nil ?  -stef
    (setq buffer-undo-list t)
    (let ((standard-output (current-buffer))
	  (print-escape-newlines t)
	  (print-level 8)
	  (print-length 50))
      (backtrace))
    (goto-char (point-min))
    (delete-region (point)
		   (progn
		     (search-forward "\n  debug(")
		     (forward-line (if (eq (car debugger-args) 'debug)
				       2    ; Remove implement-debug-on-entry frame.
				     1))
		     (point)))
    (insert "Debugger entered")
    ;; lambda is for debug-on-call when a function call is next.
    ;; debug is for debug-on-entry function called.
    (pcase (car debugger-args)
      ((or `lambda `debug)
       (insert "--entering a function:\n"))
      ;; Exiting a function.
      (`exit
       (insert "--returning value: ")
       (setq debugger-value (nth 1 debugger-args))
       (prin1 debugger-value (current-buffer))
       (insert ?\n)
       (delete-char 1)
       (insert ? )
       (beginning-of-line))
      ;; Debugger entered for an error.
      (`error
       (insert "--Lisp error: ")
       (prin1 (nth 1 debugger-args) (current-buffer))
       (insert ?\n))
      ;; debug-on-call, when the next thing is an eval.
      (`t
       (insert "--beginning evaluation of function call form:\n"))
      ;; User calls debug directly.
      (_
       (insert ": ")
       (prin1 (if (eq (car debugger-args) 'nil)
		  (cdr debugger-args) debugger-args)
	      (current-buffer))
       (insert ?\n)))
    ;; After any frame that uses eval-buffer,
    ;; insert a line that states the buffer position it's reading at.
    (save-excursion
      (let ((tem eval-buffer-list))
	(while (and tem
		    (re-search-forward "^  eval-\\(buffer\\|region\\)(" nil t))
	  (beginning-of-line)
	  (insert (apply 'format "Error at line %d, column %d (point %d) in %s\n"
                   (with-current-buffer (car tem)
                     (list (line-number-at-pos (point))
                           (current-column)
                           (point)
                           (buffer-name)))))
	  (pop tem))))
    (debugger-make-xrefs)))

(use-package dashboard
  :ensure t
  :config
    (dashboard-setup-startup-hook)
    (setq dashboard-startup-banner "~/.emacs.d/img/dashLogo.png")
    (setq dashboard-items '((recents  . 10)))
    (setq dashboard-banner-logo-title "Een hele goede dag! Veel plezier met emacs he, ja toch, ja toch niet dan")
    (setq dashboard-footer "Niet vergeten he! C-x C-s"))

(use-package company
  :ensure t
  :init
  (add-hook 'after-init-hook 'global-company-mode))

(use-package spaceline
  :ensure t
  :config
  (require 'spaceline-config)
  (setq powerline-default-separator (quote arrow))
  (spaceline-spacemacs-theme))

(use-package diminish
  :ensure t
  :init
  (diminish 'hungry-delete-mode)
  (diminish 'beacon-mode)
  (diminish 'which-key-mode)
  (diminish 'subword-mode)
  (diminish 'rainbow-mode))

(use-package dmenu
  :ensure t
  :bind
  ("s-SPC" . 'dmenu))

(use-package symon
  :ensure t
  :bind
  ("s-h" . symon-mode))

(use-package ivy
  :diminish
  :init
  (use-package amx :defer t)
  (use-package counsel :diminish :config (counsel-mode 1))
  (use-package swiper :defer t)
  (ivy-mode 1)
  :bind
  (("C-s" . swiper-isearch)
   ("C-z s" . counsel-rg)
   ("C-z b" . counsel-buffer-or-recentf)
   ("C-z C-b" . counsel-ibuffer)
   (:map ivy-minibuffer-map
         ("C-r" . ivy-previous-line-or-history)
         ("M-RET" . ivy-immediate-done))
   (:map counsel-find-file-map
         ("C-~" . counsel-goto-local-home)))
  :custom
  (ivy-use-virtual-buffers t)
  (ivy-height 10)
  (ivy-on-del-error-function nil)
  (ivy-magic-slash-non-match-action 'ivy-magic-slash-non-match-create)
  (ivy-count-format "【%d/%d】")
  (ivy-wrap t)
  :config
  (defun counsel-goto-local-home ()
      "Go to the $HOME of the local machine."
      (interactive)
      (ivy--cd "~/")))

(use-package mark-multiple
  :ensure t
  :bind ("C-c q" . 'mark-next-like-this))

(use-package expand-region
  :ensure t
  :bind ("C-q" . er/expand-region))
