;;; Code;;
(require 'package) ;; https://stackoverflow.com/a/14838150/2402577
(defun alper-start () (interactive)(message "Start Alper"))
(setq user-init-file (or load-file-name (buffer-file-name)))
(setq user-emacs-directory (file-name-directory user-init-file))
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("MELPA Stable" . "http://stable.melpa.org/packages/")
                         ("tromey" . "http://tromey.com/elpa/")
                         ("org" . "https://orgmode.org/elpa/")))
(setq user-full-name "Alper Alimoglu")
(setq user-mail-address "alper.alimoglu@gmail.com")
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)
(fset 'yes-or-no-p 'y-or-n-p)
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(add-to-list 'load-path "~/.emacs.d/plugins/yasnippet")
(setq package-check-signature nil)

(when (not package-archive-contents)
  (package-refresh-contents))

;; Install use-package that we require for managing all other dependencies
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(defun query-replace-region-or-from-top ()
  "If marked, query-replace for the region, else for the whole buffer (start from the top)"
  (interactive)
  (progn
    (let ((orig-point (point)))
      (if (use-region-p)
          (call-interactively 'query-replace)
        (save-excursion
          (goto-char (point-min))
          (call-interactively 'query-replace)))
      (message "Back to old point.")
      (goto-char orig-point))))

(global-set-key "\C-x\C-r"  'query-replace-region-or-from-top)

(load-theme 'dracula t)

;; flyccheck
;; ========
;; https://gist.github.com/Blaisorblade/c7349438b06e7b1e034db775408ac4cb
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

(use-package python :ensure nil)
;; (load-file (expand-file-name "init.el" user-emacs-directory))
(global-set-key "\C-x\C-j" 'xref-find-definitions)
(global-set-key "\C-x\C-k" 'xref-pop-marker-stack)

(add-hook 'python-mode-hook 'lsp)
(add-hook 'python-mode-hook #'lsp-deferred)

;; ;; https://emacs-lsp.github.io/lsp-mode/tutorials/how-to-turn-off/
(setq lsp-headerline-breadcrumb-enable nil)
(setq lsp-enable-symbol-highlighting nil)
(setq lsp-modeline-diagnostics-enable 1)
(setq lsp-ui-doc-enable nil)
(setq lsp-lens-enable nil)
(setq lsp-pyls-plugins-pylint-enabled nil)
(setq-default lsp-pyls-configuration-sources ["flake8"])
;; (setq lsp-ui-sideline-enable nil)
;; (setq lsp-ui-sideline-show-diagnostics nil)

(add-hook 'after-init-hook #'global-flycheck-mode)
(with-eval-after-load 'flycheck
  (setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc)))

;; (setq frame-background-mode 'dark)
;; (setq server-kill-new-buffers nil)
;; https://emacs.stackexchange.com/questions/315/using-desktop-for-basic-project-management
(setq desktop-globals-to-save ;; ~/.emacs.d/.emacs.desktop
      (append '((comint-input-ring . 50)
                (compile-history . 30)
                desktop-missing-file-warning
                (dired-regexp-history . 20)
                (extended-command-history . 30)
                (face-name-history . 20)
                (file-name-history . 100)
                (grep-find-history . 30)
                (grep-history . 30)
                (ido-buffer-history . 100)
                (ido-last-directory-list . 100)
                (ido-work-directory-list . 100)
                (ido-work-file-list . 100)
                (magit-read-rev-history . 50)
                (minibuffer-history . 50)
                (org-clock-history . 50)
                (org-refile-history . 50)
                (org-tags-history . 50)
                (query-replace-history . 60)
                (read-expression-history . 60)
                (regexp-history . 60)
                (regexp-search-ring . 20)
                register-alist
                (search-ring . 20)
                (shell-command-history . 50)
                tags-file-name
                tags-table-list)))

;; (desktop-save-mode 1)
;; (desktop-file-name ".emacs.desktop" "~/.emacs.d/")

(defun my-bottom ()
  (interactive)
  (let* ((height (window-height)))
    (end-of-buffer)
    ;; Move window
    (set-window-start
      (selected-window)
      (min
        (save-excursion ;; new point.
          (forward-line (- (/ height 2)))
          (point))
        (save-excursion ;; max point.
          (goto-char (point-max))
          (beginning-of-line)
          (forward-line (- (- height (+ 1 (* 2 scroll-margin)))))
          (point)))))
  (redisplay)
  (end-of-visual-line)
  (next-line (/ (window-height
                 (selected-window)) 2)))

(global-set-key "\C-x\ ."  'my-bottom)
(global-set-key (kbd "C-x C-.") 'my-bottom)

(setq package-enable-at-startup nil)
(dolist (package package-selected-packages)
  (unless (package-installed-p package)
    (package-install package)))

;; (require 'use-package)
(if (not (package-installed-p 'use-package))
    (progn
      (package-install 'use-package)))
(require 'use-package)

(if (not (package-installed-p 'vc))
    (progn
      (package-install 'vc)))
(require 'vc)

(if (not (package-installed-p 'helm-dired-recent-dirs))
    (progn
      (package-install 'helm-dired-recent-dirs)))
(require 'helm-dired-recent-dirs)

(if (not (package-installed-p 'diminish))
    (progn
      (package-install 'diminish)))

;; counsel
(if (not (package-installed-p 'counsel))
    (progn
      (package-install 'counsel)))

;; pyvenv
(if (not (package-installed-p 'pyvenv))
    (progn
      (package-install 'pyvenv)))

;; cl-lib
(if (not (package-installed-p 'cl-lib))
    (progn
      (package-install 'cl-lib)))
(require 'cl-lib)

;; typescript-mode
(if (not (package-installed-p 'typescript-mode))
    (progn
      (package-install 'typescript-mode)))

;; lsp-mode
(if (not (package-installed-p 'lsp-mode))
    (progn
      (package-install 'lsp-mode)))

;; rainbow-delimiters
(if (not (package-installed-p 'rainbow-delimiters))
    (progn
      (package-install 'rainbow-delimiters)))

;; org-journal
(if (not (package-installed-p 'org-journal))
    (progn
      (package-install 'org-journal)))
(require 'org-journal)

;; yasnippet-snippets
(if (not (package-installed-p 'yasnippet-snippets))
    (progn
      (package-install 'yasnippet-snippets)))

;; company-dict
(if (not (package-installed-p 'company-dict))
    (progn
      (package-install 'company-dict)))
(require 'company-dict)

;; ivy
(if (not (package-installed-p 'ivy))
    (progn
      (package-install 'ivy)))

;; amx
(if (not (package-installed-p 'amx))
    (progn
      (package-install 'amx)))

;; flx
(if (not (package-installed-p 'flx))
    (progn
      (package-install 'flx)))

;; markdown-mode
(if (not (package-installed-p 'markdown-mode))
    (progn
      (package-install 'markdown-mode)))

(if (not (package-installed-p 'no-littering))
    (progn
      (package-install 'no-littering)))

;; magit
(if (not (package-installed-p 'magit))
    (progn
      (package-install 'magit)))

(if (not (package-installed-p 'magit-delta))
    (progn
      (package-install 'magit-delta)))

(require 'magit)
(magit-delta-mode 1)

(if (not (package-installed-p 'go-mode))
    (progn
      (package-install 'go-mode)))

(if (not (package-installed-p 'smerge-mode))
    (progn
      (package-install 'smerge-mode)))
(require 'smerge-mode)

(if (not (package-installed-p 'hydra))
    (progn
      (package-install 'hydra)))

(if (not (package-installed-p 'gcmh))
    (progn
      (package-install 'gcmh)))
(require 'gcmh)

(if (not (package-installed-p 'pine-script-mode))
    (progn
      (package-install 'pine-script-mode)))
(require 'pine-script-mode)
(add-to-list 'auto-mode-alist '("\\.pine$" . pine-script-mode))

(if (not (package-installed-p 'gnu-elpa-keyring-update))
    (progn
      (package-install 'gnu-elpa-keyring-update)))

(if (not (package-installed-p 'counsel))
    (progn
      (package-install 'counsel)))

(if (not (package-installed-p 'hl-todo))
    (progn
      (package-install 'hl-todo)))

(if (not (package-installed-p 'dumb-jump))
    (progn
      (package-install 'dumb-jump)))

(if (not (package-installed-p 'auctex))
    (progn
      (package-install 'auctex)))

(if (not (package-installed-p 'flycheck-pycheckers))
    (progn
      (package-install 'flycheck-pycheckers)))

(if (not (package-installed-p 'flycheck-mypy))
    (progn
      (package-install 'flycheck-mypy)))

(if (not (package-installed-p 'undo-tree))
    (progn
      (package-install 'undo-tree)))

(if (not (package-installed-p 'bind-key))
    (progn
      (package-install 'bind-key)))

(if (not (package-installed-p 'yaml-mode))
    (progn
      (package-install 'xclip)))

(if (not (package-installed-p 'yaml-mode))
    (progn
      (package-install 'xclip)))

(if (not (package-installed-p 'flycheck))
    (progn
      (package-install 'flycheck)))
(global-flycheck-mode)

(if (not (package-installed-p 'helm-flycheck))
    (progn
      (package-install 'helm-flycheck)))

(if (not (package-installed-p 'helm-flyspell))
    (progn
      (package-install 'helm-flyspell)))

(if (not (package-installed-p 'beginend))
    (progn
      (package-install 'beginend)))

(if (not (package-installed-p 'py-isort))
    (progn
      (package-install 'py-isort)))
(require 'py-isort)  ;; melpa

(if (not (package-installed-p 'smooth-scrolling))
    (progn
      (package-install 'smooth-scrolling)))

(if (not (package-installed-p 'flymake-solidity))
    (progn
      (package-install 'flymake-solidity)))
(require 'flymake-solidity)

(if (not (package-installed-p 'solidity-flycheck))
    (progn
      (package-install 'solidity-flycheck)))
(require 'solidity-flycheck)

(if (not (package-installed-p 'solidity-mode))
    (progn
      (package-install 'solidity-mode)))
(require 'solidity-mode)

(if (not (package-installed-p 'projectile))
    (progn
      (package-install 'projectile)))
(require 'projectile)

(if (not (package-installed-p 'helm-projectile))
    (progn
      (package-install 'helm-projectile)))
(require 'helm-projectile)

(if (not (package-installed-p 'vim-empty-lines-mode))
    (progn
      (package-install 'vim-empty-lines-mode)))

(if (not (package-installed-p 'hydra))
    (progn
      (package-install 'hydra)))

(if (not (package-installed-p 'yaml-mode))
    (progn
      (package-install 'yaml-mode)))

(if (not (package-installed-p 'recentf))
    (progn
      (package-install 'recentf)))
(require 'recentf)

(if (not (package-installed-p 'yasnippet-classic-snippets))
    (progn
      (package-install 'yasnippet-classic-snippets)))

(if (not (package-installed-p 'dotenv-mode))
    (progn
      (package-install 'dotenv-mode)))
(require 'dotenv-mode)

;; (if (not (package-installed-p 'which-key))
;;     (progn
;;       (package-install 'which-key)))
;; (require 'which-key)

;; (if (not (package-installed-p 'smex))
;;     (progn
;;       (package-install 'smex)))

(if (not (package-installed-p 'exec-path-from-shell))
    (progn
      (package-install 'exec-path-from-shell)))

(eval-when-compile (require 'cl))

(if (not (package-installed-p 'projectile-git-autofetch))
    (progn
      (package-install 'projectile-git-autofetch)))

(if (not (package-installed-p 'company-quickhelp))
    (progn
      (package-install 'company-quickhelp)))

(if (not (package-installed-p 'easy-kill))
    (progn
      (package-install 'easy-kill)))

(require 's)  ;; melpa
(require 'dash)  ;; melpa

(defhydra python-indent (python-mode-map "C-c")  ;; for python
  "Adjust python indentation."
  (">" python-indent-shift-right "right")
  ("<" python-indent-shift-left "left"))

(defhydra python-indent (global-map "C-c")
  "Adjust python indentation."
  (">" python-indent-shift-right "right")
  ("<" python-indent-shift-left "left"))

;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
;; https://emacs.stackexchange.com/questions/16469/how-to-merge-git-conflicts-in-emacs
(eval-after-load 'smerge-mode
  (lambda ()
    (define-key smerge-mode-map (kbd "C-c v") smerge-basic-map)
    (define-key smerge-mode-map (kbd "C-c C-v") smerge-basic-map)))

(defun smerge-next-safe ()
  "Return t on success, nil otherwise"
  (ignore-errors (not (smerge-next))))

(defun next-conflict ()
  (interactive)
  (let ((buffer (current-buffer)))
    (when (not (smerge-next-safe))
      (vc-find-conflicted-file)
      (when (eq buffer (current-buffer))
        (let ((prev-pos (point)))
          (goto-char (point-min))
          (unless (smerge-next-safe)
            (goto-char prev-pos)
            (message "No conflicts found")))))))

(global-set-key (kbd "C-c n") 'next-conflict)
(add-hook 'isearch-mode-hook (lambda () (display-line-numbers-mode 1)))
(add-hook 'isearch-mode-end-hook (lambda () (display-line-numbers-mode 0)))
(delete-selection-mode 1) ;; Overwrite selected text

(define-key isearch-mode-map (kbd "C-w") 'isearch-forward-symbol-at-point)

(defadvice isearch-repeat (after isearch-no-fail activate)
  (unless isearch-success
    (ad-disable-advice 'isearch-repeat 'after 'isearch-no-fail)
    (ad-activate 'isearch-repeat)
    (isearch-repeat (if isearch-forward 'forward))
    (ad-enable-advice 'isearch-repeat 'after 'isearch-no-fail)
    (ad-activate 'isearch-repeat)))

(define-advice isearch-repeat (:before (direction) goto-other-end)
  "If reversing, start the search from the other end of the current match."
  (unless (eq isearch-forward (eq direction 'forward))
    (when isearch-other-end
      (goto-char isearch-other-end))))

(setq use-dialog-box nil)
(setq solidity-solc-path "/usr/local/bin/solc")
(setq solidity-solium-path "/usr/local/bin/solium") ;; npm install -g ethlint

(add-to-list 'load-path "~/.emacs.d/lisp")
(load "synonyms.el")
(load "smart-quotes.el")

(define-minor-mode my-keys-minor-mode
  "A minor mode so that my key settings override annoying major modes."
  :init-value t
  :lighter " my-keys")

(my-keys-minor-mode 1)
(transient-mark-mode 1)

;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
(save-place-mode 1)
(setq save-place-file (locate-user-emacs-file "places" ".emacs-places"))
(setq save-place-forget-unreadable-files nil)
(setq savehist-file "~/.emacs.d/tmp/savehist")

(setq projectile-cache-file (expand-file-name "projectile.cache"
                             user-emacs-directory)
      projectile-known-projects-file (expand-file-name "projectile-known-projects.eld"
                                                       user-emacs-directory))

(setq projectile-known-projects-file "~/.emacs.d/tmp/projectile-bookmarks.eld")

(require 'no-littering)
(use-package no-littering
    :ensure t)

; TeX-fold-comment
(cancel-function-timers 'auto-revert-buffers)

(setq lazy-highlight-interval 0)
(add-to-list 'auto-mode-alist '("\\.sol\\'" . solidity-mode))

(global-set-key "\C-x\C-p"  'beginning-of-defun)
(global-set-key "\C-x\C-n"  'end-of-defun)
(global-set-key "\C-x\C-d"  'goto-line)
(global-set-key "\C-x\C-f" 'ido-find-file)
(global-set-key (kbd "C-x C-_") 'undo-tree-redo)
(global-set-key "\M-c" 'nil);
; (global-set-key "\C-x\C-f"  'helm-find-files)

(defun alt-exchange-point-and-mark (&optional arg)
  (interactive "P")
  (exchange-point-and-mark (not arg))
  (recenter-top-bottom)
  )

(run-at-time nil (* 5 60) 'recentf-save-list)
(add-hook 'delete-terminal-functions (lambda (terminal) (recentf-save-list)))
(recentf-load-list)
(setq recentf-save-file (recentf-expand-file-name "~/.emacs.d/.recentf"))

(global-set-key (kbd "C-x C-x") 'alt-exchange-point-and-mark)
(global-set-key (kbd "C-x C-i")
   (lambda ()
      (interactive)
      (kill-new (thing-at-point 'symbol))))

(defun replace-regexp-entire-buffer (pattern replacement)
  "Perform regular-expression replacement throughout buffer."
  (interactive
   (let ((args (query-replace-read-args "Replace" t)))
     (setcdr (cdr args) nil)    ; remove third value returned from query---args
     args))
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward pattern nil t)
      (replace-match replacement))))

(setq-default truncate-lines t)

(global-set-key (kbd "C-0") nil)
(require 'bind-key)
(bind-key "C-l" 'backward-word)
(global-set-key [(control t)] 'nil)

(defun my-clean-frames-and-buffers ()
  "Kills all unmodified buffers and closes all but the selected frame."
  (interactive)
  (save-window-excursion
    (dolist (buffer (buffer-list))
      (and (buffer-live-p buffer)
           (not (buffer-modified-p buffer))
           (kill-buffer buffer))))
  (delete-other-frames))

(global-visual-line-mode 1)

(defun backward-delete-word (arg)
  "Delete characters backward until encountering the beginning of
   a word. With argument ARG, do this that many times."
  (interactive "p")
  (delete-region (point) (progn (backward-word arg) (point))))

(setq-default c-basic-offset 4)

(defun my-bell-function ()
  (unless (memq this-command
        '(isearch-abort abort-recursive-edit exit-minibuffer
              keyboard-quit mwheel-scroll down up next-line previous-line
              backward-char forward-char))
    (ding)))
(setq ring-bell-function 'my-bell-function)

;; Turn on warn highlighting for characters outside of the 'width' char limit
(defun font-lock-width-keyword (width)
  "Return a font-lock style keyword for a string beyond width WIDTH
   that uses 'font-lock-warning-face'."
  `((,(format "^%s\\(.+\\)" (make-string width ?.))
     (1 font-lock-warning-face t))))

(setq python-shell-interpreter "python3"
      python-shell-prompt-detect-failure-warning nil
      flycheck-python-pycompile-executable "python3"
      python-shell-completion-native-enable nil
      python-shell-completion-native-disabled-interpreters '("python3")
      )

(setq compilation-ask-about-save nil)
;;; Don't save *anything*
(setq compilation-save-buffers-predicate '(lambda () nil))
(setq ac-modes '(c-mode python-mode))

; (add-hook 'emacs-lisp-mode-hook '(lambda () (highlight-lines-matching-regexp ".\{101\}" "hi-green-b")))

;; undo-tree
;; =========  https://emacs.stackexchange.com/questions/59942/is-it-possible-suppress-save-message-for-undo-tree
(global-undo-tree-mode 1)
(setq undo-tree-auto-save-history t)
(setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo_tree")))

(defun my-undo-tree-save-history (undo-tree-save-history &rest args)
  (let ((message-log-max nil)
        (inhibit-message t))
    (apply undo-tree-save-history args)))

(advice-add 'undo-tree-save-history :around 'my-undo-tree-save-history)

(defun my-save-all () "My doc-string."
       (interactive)
       (let ((message-log-max nil)
             (inhibit-message t))
         (save-some-buffers t)))

(defun save-all ()
  (interactive)
  (my-save-all)
  (bk-kill-buffers "magit: ebloc-broker")
  (bk-kill-buffers "__init__.py")
  (bk-kill-buffers "*helm"))

(define-key ctl-x-map "\C-s" 'save-all)
(global-set-key (kbd "C-x s")   'save-all)
(global-set-key (kbd "C-x C-s") 'save-all)

; (define-key isearch-mode-map (kbd "C-h") 'isearch-del-char)
(define-key isearch-mode-map (kbd "C-e") 'isearch-edit-string)
(define-key isearch-mode-map (kbd "TAB") 'isearch-del-char)
(define-key helm-map (kbd "C-p") 'helm-previous-line)
(define-key helm-map (kbd "C-s") 'helm-next-line)
(define-key helm-map (kbd "C-o") 'nil)
; (define-key icicles-mode-map (kbd "TAB") 'nil) ;; important

;; Makes *scratch* empty.
;; https://stackoverflow.com/questions/10110027/how-to-make-emacs-start-in-text-mode-and-get-rid-of-lisp-message/10110113
(setq initial-scratch-message "")
(setq initial-major-mode 'text-mode)
(put 'set-goal-column 'disabled nil)

(setq org-log-done 'time)
(require 'flycheck)
(require 'flycheck-mypy)
(add-hook 'solidity-mode-hook 'flycheck-mode)
(add-hook 'solidity-mode-hook
  (lambda ()
    (set-fill-column 80)))

(setq-default flycheck-flake8-maximum-line-length 200)
; (setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc))
(setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc clojure-cider-typed))

(with-eval-after-load 'flycheck
  (setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc)))

; (add-hook 'python-mode-hook 'flycheck-mode) ;; (add-hook 'after-init-hook #'global-flycheck-mode)
; (add-to-list 'flycheck-disabled-checkers 'python-pylint)
(add-hook 'after-init-hook #'global-flycheck-mode)
(add-to-list 'flycheck-disabled-checkers 'python-flake8)

(add-hook 'python-mode-hook
          (lambda ()
            ;; (setq flycheck-mypyrc "~/venv/bin/pylint")
            (setq flycheck-python-pylint-executable "~/venv/bin/pylint")
            (local-set-key (kbd "C-c C-b") 'break-point)
            (setq flycheck-pylintrc "~/.pylintrc")))

(flycheck-add-next-checker 'python-flake8 'python-pylint 'python-mypy)
(defun flycheck-or-norm-next-error (&optional n reset)
  (interactive "P")
  (if flycheck-mode
      (flycheck-next-error n reset)
    (next-error n reset)))

(defun flycheck-or-norm-previous-error (&optional n)
  (interactive "P")
  (if flycheck-mode
      (flycheck-previous-error n)
    (previous-error n)))

;; Optional: ensure flycheck cycles, both when going backward and forward.
;; Tries to handle arguments correctly.
;; Since flycheck-previous-error is written in terms of flycheck-next-error,
;; advising the latter is enough.
(defun flycheck-next-error-loop-advice (orig-fun &optional n reset)
  ; (message "flycheck-next-error called with args %S %S" n reset)
  (condition-case err
      (apply orig-fun (list n reset))
    ((user-error)
     (let ((error-count (length flycheck-current-errors)))
       (if (and
            (> error-count 0)                   ; There are errors so we can cycle.
            (equal (error-message-string err) "No more Flycheck errors"))
           ;; We need to cycle.
           (let* ((req-n (if (numberp n) n 1)) ; Requested displacement.
                  ; An universal argument is taken as reset, so shouldn't fail.
                  (curr-pos (if (> req-n 0) (- error-count 1) 0)) ; 0-indexed.
                  (next-pos (mod (+ curr-pos req-n) error-count))) ; next-pos must be 1-indexed
             ; (message "error-count %S; req-n %S; curr-pos %S; next-pos %S" error-count req-n curr-pos next-pos)
             ; orig-fun is flycheck-next-error (but without advise)
             ; Argument to flycheck-next-error must be 1-based.
             (apply orig-fun (list (+ 1 next-pos) 'reset)))
         (signal (car err) (cdr err)))))))

(advice-add 'flycheck-next-error :around #'flycheck-next-error-loop-advice)

;; The following might be needed to ensure flycheck is loaded.
;; Hooking is required if flycheck is installed as an ELPA package (from any repo).
;; If you use ELPA, you might want to merge this with any existing hook you might have.
(add-hook 'after-init-hook
          #'(lambda ()
              (after-packages-loaded-hook)))

(defun after-packages-loaded-hook ()
  (require 'flycheck))
(global-set-key (kbd "M-g p") 'flycheck-or-norm-previous-error)

;; flycheck-pycheckers
;; Allows multiple syntax checkers to run in parallel on Python code
;; Ideal use-case: pyflakes for syntax combined with mypy for typing
(use-package flycheck-pycheckers
  :after flycheck
  :ensure t
  :init
  (with-eval-after-load 'flycheck
    (add-hook 'flycheck-mode-hook #'flycheck-pycheckers-setup)
    )
  (setq flycheck-pycheckers-checkers
    '(
      mypy3
      ;; pyflakes ;; alper
      )
    )
  )

(add-hook 'before-save-hook
          'delete-trailing-whitespace)

(add-hook 'before-save-hook
          'delete-trailing-whitespace)

(add-hook 'shell-script-mode
  (lambda ()
    (setq indent-tabs-mode nil)
    (setq tab-width 4)
    (untabify (point-min) (point-max))))

;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
(defun set-background-for-terminal (&optional frame)
  (or frame (setq frame (selected-frame)))
  "unsets the background color in terminal mode"
  (unless (display-graphic-p frame)
    (set-face-background 'default "unspecified-bg" frame)))
(add-hook 'after-make-frame-functions 'set-background-for-terminal)
(add-hook 'window-setup-hook 'set-background-for-terminal)


'(font-lock-comment-face ((t (:foreground "MediumAquamarine"))))

(defface hl-todo-TODO
  '((t :background "#f1fa8c" :foreground "#282a36" :weight bold :inherit (hl-todo)))
  "")

(defface hl-todo-FIXME
  '((t :background "#8be9fd" :foreground "#282a36" :weight bold :inherit (hl-todo)))
  "")

(defface hl-debug
  '((t :background "#f1fa8c" :foreground "red" :weight bold :inherit (hl-todo)))
  "")

(setq hl-todo-keyword-faces
      '(("TODO"   . hl-todo-TODO)
        ("FIXME"  . hl-todo-FIXME)
        ("DEBUG"  . hl-debug)
        ("GOTCHA" . "#FF4500")
        ("STUB"   . "#A020F0")))

;;;; Company ----------------------------------------------------------
(add-hook 'after-init-hook 'global-company-mode)
(setq company-auto-commit t)

(defun company-abort-and-insert-dash ()
  (interactive)
  (company-abort)
  (insert "-"))

(defun company-abort-and-insert-comma ()
  (interactive)
  (company-abort)
  (insert ","))

(defun company-abort-and-insert-space ()
  (interactive)
  (company-abort)
  (insert " "))

(defun company-abort-and-insert-dot ()
  (interactive)
  (company-abort)
  (insert "."))

(defun company-abort-and-insert-equal ()
  (interactive)
  (company-abort)
  (insert "="))

(defun company-abort-and-insert-semit ()
  (interactive)
  (company-abort)
  (insert ":"))

(defun company-abort-and-insert-slash ()
  (interactive)
  (company-abort)
  (insert "/"))

(defun company-abort-and-insert-par ()
  (interactive)
  (company-abort)
  (insert ")"))

(defun company-abort-and-search ()
  (interactive)
  (company-abort))


; https://github.com/company-mode/company-mode/blob/1c7a87283146f429c5076e8ea0a559556a4d4272/company.el#L671
(with-eval-after-load "company"
  (define-key company-active-map (kbd "C-p") #'company-select-previous-or-abort)
  (define-key company-active-map (kbd "C-n") #'company-select-next-or-abort)
  (define-key company-active-map (kbd "C-h") #'backward-delete-char)
  (define-key company-active-map (kbd "SPC") #'company-abort-and-insert-space)
  (define-key company-active-map (kbd "C-f") #'company-abort)
  (define-key company-active-map (kbd "C-a") #'company-abort)
  (define-key company-active-map (kbd "C-SPC") #'company-abort) ;; TODO
  (define-key company-active-map (kbd "-") #'company-abort-and-insert-dash)
  (define-key company-active-map (kbd ".") #'company-abort-and-insert-dot)
  (define-key company-active-map (kbd ",") #'company-abort-and-insert-comma)
  ;;
  (define-key company-active-map (kbd "C-s") #'company-abort-and-search)
  ;;
  (define-key company-active-map (kbd "/") #'company-abort-and-insert-slash)
  (define-key company-active-map (kbd ":") #'company-abort-and-insert-semit)
  (define-key company-active-map (kbd "=") #'company-abort-and-insert-equal)
  (define-key company-active-map (kbd ")") #'company-abort-and-insert-par)
  (define-key company-active-map (kbd "C-e") #'company-complete-selection))

(eval-after-load 'company
  '(progn
     (define-key company-active-map (kbd "TAB") 'company-complete-common-or-cycle)
     (define-key company-active-map (kbd "<tab>") 'company-complete-common-or-cycle)))

(setq company-frontends
      '(company-pseudo-tooltip-unless-just-one-frontend
        company-preview-frontend
        company-echo-metadata-frontend))

;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
(recentf-mode 1)
(setq recentf-max-saved-items 50)
(setq recentf-max-menu-items 50)
(setq recentf-exclude '("*lsp-log*"
                        "pyls::stderr"
                        ))

(setq helm-locate-command "locate %s -e -A --regex %s")
(setq helm-locate-fuzzy-match t)

;; (global-set-key "\C-x\C-e" 'recentf-open-files)
;; (global-set-key "\C-x\C-e" 'helm-recentf)
(global-set-key "\C-x\C-e" 'helm-for-files)

(setq display-buffer-alist
      '(("*" . (nil . (reusable-frames 0)))))

(defun goto-line-with-feedback ()
  "Show line numbers temporarily, while prompting for the line number input"
  (interactive)
  (if (and (boundp 'display-line-numbers-mode)
           display-line-numbers-mode)
      (call-interactively 'goto-line)
    (unwind-protect
        (progn
          (display-line-numbers-mode 1)
          (call-interactively 'goto-line))
      (display-line-numbers-mode -1))))

(global-set-key [remap goto-line] 'goto-line-with-feedback)

(defconst erlang-xemacs-p (string-match "Lucid\\|XEmacs" emacs-version)
  "Non-nil when running under XEmacs or Lucid Emacs.")

(setq message-log-max t)

(if (locate-library "ediff-trees")
    (autoload 'ediff-trees "ediff-trees" "Start an tree ediff" t))

(setq flymake-start-on-flymake-mode nil)
;; (setq python-indent-guess-indent-offset t)
;; (setq python-indent-guess-indent-offset-verbose nil)

(global-set-key (kbd "C-c C-r") 'helm-mini)
(setq mark-even-if-inactive nil)

;; (setq recentf-auto-cleanup 'never)
(defun my-insert-import (to_insert)
  (newline)
  (if (s-starts-with? "from" (s-trim to_insert)) (insert (s-trim to_insert))
    (insert "import " to_insert))
  )

(setq py-isort-options '("--force_single_line_imports"))
(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse)
(setq frame-title-format
      (list (format "%s %%S: %%j " (system-name))
        '(buffer-file-name "%f" (dired-directory dired-directory "%b"))))

(setq inhibit-default-init t)

;; SHOW FILE PATH IN FRAME TITLE
; (setq-default frame-title-format "%b (%f)")
;; (defun my-re-search-forward (&optional word)
;;   "Searches for the last copied solitary WORD, unless WORD is given. "
;;   (interactive)
;;   (let ((word (or word (car kill-ring))))
;;     (re-search-forward (concat "\\_<" word "\\_>") nil t 1)
;;     (set-mark (point))
;;     (goto-char (match-beginning 0))
;;     (exchange-point-and-mark)))
;; (global-set-key "\C-c\C-i" 'my-re-search-forward)

(defun my-find-file-check-make-large-file-read-only-hook ()
  "If a file is over a given size, make the buffer read only."
  (when (> (buffer-size) (* 1024 1024))
    ; (setq buffer-read-only t)
    (buffer-disable-undo)
    (fundamental-mode)))

(add-hook 'find-file-hook 'my-find-file-check-make-large-file-read-only-hook)
(global-set-key "\C-x\ m"  'nil);

;;;;;;;;;;-----------------------------------------------------------------------------------
;; https://www.emacswiki.org/emacs/IbufferMode
;; https://stackoverflow.com/a/3419686/2402577
(setq ibuffer-saved-filter-groups
      (quote (("default"
           ("dired" (mode . dired-mode))
           ("org" (name . "^.*org$"))

           ("web" (or (mode . web-mode) (mode . js2-mode)))
           ("shell" (or (mode . eshell-mode) (mode . shell-mode)))
           ("mu4e" (name . "\*mu4e\*"))
           ("ebloc-broker/"
                (filename . "ebloc-broker/"))
           ("Default" (or
                   (mode . python-mode)
                   (mode . c++-mode)))
           ("emacs" (or
                     (name . "^\\*magit\\*$")
                     (name . "^\\*scratch\\*$")
                     (name . "^\\*Messages\\*$")))
           ))))

(add-hook 'ibuffer-hook (lambda ()
                          (ibuffer-filter-by-size-gt 0)))

(add-hook 'ibuffer-mode-hook
      (lambda ()
        (ibuffer-auto-mode 1)
        (ibuffer-switch-to-saved-filter-groups "default")))

(setq ibuffer-show-empty-filter-groups nil)
(setq ibuffer-expert t)

(defadvice ibuffer-update-title-and-summary (after remove-column-titles)
  (with-current-buffer
      (set-buffer "*Ibuffer*")
    (read-only-mode 0)
    (goto-char 1)
    (search-forward "-\n" nil t)
    (delete-region 1 (point))
    (let ((window-min-height 1))
      ;; save a little screen estate
      (shrink-window-if-larger-than-buffer))
    (read-only-mode)))

(ad-activate 'ibuffer-update-title-and-summary)

;; Use human readable Size column instead of original one
(define-ibuffer-column size-h
  (:name "Size" :inline t)
  (cond
   ((> (buffer-size) 1000000) (format "%7.1fM" (/ (buffer-size) 1000000.0)))
   ((> (buffer-size) 100000) (format "%7.0fk" (/ (buffer-size) 1000.0)))
   ((> (buffer-size) 1000) (format "%7.1fk" (/ (buffer-size) 1000.0)))
   (t (format "%8d" (buffer-size)))))

;; Modify the default ibuffer-formats
  (setq ibuffer-formats
    '((mark modified read-only " "
        (name 18 18 :left :elide)
        " "
        (size-h 9 -1 :right)
        " "
        (mode 16 16 :left :elide)
        " "
        filename-and-process)))

;; Ensure ibuffer opens with point at the current buffer's entry.
(defadvice ibuffer
  (around ibuffer-point-to-most-recent) ()
  "Open ibuffer with cursor pointed to most recent buffer name."
  (let ((recent-buffer-name (buffer-name)))
    ad-do-it
    (ibuffer-jump-to-buffer recent-buffer-name)))
(ad-activate 'ibuffer)

(defun ibuffer-advance-motion (direction)
  (forward-line direction)
  (beginning-of-line)
  (if (not (get-text-property (point) 'ibuffer-filter-group-name))
      t
    (ibuffer-skip-properties '(ibuffer-filter-group-name)
                 direction)
    nil))

  (defun ibuffer-previous-line ()
    (interactive) (previous-line)
    (if (<= (line-number-at-pos) 2)
        (goto-line (- (count-lines (point-min) (point-max)) 2))))

(defun ibuffer-next-line (&optional arg)
    "Move forward ARG lines, wrapping around the list if necessary."
    (interactive "P")
    (or arg (setq arg 1))
    (let (err1 err2)
      (while (> arg 0)
        (cl-decf arg)
        (setq err1 (ibuffer-advance-motion 1)
              err2 (if (not (get-text-property (point) 'ibuffer-summary))
                       t
                     (goto-char (point-min))
                     (beginning-of-line)
                     (ibuffer-skip-properties '(ibuffer-summary
                                                ibuffer-filter-group-name
                                                ibuffer-title)
                                              1)
                     nil)))
      (and err1 err2)))

(defun ibuffer-next-header ()
  (interactive)
  (while (ibuffer-next-line)))

(defun ibuffer-previous-header ()
  (interactive)
  (while (ibuffer-previous-line)))

(define-key ibuffer-mode-map (kbd "C-p") 'ibuffer-previous-line)
(define-key ibuffer-mode-map (kbd "C-n") 'ibuffer-next-line)
(define-key ibuffer-mode-map (kbd "C-x C-f") 'ibuffer-jump-to-buffer)
(define-key ibuffer-mode-map (kbd "M-p") 'ibuffer-previous-header)
(define-key ibuffer-mode-map (kbd "M-n") 'ibuffer-next-header)
(define-key ibuffer-mode-map (kbd "C-q") 'quit-window)

(set-face-attribute 'default nil :height 100)

;;;;;;;;;;-----------------------------------------------------------------------------------
(require 'helm)
(require 'helm-config)

;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))

; https://github.com/emacs-helm/helm/blob/4ff354efb6b24044fd38b725b61d470bd5423265/helm.el#L184
; (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
; (define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB work in terminal

;(define-key helm-map (kbd "<tab>") 'helm-next-line) ; rebind tab to run persistent action
; (define-key helm-map (kbd "M-p")   'helm-previos-source) ; rebind tab to run persistent action
(define-key helm-map (kbd "<tab>") 'helm-next-source) ; rebind tab to run persistent action
(define-key helm-map (kbd "C-i") 'helm-next-source) ; make TAB work in terminal

(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z
(define-key helm-map (kbd "M-;") 'helm-keyboard-quit) ; exit with same entered key

(global-set-key (kbd "M-j") 'nil)
(global-set-key (kbd "M-k") 'previous-buffer)
(global-set-key (kbd "M-l") 'next-buffer)

;; (define-key helm-map (kbd "<tab>") 'undefined) ; rebind tab to run persistent action
;; (define-key helm-map (kbd "C-i") 'undefined) ; make TAB work in terminal
;; (define-key helm-map (kbd "<tab>") 'helm-next-line) ; rebind tab to run persistent action
;; (define-key helm-map (kbd "C-i") 'helm-next-line) ; make TAB work in terminal

(when (executable-find "curl")
  (setq helm-google-suggest-use-curl-p t))

(setq helm-split-window-inside-p           nil ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t
      helm-echo-input-in-header-line t)

(setq helm-display-header-line nil) ;; t by default
(set-face-attribute 'helm-source-header nil :height 0.1)

(setq helm-autoresize-max-height 40) ;; 0 olursa tum buffer
(setq helm-autoresize-min-height 40)
(helm-autoresize-mode t)
(helm-mode 1)

(setq dired-omit-files
      (rx (or (seq bol (? ".") "#")
              (seq bol "." eol)
              (seq bol ".." eol)
              )))

(require 'files)

(global-set-key [(control ?v)]
        (lambda () (interactive (next-line (/ (window-height (selected-window)) 2)))))

(global-set-key [(control ?t)]
        (lambda () (interactive (previous-line (/ (window-height (selected-window)) 2)))))

(global-set-key [(meta ?v)]
        (lambda () (interactive (previous-line (/ (window-height (selected-window)) 2)))))

(projectile-global-mode)
(setq projectile-completion-system 'helm)
(helm-projectile-on)

(defface helm-match
  '((((background light)) :background "#f1fa8c" :foreground "#282a36" :weight bold)
    (((background dark))  :background "#f1fa8c" :foreground "#282a36" :weight bold))
  "Face used to highlight matches."
  :group 'helm-faces)

(defface helm-grep-match
  '((((background light)) :background "#f1fa8c" :foreground "#282a36" :weight bold)
    (((background dark))  :background "#f1fa8c" :foreground "#282a36" :weight bold))
  "Face used to highlight matches."
  :group 'helm-faces)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(diff-added ((t (:inherit diff-changed :foreground "green"))))
 '(diff-removed ((t (:inherit diff-changed :foreground "red"))))
 '(font-latex-script-char-face ((t (:foreground "yellow"))))
 '(helm-grep-match ((t (:inherit grep-match :background "#f1fa8c" :foreground "black"))))
 '(ivy-current-match ((t (:weight bold :foreground "brightwhite"))))
 '(ivy-minibuffer-match-face-2 ((t (:background "color-160" :foreground "brightwhite" :weight bold))))
 '(ivy-prompt-match ((t (:inherit org-level-4))))
 '(magit-diff-context-highlight ((t (:background "#464752" :weight bold :foreground "brightwhite"))))
 '(magit-diff-file-heading-highlight ((t (:inherit magit-section-highlight :foreground "white" :weight extra-bold))))
 '(sh-escaped-newline ((t (:foreground "cyan" :weight bold))))
 '(undo-tree-visualizer-active-branch-face ((t (:foreground "green"))))
 '(undo-tree-visualizer-current-face ((t (:foreground "red"))))
 '(widget-field ((t (:background "brightcyan" :foreground "black")))))

;; Disabled *Completions*
(add-hook 'minibuffer-exit-hook
      '(lambda ()
         (let ((buffer "*Completions*"))
           (and (get-buffer buffer)
        (kill-buffer buffer)))))

;;;;;;;;; Make *scratch* buffer blank.
(setq initial-scratch-message nil)

(defun flycheck-display-error-messages-unless-error-buffer (errors)
  (unless (get-buffer-window flycheck-error-list-buffer)
    (flycheck-display-error-messages errors)))

(setq flycheck-display-errors-function #'flycheck-display-error-messages-unless-error-buffer)
(global-set-key [(control x) (k)] 'kill-this-buffer)

(defun bk-kill-buffers (regexp)
  "Kill buffers matching REGEXP without asking for confirmation."
  (interactive "sKill buffers matching this regular expression: ")
  (flet ((kill-buffer-ask (buffer) (kill-buffer buffer)))
    (kill-matching-buffers regexp)))

(defun kill-other-buffers ()
    "Kill all other buffers."
    (interactive)
    (mapc 'kill-buffer
          (delq (current-buffer)
                (cl-remove-if-not 'buffer-file-name (buffer-list)))))

(global-set-key (kbd "C-x K") 'kill-other-buffers)

;; (defun kill-other-buffers ()
;;       "Kill all other buffers."
;;       (interactive)
;;       (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))
;; (global-set-key "\C-x\C-m" 'kill-other-buffers);

(defun full-auto-save ()
  (interactive)
  (save-excursion
    (dolist (buf (buffer-list))
      (set-buffer buf)
      (if (and (buffer-file-name) (buffer-modified-p))
          (basic-save-buffer)))))

(add-hook 'auto-save-hook 'full-auto-save)
;; (bk-kill-buffers "*helm")
;; (kill-buffer "*scratch*")

(defmacro with-suppressed-message (&rest body)
  "Suppress new messages temporarily in the echo area and the `*Messages*' buffer while BODY is evaluated."
  (declare (indent 0))
  (let ((message-log-max nil))
    `(with-temp-message (or (current-message) "") ,@body)))

(defcustom helm-for-files-preferred-list
  '(helm-source-buffers-list
    helm-source-recentf
    helm-source-file-cache
    helm-source-files-in-current-dir
    ;; helm-source-bookmarks
    )
  helm-source-locate)
;;   :type '(repeat (choice symbol))
;;   :group 'helm-files)

(setq helm-mini-default-sources '(helm-source-recentf
                                  helm-source-buffers-list
                                  helm-source-bookmarks
                                  helm-source-dired-recent-dirs
                                  ))

(defcustom helm-for-files-tramp-not-fancy t
  "Colorize remote files when non nil. Be aware that a nil value will make tramp display very slow."
  :group 'helm-files
  :type  'boolean)

; (kill-buffer "*scratch*")
; (kill-matching-buffers "*helm")

;; (define-key helm-map (kbd "C-h") 'delete-backward-char)
(define-key helm-map (kbd "\C-q") 'helm-keyboard-quit)
(define-key helm-map (kbd "\C-o") nil)

;; Display ido results vertically, rather than horizontally
(setq ido-decorations (quote ("\n-> " "" "\n   " "\n   ..." "[" "]" " [No match]" " [Matched]" " [Not readable]" " [Too big]" " [Confirm]")))

(defun ido-disable-line-truncation () (set (make-local-variable 'truncate-lines) nil))
(add-hook 'ido-minibuffer-setup-hook 'ido-disable-line-truncation)

;; ;; https://stackoverflow.com/a/23365580/2402577
;; ;; Removes *scratch* from buffer after the mode has been set.
(defun remove-scratch-buffer ()
  (if (get-buffer "*scratch*")
      (kill-buffer "*scratch*")))

(add-hook 'after-change-major-mode-hook 'remove-scratch-buffer)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;; Removes *messages* from the buffer.
; (setq-default message-log-max nil)
; (kill-buffer "*Messages*")

;; Removes *Completions* from buffer after you've opened a file. alper
(add-hook 'minibuffer-exit-hook
      '(lambda ()
         (let ((buffer "*Completions*"))
           (and (get-buffer buffer)
                (kill-buffer buffer)))))

;; Don't show *Buffer list* when opening multiple files at the same time.
(setq inhibit-startup-buffer-menu t)

;; Show only one active window when opening multiple files at the same time.
(add-hook 'window-setup-hook 'delete-other-windows)

(global-set-key (kbd "C-x o") 'other-window)
(global-set-key "\C-x\C-o"  'other-window)
(global-set-key (kbd "M-p") 'other-window)

(global-set-key "\C-x2" (lambda () (interactive)(split-window-vertically) (other-window 1)))
(global-set-key "\C-x3" (lambda () (interactive)(split-window-horizontally) (other-window 1)))

(add-hook 'solidity-mode-hook 'flymake-solidity-load)
(setq flymake-solidity-executable "/usr/bin/solc")

(add-to-list 'flycheck-checkers 'solidity-checker)
(add-to-list 'flycheck-checkers 'solium-checker)

(setq flycheck-solidity-solc-addstd-contracts t)
(setq solidity-flycheck-solc-checker-active t)
(setq solidity-flycheck-solium-checker-active t)

; L A T E X ;
(setq LaTeX-item-indent 0)
(add-hook 'LaTeX-mode-hook 'hl-todo-mode)
(setq-default fill-column 80)  ; M-q
(require 'tex)

(add-hook 'TeX-update-style-hook 'hl-todo-mode)

(add-hook 'LaTeX-mode-hook (lambda ()
  (TeX-global-PDF-mode t)
  ))

(defun check-previous-spelling-error ()
  "Jump to previous spelling error and correct it"
  (interactive)
  (push-mark-no-activate)
  (flyspell-goto-previous-error 1)
  (call-interactively 'helm-flyspell-correct))

(defun check-next-spelling-error ()
  "Jump to next spelling error and correct it"
  (interactive)
  (push-mark-no-activate)
  (flyspell-goto-next-error)
  (call-interactively 'helm-flyspell-correct))

(defun push-mark-no-activate ()
  "Pushes `point' to `mark-ring' and does not activate the region
 Equivalent to \\[set-mark-command] when \\[transient-mark-mode] is disabled"
  (interactive)
  (push-mark (point) t nil)
  (message "Pushed mark to ring"))

(setq gc-cons-threshold 20000000) ; ~20MB

;;; show package load time
; (defconst emacs-start-time (current-time))
;; (let ((elapsed (float-time (time-subtract (current-time)
;                                          emacs-start-time))))
;  (message "Loaded packages in %.3fs" elapsed))

(setq ispell-program-name "aspell")

(use-package shell-script-mode
  :ensure nil
  :defer t
  :mode "\\.sh\\'"
  :init
  (setq sh-basic-offset 4
        sh-indentation  4)

  (setq auto-mode-alist
        (cl-union auto-mode-alist
                  '(("\\.bash_profile\\'"  . shell-script-mode)
                    ("\\.ssh_addresses\\'" . shell-script-mode)
                    ("\\.pdbrc\\'"         . shell-script-mode)
                    ("\\.aliases\\'"       . shell-script-mode)
                    ("\\.tmux.conf\\'"     . shell-script-mode)
                    ("\\.zpath\\'"         . shell-script-mode)
                    ("\\.bashrc\\'"        . shell-script-mode)
                    ("\\.inputrc\\'"       . shell-script-mode)
                    ("\\.profile\\'"       . shell-script-mode)
                    ("\\.zprofile\\'"      . shell-script-mode)
                    ("inputrc\\'"          . shell-script-mode)
                    ("ssh_addresses\\'"    . shell-script-mode)
                    ("aliases\\'"          . shell-script-mode)
                    ("profile\\'"          . shell-script-mode)
                    ("bash_profile\\'"     . shell-script-mode)
                    ("zprofile\\'"         . shell-script-mode)
                    ("bashrc\\'"           . shell-script-mode)
                    ("zshrc\\'"            . shell-script-mode)
                    ("\\.zshrc\\'"         . shell-script-mode)))))

(defun launch-separate-emacs-in-terminal ()
  (suspend-emacs "fg ; emacs -nw"))

(defun launch-separate-emacs-under-x ()
  (call-process "sh" nil nil nil "-c" "emacs &"))

(defun restart-emacs ()
  (interactive)
  ;; We need the new emacs to be spawned after all kill-emacs-hooks
  ;; have been processed and there is nothing interesting left
  (let ((kill-emacs-hook (append kill-emacs-hook (list (if (display-graphic-p)
                                                           #'launch-separate-emacs-under-x
                                                           #'launch-separate-emacs-in-terminal)))))
    (save-buffers-kill-emacs)))

;; (let ((elapsed (float-time (time-subtract (current-time)
;                                          emacs-start-time))))
;  (message "Loaded emacs in %.3fs" elapsed))

(set-variable 'search-whitespace-regexp nil)

(setq visible-bell       nil
      ring-bell-function #'ignore)

;; (setq initial-major-mode 'tuareg-mode)
(setq inhibit-startup-screen t)
(setq column-number-mode t)

(defvar mode-line-cleaner-alist
  `((auto-complete-mode . " α")
    (paredit-mode . " π")
    (eldoc-mode . "")
    (abbrev-mode . "")
    ;; Major modes
    (lisp-interaction-mode . "λ")
    (hi-lock-mode . "")
    (python-mode . "Py")
    (emacs-lisp-mode . "EL")
    (nxhtml-mode . "nx"))
  "Alist for `clean-mode-line'.

When you add a new element to the alist, keep in mind that you
must pass the correct minor/major mode symbol and a string you
want to use in the modeline *in lieu of* the original.")
(defun clean-mode-line ()
  (interactive)
  (loop for cleaner in mode-line-cleaner-alist
        do (let* ((mode (car cleaner))
                 (mode-str (cdr cleaner))
                 (old-mode-str (cdr (assq mode minor-mode-alist))))
             (when old-mode-str
                 (setcar old-mode-str mode-str))
               ;; major mode
             (when (eq mode major-mode)
               (setq mode-name mode-str)))))

;;; `flymake-report-status'
(defalias 'flymake-report-status 'flymake-report-status-slim)
(defun flymake-report-status-slim (e-w &optional status)
  "Show \"slim\" flymake status in mode line."
  (when e-w
    (setq flymake-mode-line-e-w e-w))
  (when status
    (setq flymake-mode-line-status status))
  (let* ((mode-line " Φ"))
    (when (> (length flymake-mode-line-e-w) 0)
      (setq mode-line (concat mode-line ":" flymake-mode-line-e-w)))
    (setq mode-line (concat mode-line flymake-mode-line-status))
    (setq flymake-mode-line mode-line)
    (force-mode-line-update)))

(diminish 'projectile-mode)
(diminish 'undo-tree-mode)
(diminish 'helm-mode)
(diminish 'flycheck-mode)
(diminish 'wrap-mode)
(diminish 'visual-line-mode)
(diminish 'gcmh-mode)
;; (diminish 'which-key-mode)

(setq-default mode-line-format
  (list "%e"
        mode-line-front-space
        '(:eval (when (file-remote-p default-directory)
                  (propertize "%1@"
                              'mouse-face 'mode-line-highlight
                              'help-echo (concat "remote: " default-directory))))
        '(:eval (cond (buffer-read-only "%* ")
                      ((buffer-modified-p) "❉ ")
                      (t "  ")))
        '(:eval (propertize "%12b" 'face 'mode-line-buffer-id 'help-echo default-directory))
    'default-directory
    `(vc-mode vc-mode)
    " "
    "("
        'system-name
    ")"
    " "
    ;; the current major mode for the buffer.
    "["
    '(:eval (propertize "%m" 'face 'font-lock-string-face
              'help-echo buffer-file-coding-system))
    "] "
    " "
    '(-3 "%p")
    " "
    ;; line and column
    "(" ;; '%02' to set to 2 chars at least; prevents flickering
    (propertize "%02l" 'face 'font-lock-keyword-face) ","
    (propertize "%02c" 'face 'font-lock-keyword-face)
    ") "
    minor-mode-alist
    "-%-" ; dashes sufficient to fill rest of modeline.
    ))

(add-hook 'after-change-major-mode-hook 'clean-mode-line)

(defun flymake--transform-mode-line-format (ret)
  "Change the output of `flymake--mode-line-format'."
  (setf (seq-elt (car ret) 1) " FM")
  ret)
(advice-add #'flymake--mode-line-format
            :filter-return #'flymake--transform-mode-line-format)

(setq inhibit-splash-screen t)
(setq m/header-icon-face 'all-the-icons-lblue) ;; Face for icons
(setq m/spam '(
           "^ "
           "^\\*Buffer List\\*$"
           "^\\*Backtrace\\*$"
           "^\\*WoMan-Log\\*$"
           "^\\*Compile-Log\\*$"
           "^\\*Flymake\\*$"
           "^\\*tramp/.+\\*$"
           "^\\*evil-marks\\*$"
           "^\\*evil-registers\\*$"
           "^\\*Shell Command Output\\*$"
           "^\\*helm[- ].+\\*$"
           "^\\*magit\\(-\\w+\\)?: .+$"
           "^\\*irc\\..+\\*$"
           "\\*helm-mode"
           "\\*Echo Area"
           "\\*Minibuf"
           "\\ *code-conversion-work\\*"
           "org-src-fontification.+"
           "\\*helm-mode.+"
           "\\*Org-Babel Error"))

(setq warning-minimum-level :emergency)

;; for optionally supporting additional file extensions such as `.env.test' with this major mode
(add-to-list 'auto-mode-alist '("\\.env\\..*\\'" . dotenv-mode))

; (global-set-key (kbd "M-i") 'helm-flyspell-correct)
(global-set-key (kbd "M-;") 'helm-flyspell-correct)
;; (define-key input-decode-map "\C-i" [C-i])

; (font-lock-add-keywords 'markdown-mode (font-lock-width-keyword 72))
(defun flyspell-generic-textmode-verify ()
  "Used for `flyspell-generic-check-word-predicate' in text modes."
  ;; (point) is next char after the word. Must check one char before.
  (let ((f (get-text-property (- (point) 1) 'face)))
    (not (memq f '(markdown-pre-face)))))

(setq flyspell-generic-check-word-predicate 'flyspell-generic-textmode-verify)
(setq flyspell-large-region 1)
(setq ispell-program-name nil)

; (flyspell-lazy-mode 1)
(flyspell-mode 1)
(setq flyspell-issue-message-flag nil
      ispell-local-dictionary "en_US"
      ispell-program-name "aspell"
      ispell-extra-args '("--sug-mode=ultra"))

(dolist (hook '(text-mode-hook))
     (add-hook hook (lambda () (flyspell-mode 1))))
    (dolist (hook '(change-log-mode-hook log-edit-mode-hook))
      (add-hook hook (lambda () (flyspell-mode -1))))

(setq isearch-lax-whitespace t)
(setq isearch-regexp-lax-whitespace t)
(setq search-whitespace-regexp "[ \t\r\n]+")

(global-hl-todo-mode 1)

(add-hook 'find-file-hook 'my-project-hook)
(defun my-project-hook ()
  (when (string= (file-name-extension buffer-file-name) "tex")
    (flyspell-buffer)))
;     (flyspell-lazy-check-buffer)))

(defun org-todo-list-current-file (&optional arg)
  "Like `org-todo-list', but using only the current buffer's file."
  (interactive "P")
  (let ((org-agenda-files (list (buffer-file-name (current-buffer)))))
    (if (null (car org-agenda-files))
        (error "%s is not visiting a file" (buffer-name (current-buffer)))
      (org-todo-list arg))))

(defun my-adaptive-fill-function ()
  "Return prefix for filling paragraph or nil if not determined."
  (cond
   ;; List item inside blockquote
   ((looking-at "^[ \t]*>[ \t]*\\([0-9]+\\.\\|[*+-]\\)[ \t]+")
    (replace-regexp-in-string
     "[0-9\\.*+-]" " " (match-string-no-properties 0)))
   ;; Blockquote
   ((looking-at "^[ \t]*>[ \t]*")
    (match-string-no-properties 0))
   ;; List items
   ((looking-at "^\\([ \t]*\\)\\([0-9]+\\.\\|[\\*\\+-]\\)\\([ \t]+\\)")
    (match-string-no-properties 0))
   ;; No match
   (t nil)))

;; Paragraph filling in text-mode.
(add-hook 'solidity-mode-hook
  (lambda ()
    (set (make-local-variable 'paragraph-start)
         "\f\\|[ \t]*$\\|[ \t]*[*+-] \\|[ \t]*[0-9]+\\.[ \t]\\|[ \t]*: ")
    (set (make-local-variable 'paragraph-separate)
         "\\(?:[ \t\f]*\\|.*  \\)$")
    (set (make-local-variable 'adaptive-fill-first-line-regexp)
         "\\`[ \t]*>[ \t]*?\\'")
    (set (make-local-variable 'adaptive-fill-function)
         'my-adaptive-fill-function)))

(defun marker-is-point-p (marker)
  "test if marker is current point"
  (and (eq (marker-buffer marker) (current-buffer))
       (= (marker-position marker) (point))))

(defun push-mark-maybe ()
  "push mark onto `global-mark-ring' if mark head or tail is not current location"
  (if (not global-mark-ring) (error "global-mark-ring empty")
    (unless (or (marker-is-point-p (car global-mark-ring))
                (marker-is-point-p (car (reverse global-mark-ring))))
      (push-mark))))

(remove-hook 'flymake-diagnostic-functions 'flymake-proc-legacy-flymake)

(define-derived-mode my-cfg-mode sh-mode "My CFg Mode"
  "A mode for my CFg files."
  (sh-set-shell "bash"))

(add-to-list 'auto-mode-alist '("requirements\\.cfg'" . my-cfg-mode))

(define-error 'flycheck-ert-suspicious-checker "")
(defvar no-flyspell-list '("requirements.txt" ".help.md" "TODO" "\\.html$"))
(defun turn-off-flyspell-if-match ()
  (if (member (file-name-nondirectory (buffer-file-name)) no-flyspell-list)
      (flyspell-mode -1)))

(add-hook 'find-file-hook #'turn-off-flyspell-if-match)
(add-hook `yaml-mode-hook (lambda () (flyspell-mode -1)))

;  disable auto-save message--------------------------
(defadvice do-auto-save (before no-message activate)
  (ad-set-arg 0 t))

(setq inhibit-startup-echo-area-message nil)
; -----------------------------------------------------
(show-paren-mode 1)
(setq show-paren-delay 0)
(setq show-paren-style 'parenthesis)

(defadvice show-paren-function
  (around show-paren-closing-before
          activate compile)
  (if (eq (syntax-class (syntax-after (point))) 5)
      (save-excursion
        (forward-char)
        ad-do-it)
    ad-do-it))

(require 'paren)
(setq show-paren-style 'parenthesis)
; (blink-matching-paren t)

;; (set-face-background 'show-paren-match (face-background 'default))
    ;; (set-face-foreground 'show-paren-match "#def")

(require 'org)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)
(add-hook 'org-mode-hook (lambda ()
                           (local-set-key (kbd "C-c s") 'org-show-subtree)))

(add-to-list 'auto-mode-alist '("TODO_archive\\'" . org-mode))
(add-to-list 'auto-mode-alist '("TODO\\'" . org-mode))
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))

;; (defface hl-todo-TODO
;  '((t :background "#f1fa8c" :foreground "#282a36" :weight bold :inherit (hl-todo)))
;  "Face for highlighting the HOLD keyword.")

;; (defadvice bookmark-jump (after bookmark-jump activate)
;;   (let ((latest (bookmark-get-bookmark bookmark)))
;;     (setq bookmark-alist (delq latest bookmark-alist))
;;     (add-to-list 'bookmark-alist latest)))

;;html
(add-to-list 'auto-mode-alist '("\\.css$" . html-mode))
(add-to-list 'auto-mode-alist '("\\.cfm$" . html-mode))

(defun _f ()  ;; insers f"{}" and move cursor two char left
  (interactive)
  (insert "f\"{}\"")
  (backward-char)
  (backward-char))

(defun break-point ()
  (interactive)
  (insert "breakpoint\(\)  \# DEBUG"))

(defun _python ()
  (interactive)
  (insert "\#\!\/usr\/bin\/env python3"))

(defun python_main ()
  (interactive)
  (insert "if \_\_name\_\_ \=\= \"\_\_main\_\_\"\:"))

(defun doc-doc ()
  (interactive)
  (insert "\"\"\"\"\"\"")
  (backward-char)
  (backward-char)
  (backward-char))


(define-skeleton hello-world-skeleton
 "Write a greeting"
  "Type name of argument: "
  "f\"{" str "}\"")

;; https://magit.vc/manual/magit/Resolving-Conflicts.html
(remove-hook 'flymake-diagnostic-functions 'flymake-proc-legacy-flymake)
;;==================================
;; https://stackoverflow.com/questions/683425/globally-override-key-binding-in-emacs
(defun my-minibuffer-setup-hook ()
  (my-keys-minor-mode 0))

(add-hook 'minibuffer-setup-hook 'my-minibuffer-setup-hook)

(global-set-key (kbd "M-?") 'help-command)

; (global-set-key (kbd "<M-tab>") 'next-buffer)
;  (global-set-key (kbd "C-c p") 'flycheck-prev-error)
;; (global-set-key "\C-]" 'suspend-frame);
;; (global-set-key "\M-j" 'suspend-frame);
;;; (global-set-key (kbd "C-?") 'help-command)
;; (global-set-key [(control q)] 'forward-word)
;; (define-key map (kbd "C-c C-j") 'suspend-frame)

(defun terminal-init-screen ()
  "Terminal initialization function for screen."
   ;; Use the xterm color initialization code.
   (xterm-register-default-colors)
   (tty-set-up-initial-frame-faces))

(defun suspend-frame-alper () (interactive)
       (save-all)
       ;; (recentf-save-list)
       (suspend-frame))

(defun shift-text (distance)
  (if (use-region-p)
      (let ((mark (mark)))
        (save-excursion
          (indent-rigidly (region-beginning)
                          (region-end)
                          distance)
          (push-mark mark t t)
          (setq deactivate-mark nil)))
    (indent-rigidly (line-beginning-position)
                    (line-end-position)
                    - distance)))

(defun shift-right (count)
  (interactive "p")
  (shift-text 4))

(defun shift-left (count)
  (interactive "p")
  (shift-text (- 4)))

(global-set-key (kbd "C-x DEL") 'mark-whole-buffer)
(global-set-key (kbd "C-x C-l") 'recenter)

(bind-key* "C-c C-c" 'run_me)
;; (bind-key* "C-c C-t" 'nil)

;; (define-key elpy-mode-map (kbd "C-c C-t") nil)
(define-key python-mode-map (kbd "C-c C-t") nil)

(defun insert-todo ()
  (interactive "*")
  (insert comment-start "TODO: "))

(defun insert-seperator-lines ()
  (interactive "*")
  (insert comment-start "--------------------------------------------------------------------------------")
  (move-beginning-of-line 1))

(defun insert-seperator ()
  (interactive "*")
  (insert comment-start "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-")
  ;; (next-line)
  (move-beginning-of-line 1))

(defun org-insert-todo ()
  (interactive "*")
  (insert "** TODO "))

;; GLOBAL OVERWRITES
(defvar my-keys-minor-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-x DEL") 'mark-whole-buffer)
    ;; (define-key map (kbd "C-M-i") 'next-buffer)
    (define-key map (kbd "C-M-i") 'suspend-frame-alper)
    (define-key map (kbd "M-n")   'suspend-frame-alper)
    (define-key map (kbd "M-r") 'restart-emacs)
    (define-key map (kbd "M-1") '_f)
    (define-key map (kbd "M-2") 'doc-doc)
    (define-key map (kbd "M-3") '_python)
    (define-key map (kbd "M-4") 'python_main)
    (define-key map (kbd "M-DEL") 'backward-delete-word)
    (define-key map (kbd "M-h") 'backward-delete-word)
    (define-key map (kbd "C-c C-m") 'flycheck-or-norm-next-error)
    (define-key map (kbd "C-l") 'backward-word)
    (define-key map (kbd "C-q") 'forward-word)
    (define-key map (kbd "C-c C-j") 'magit-status) ;; my-magit-status
    (define-key map (kbd "C-c DEL") 'help)
    (define-key map (kbd "C-c C-b") 'break-point)
    (define-key map (kbd "C-c b") 'break-point)
    (define-key map (kbd "C-c C-r") 'helm-mini)
    (define-key map (kbd "C-c C-l") 'magit-log-buffer-file)
    (define-key map (kbd "C-c n") 'next-conflict)
    (define-key map (kbd "C-c C-n") 'next-conflict)
    (define-key map (kbd "C-c C-e") 'run_me)
    (define-key map (kbd "C-c C-f") 'counsel-recentf)
    (define-key map (kbd "C-c f") 'counsel-recentf)
    (define-key map (kbd "C-c v") smerge-basic-map)
    (define-key map (kbd "C-c C-v") smerge-basic-map)
    (define-key map (kbd "C-c C-o") 'my-find-file)
    (define-key map (kbd "C-c C-t") 'insert-todo)
    (define-key map (kbd "C-c C-u") 'insert-seperator)
    (define-key map (kbd "C-c ;") 'comment-dwim-line)
    (define-key map (kbd "\C-o") 'my-counsel-git-grep)
    (define-key map (kbd "C-c C-v n") 'next-conflict)
    (define-key map (kbd "C-x j") 'org-journal-new-entry)
    (define-key map (kbd "<tab>") 'indent-for-tab-command)
    ;; (define-key map (kbd "C-c C-t") 'nil)
    ;; (define-key map (kbd "C-c C-p") 'flycheck-or-norm-previous-error)
    ;; (global-set-key "\C-c\C-f" 'counsel-recentf)
    ;; (define-key map (kbd "C-c C-e") 'shell-command)
    ;; (define-key map (kbd "C-c h") 'help)
    map)
  "my-keys-minor-mode keymap.")

(define-minor-mode my-keys-minor-mode
  "A minor mode so that my key settings override annoying major modes."
  :init-value t
  :lighter " my-keys")

(global-set-key (kbd "C-c l") 'magit-log-buffer-file)

(require 'ibuf-ext)
(add-to-list 'ibuffer-never-show-predicates "__init__.py")
(variable-pitch-mode t)
(setq 1on1-minibuffer-frame-font
      "-*-Lucida Console-normal-r-*-*-14-112-96-96-c-*-iso8859-1")

;; md format ======================================
;add the path where all the user modules will be located
(add-to-list 'load-path "~/.emacs.d/markdown-mode")

(autoload 'markdown-mode "markdown-mode.el"
  "Major mode for editing Markdown files" t)

(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

(add-to-list 'auto-mode-alist
             '("/\\.git/COMMIT_EDITMSG\\'" . markdown-mode))

(add-to-list 'auto-mode-alist
             '("/\\.git/commit-msg\\'" . markdown-mode))

(add-to-list 'auto-mode-alist
             '("/emacs\\'" . lisp-mode))

(defun terminal-init-screen ()
  "Terminal initialization function for screen."
   ;; Use the xterm color initialization code.
   (xterm-register-default-colors)
   (tty-set-up-initial-frame-faces))

(setq xterm-extra-capabilities nil)
(setq git-commit-major-mode 'markdown-mode)

(defadvice py-execute-buffer (after advice-delete-output-window activate)
  (delete-windows-on "*Python Output*"))

(setq python-shell-interpreter "python3"
      python-shell-interpreter-args "-i")

(require 'python)
(defun mark-whole-word (&optional arg allow-extend)
  (interactive "P\np")
  (let ((num  (prefix-numeric-value arg)))
    (unless (eq last-command this-command)
      (if (natnump num)
          (skip-syntax-forward "\\s-")
        (skip-syntax-backward "\\s-")))
    (unless (or (eq last-command this-command)
                (if (natnump num)
                    (looking-at "\\b")
                  (looking-back "\\b")))
      (if (natnump num)
          (left-word)
        (right-word)))
    (mark-word arg allow-extend)))

(global-set-key "\C-x\C-w" 'mark-whole-word)

(setq python-font-lock-keywords
      (append python-font-lock-keywords
          '(;; this is the full string.
        ;; group 1 is the quote type and a closing quote is matched
        ;; group 2 is the string part
        ("f\\(['\"]\\{1,3\\}\\)\\(.+?\\)\\1"
         ;; these are the {keywords}
         ("{[^}]*?}"
          ;; Pre-match form
          (progn (goto-char (match-beginning 0)) (match-end 0))
          ;; Post-match form
          (goto-char (match-end 0))
          ;; face for this match
          (0 font-lock-variable-name-face t))))))


(setq compilation-ask-about-save nil)
(setq compilation-save-buffers-predicate '(lambda () nil))

(defvar python--pdb-breakpoint-string "import pdb; pdb.set_trace() ## DEBUG ##"
  "Python breakpoint string used by `python-insert-breakpoint'")

(defadvice compile (before ad-compile-smart activate)
  "Advises `compile' so it sets the argument COMINT to t
if breakpoints are present in `python-mode' files"
  (when (derived-mode-p major-mode 'python-mode)
    (save-excursion
      (save-match-data
        (goto-char (point-min))
        (if (re-search-forward (concat "^\\s-*" python--pdb-breakpoint-string "$")
                               (point-max) t)
            ;; set COMINT argument to `t'.
            (ad-set-arg 1 t))))))

(require 'man)
;; man
(setenv "MANWIDTH" "165")
;; (setenv "MANWIDTH" "120")

(defadvice man (before my-woman-prompt activate)
      (interactive (progn
                     (require 'woman)
                     (list (woman-file-name nil)))))

;; https://emacs.stackexchange.com/a/28925/18414
(set-face-attribute 'Man-overstrike nil :inherit font-lock-type-face :bold t)
(set-face-attribute 'Man-underline nil :inherit font-lock-keyword-face :underline t)

(require 'woman)
(set-face-attribute 'woman-bold nil :inherit font-lock-type-face :bold t)
(set-face-attribute 'woman-italic nil :inherit font-lock-keyword-face :underline t)

(defun my-magit-status ()
  "Don't split window."
  (interactive)
  (setq split-height-threshold nil)
  (setq split-width-threshold 0)
  (call-interactively 'magit-status))

;; ---------------------------------------
(setq TeX-PDF-mode t)
(setq TeX-command-force "LaTeX")
(setq TeX-clean-confirm t)
(setq doc-view-resolution 600)
;; (setq TeX-save-query nil)

(defun my-find-file ()
  (interactive)
  (find-file "~/ebloc-broker/TODO"))


(defun my-run-latex ()
  (interactive)
  (save-all)
  (setq TeX-command-force "LaTeX")
  (setq TeX-clean-confirm t)
  (TeX-command-master))

(add-hook 'LaTeX-mode-hook (lambda ()
                 (local-set-key (kbd "C-x C-s") 'my-run-latex)))

(add-hook 'LaTeX-mode-hook (lambda ()
                 (local-set-key (kbd "C-c C-c") 'my-run-latex)))

(add-hook 'LaTeX-mode-hook (lambda ()
                 (local-set-key (kbd "C-c C-u") 'TeX-recenter-output-buffer)))

;; (define-key helm-map (kbd "C-p") 'helm-previous-line) ;; TODO
;; (add-hook 'LaTeX-mode-hook (lambda ()
;;                  (local-set-key (kbd "C-c a") 'TeX-command-run-all)))

;; Original idea from
;; http://www.opensubscriber.com/message/emacs-devel@gnu.org/10971693.html
(defun comment-dwim-line (&optional arg)
  "Replacement for the comment-dwim command.
        If no region is selected and current line is not blank and we are not at the end of the line,
        then comment current line.
        Replaces default behaviour of comment-dwim, when it inserts comment at the end of the line."
  (interactive "*P")
  (comment-normalize-vars)
  (if (and (not (region-active-p)) (not (looking-at "[ \t]*$")))
      (comment-or-uncomment-region (line-beginning-position) (line-end-position))
    (comment-dwim arg)))

(global-set-key (kbd "C-c C-;") 'comment-dwim-line)
(global-set-key (kbd "C-c ;") 'comment-dwim-line)

;; Don't ask for confirmation to delete marked buffers
(setq ibuffer-expert t)

;; C-h m to find all the things you can do in Man-mode
(define-key Man-mode-map "q" 'save-buffers-kill-terminal)
(define-key Man-mode-map "Q" 'save-buffers-kill-terminal)

;; maple: https://github.com/honmaple/emacs-maple-minibuffer

(require 'ansi-color)
(defun colorize-compilation-buffer ()
  (toggle-read-only)
  (ansi-color-apply-on-region (point-min) (point-max))
  (toggle-read-only))
(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on) ;;

; (setq helm-split-window-default-side 'left)
;; (setq
;   split-width-threshold 0
;   split-height-threshold nil)

(global-set-key (kbd "C-M-/") 'my-expand-file-name-at-point)
(defun my-expand-file-name-at-point ()
  "Use hippie-expand to expand the filename"
  (interactive)
  (let ((hippie-expand-try-functions-list '(try-complete-file-name-partially try-complete-file-name)))
    (call-interactively 'hippie-expand)))

(setq ido-use-virtual-buffers t)

(defun undo-tree-and-diff ()
  (interactive)
  ;; (setq split-height-threshold nil) ;; vertical both required
  ;; (setq split-width-threshold 0)    ;; vertical
  ;; (undo-tree-visualizer-toggle-diff) ;; d close toggle-diff SLOW !!
  (undo-tree-visualize))

(global-set-key "\C-x\C-v" 'undo-tree-and-diff)

(defun really-kill-emacs ()
  "Like `kill-emacs', but ignores `kill-emacs-hook'."
  (interactive)
  (let (kill-emacs-hook)
    (kill-emacs)))

;; (defun brutally-kill-emacs ()
;;   "Use `call-process' to send ourselves a KILL signal."
;;   (interactive)
;;   (call-process "kill" nil nil nil "-9" (number-to-string (emacs-pid))))

;; (defun load-ropemacs()
;;   (interactive)
;;   (require 'pymacs)
;;   (setq pymacs-load-path '(
;;                "~/.local/lib/python3.7/site-packages"
;;                "~/.local/lib/python2.7/site-packages"
;;                )
;;     )
;;   (pymacs-load "ropemacs" "rope-")
;;   )
;; (global-set-key "\C-xpl" 'load-ropemacs)

(setq ring-bell-function 'ignore)

(setq inhibit-startup-message t)
(menu-bar-mode -1)
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))

(add-to-list 'display-buffer-alist
             `(,(rx bos "*Flycheck errors*" eos)
              (display-buffer-reuse-window
               display-buffer-in-side-window)
              (side            . bottom)
              (reusable-frames . visible)
              (window-height   . 0.33)))

(setq flycheck-check-syntax-automatically '(save mode-enable))

; https://emacs.stackexchange.com/questions/3458/how-to-switch-between-windows-quickly/3460?noredirect=1#comment93764_3460
;; ============================= ;; icicle-buffer
(diminish 'abbrev-mode)
(diminish 'anzu-mode)
(diminish 'highlight-parentheses-mode)
(diminish 'subword-mode)
(diminish 'beginend-global-mode)
(diminish 'beginend-prog-mode)
(diminish 'rainbow-mode)
(diminish 'modalka-mode)
(diminish 'flycheck-mode)
(diminish 'highlight-parentheses-mode)
;; (diminish 'yas-minor-mode)

(setq TeX-auto-save t)
(setq TeX-parse-self t)

;; (define-key ido-file-completion-map "\C-o" 'nil)

(require 'beginend)
(beginend-global-mode 1)

(global-set-key "\C-x\ ," 'beginning-of-buffer)
(global-set-key (kbd "C-x C-,") 'beginning-of-buffer)

;; (electric-indent-mode 1)
;; (electric-indent-local-mode)
; (electric-indent-mode 1)
(global-set-key (kbd "RET") 'newline-and-indent)
(electric-indent-mode +1)

(defvar untabify-this-buffer)
(defun untabify-all ()
  "Untabify the current buffer, unless `untabify-this-buffer' is nil."
  (and untabify-this-buffer (untabify (point-min) (point-max))))
(define-minor-mode untabify-mode
  "Untabify buffer on save." nil " untab" nil
  (make-variable-buffer-local 'untabify-this-buffer)
  (setq untabify-this-buffer (not (derived-mode-p 'makefile-mode)))
  (add-hook 'before-save-hook #'untabify-all))
(add-hook 'prog-mode-hook 'untabify-mode)

(add-to-list 'display-buffer-alist
             '("*Help*" display-buffer-same-window))

(defun my-org-archive-done-tasks ()
  (interactive)
  (org-map-entries 'org-archive-subtree "/DONE" 'file))

;; Better unique buffer names for files with the same base name.
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

(setq read-process-output-max (* 1024 1024)) ; 1mb.
(defvar async-undo-tree-save-history-cached-load-path
  (file-name-directory (locate-library "undo-tree")))

(defun async-undo-tree-save-history ()
  (interactive)
  (let ((file-name (buffer-file-name)))
    (async-start
     `(lambda ()
        (if (stringp ,file-name)
            (list 'ok
                  (list :output (with-output-to-string
                                  (add-to-list
                                   'load-path
                                   ,async-undo-tree-save-history-cached-load-path)
                                  (require 'undo-tree)
                                  (find-file ,file-name)
                                  (undo-tree-save-history-from-hook))
                        :messages (with-current-buffer "*Messages*"
                                    (buffer-string))))
          (list 'err
                (list :output "File name must be string"
                      :messages (with-current-buffer "*Messages*"
                                  (buffer-string))))))
     `(lambda (result)
        (let ((outcome (car result))
              (messages (plist-get (cadr result) :messages))
              (output (plist-get (cadr result) :output))
              (inhibit-message t))
          (message
           (cond
            ((eq 'ok outcome)
             "undo-tree history saved asynchronously for %s%s%s")
            ((eq 'err outcome)
             "error saving undo-tree history asynchronously for %s%s%s")
            (:else
             "unexpected result from asynchronous undo-tree history save %s%s%s"))
           ,file-name
           (if (string= "" output)
               ""
             (format "\noutput:\n%s" output))
           (if (string= "" messages)
               ""
             (format "\nmessages:\n%s" messages))))))
    nil))

;; Hooks added to `write-file-functions' need to return non-nil so that the file
;; is written.

(with-eval-after-load "undo-tree"
  (remove-hook 'write-file-functions #'undo-tree-save-history-from-hook)
  (add-hook 'after-save-hook #'async-undo-tree-save-history))

(setq auto-window-vscroll nil)
(gcmh-mode 1)

;; scroll ----------------------
(setq fast-but-imprecise-scrolling 't)
(setq jit-lock-defer-time 0)
(setq max-lisp-eval-depth 10000)
;; -------------------------------

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(eshell-output-filter-functions
   (quote
    (eshell-handle-ansi-color eshell-handle-control-codes eshell-watch-for-password-prompt eshell-truncate-buffer)))
 '(fill-column 80)
 '(flycheck-disabled-checkers (quote (emacs-lisp-checkdoc clojure-cider-typed txt)))
 '(flycheck-python-flake8-executable "python3")
 '(flycheck-python-pycompile-executable "python3")
 '(flycheck-python-pylint-executable "python3")
 '(global-undo-tree-mode t)
 '(ibuffer-use-other-window nil)
 '(icicle-modal-cycle-down-action-keys (quote ([(control mouse-5)])))
 '(icicle-modal-cycle-down-keys (quote ([(control 110)] [down] [nil mouse-5] [mouse-5])))
 '(icicle-modal-cycle-up-action-keys (quote ([(control mouse-4)])))
 '(icicle-modal-cycle-up-help-keys
   (quote
    ([C-M-up]
     [C-M-up]
     [nil
      (control meta mouse-4)]
     [(control meta mouse-4)])))
 '(icicle-modal-cycle-up-keys (quote ([up] [(control 112)] [nil mouse-4] [mouse-4])))
 '(magit-display-buffer-function (quote magit-display-buffer-traditional))
 '(package-selected-packages
   (quote
    (helm-ag languagetool org-journal eglot
 dumb-jump ag powershell sound-wav company-dict go-mode
 pine-script-mode easy-kill company-quickhelp-terminal
 company-quickhelp exec-path-from-shell company-box shell-command
 shell-command+ el-get treemacs magit magit-delta markdown-mode
 helm-swoop shackle gcmh findr auto-indent-mode vi-tilde-fringe
 smex which-key-posframe goto-last-change ## fzf
 flycheck-pycheckers help-find-org-mode importmagic
 ipython-shell-send xclip simpleclip use-package-hydra yaml-mode
 dired-ranger ranger nswbuff helm-flyspell dotenv-mode pyenv-mode
 json-mode auctex flymake-solidity company-solidity
 ace-window popwin helm rope-read-mode projectile hl-todo
 hippie-expand-slime iedit wgrep flycheck-mypy blacken evil
 solidity-flycheck solidity-mode use-package flycheck
 undo-tree))) '(select-enable-clipboard t) '(tab-stop-list nil)
 '(undo-tree-auto-save-history t) '(undo-tree-visualizer-diff
 nil) '(xref-after-jump-hook (quote (recenter)))
 '(xref-after-return-hook nil))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (no-littering yaml-mode xclip
    which-key-posframe vim-empty-lines-mode vi-tilde-fringe
    use-package undo-tree treemacs sound-wav solidity-flycheck
    smooth-scrolling smex shell-command shell-command+ shackle
    selectrum realgud pyvenv py-isort projectile-git-autofetch
    powershell pine-script-mode org-journal magit-delta lsp-ui
    languagetool hl-todo highlight-indentation helm-swoop
    helm-projectile helm-flyspell helm-flycheck
    helm-dired-recent-dirs helm-ag goto-last-change go-mode
    gnu-elpa-keyring-update gcmh flymake-solidity
    flycheck-pycheckers flycheck-mypy flx findr
    exec-path-from-shell el-get eglot easy-kill dumb-jump
    dotenv-mode diminish counsel company-quickhelp-terminal
    company-dict company-box beginend
    auto-indent-mode auto-complete auctex ag))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(defun my/advice-compilation-filter (f proc string)
  (funcall f proc (xterm-color-filter string)))

(advice-add 'compilation-filter :around #'my/advice-compilation-filter)

(setq shackle-rules '(("\\`\\*helm.*?\\*\\'" :regexp t :align t :ratio 0.4)))
(setq helm-split-window-default-side 'below)
;; --------------------------------------------------------------------------------------------
;; https://emacs.stackexchange.com/a/17694/18414
(setq my-skippable-buffer-regexp
      (rx
      bos (or (or "*Messages*" "*scratch*" "*Help*" "__init__.py" "*Ibuffer*" "magit*" "*Flymake
      log*" "*helm mini*")
                  (seq "helm" (zero-or-more anything)))
          eos))

(defun my-change-buffer (change-buffer)
  "Call CHANGE-BUFFER until `my-skippable-buffer-regexp' doesn't match."
  (let ((initial (current-buffer)))
    (funcall change-buffer)
    (let ((first-change (current-buffer)))
      (catch 'loop
        (while (string-match-p my-skippable-buffer-regexp (buffer-name))
          (funcall change-buffer)
          (when (eq (current-buffer) first-change)
            (switch-to-buffer initial)
            (throw 'loop t)))))))

(defun my-next-buffer ()
  "Variant of `next-buffer' that skips `my-skippable-buffer-regexp'."
  (interactive)
  (my-change-buffer 'next-buffer))

(defun my-previous-buffer ()
  "Variant of `previous-buffer' that skips `my-skippable-buffer-regexp'."
  (interactive)
  (my-change-buffer 'previous-buffer))

(global-set-key [remap next-buffer] 'my-next-buffer)
(global-set-key [remap previous-buffer] 'my-previous-buffer)

(defadvice save-buffers-kill-emacs (around no-query-kill-emacs activate)
  "Prevent annoying \"Active processes exist\" query when you quit Emacs."
  (cl-letf (((symbol-function #'process-list) (lambda ())))
    ad-do-it))

(defun my-kill-emacs ()
  "save some buffers, then exit unconditionally"
  (interactive)
  (my-save-all)
  ;; (save-some-buffers nil t)
  (save-buffers-kill-terminal))

(global-set-key (kbd "C-x C-c") 'my-kill-emacs)

(defvar --backup-directory (concat user-emacs-directory "backups_alper"))
(if (not (file-exists-p --backup-directory))
    (make-directory --backup-directory t))

(setq backup-directory-alist `(("." . ,--backup-directory)))
(setq backup-by-copying t               ; don't clobber symlinks
      version-control t                 ; version numbers for backup files
      delete-old-versions t             ; delete excess backup files silently
      delete-by-moving-to-trash t
      kept-old-versions 6               ; oldest versions to keep when a new numbered backup is made (default: 2)
      kept-new-versions 9               ; newest versions to keep when a new numbered backup is made (default: 2)
      auto-save-default t               ; auto-save every buffer that visits a file
      auto-save-timeout 20              ; number of seconds idle time before auto-save (default: 30)
      auto-save-interval 200            ; number of keystrokes between auto-saves (default: 300)
      )

(setq create-lockfiles nil)

(setq version-control t     ;; Use version numbers for backups.
      kept-new-versions 10  ;; Number of newest versions to keep.
      kept-old-versions 10  ;; Number of oldest versions to keep.
      delete-old-versions t ;; Don't ask to delete excess backup versions.
      backup-by-copying t)  ;; Copy all files, don't rename them.

(add-to-list 'term-file-aliases
             '("st-256color" . "xterm-256color"))

(defun git-log-file ()
  "Display a log of changes to the marked file(s)."
  (interactive)
  (let* ((files (git-marked-files))
         (buffer (apply #'git-run-command-buffer "*git-log*" "git-rev-list" \
"--pretty" "HEAD" "--" (git-get-filenames files))))  (with-current-buffer buffer
      ; (git-log-mode)  FIXME: implement log mode
      (goto-char (point-min))
      (setq buffer-read-only t))
  (display-buffer buffer)))

;; an emacs 24.4 macro. You know what to do if you have 24.3
(with-eval-after-load 'helm
  ;; make sure you have flx installed
  (require 'flx)
  ;; this is a bit hackish, ATM, redefining functions I don't own
  (defvar helm-flx-cache (flx-make-string-cache #'flx-get-heatmap-str))

  (defun helm-score-candidate-for-pattern (candidate pattern)
    (or (car (flx-score candidate pattern helm-flx-cache)) 0))

  (defun helm-fuzzy-default-highlight-match (candidate)
    (let* ((pair (and (consp candidate) candidate))
            (display (if pair (car pair) candidate))
            (real (cdr pair)))
      (with-temp-buffer
        (insert display)
        (goto-char (point-min))
        (if (string-match-p " " helm-pattern)
          (cl-loop with pattern = (split-string helm-pattern)
            for p in pattern
            do (when (search-forward p nil t)
                 (add-text-properties
                   (match-beginning 0) (match-end 0) '(face helm-match))))
          (cl-loop with pattern = (cdr (flx-score display
                                         helm-pattern helm-flx-cache))
            for index in pattern
            do (add-text-properties
                 (1+ index) (+ 2 index) '(face helm-match))))
        (setq display (buffer-string)))
      (if real (cons display real) display))))

;; (global-set-key (kbd "<f7>") (kbd "C-u C-c C-c"))
(delete-file "~/Library/Colors/Emacs.clr")
(defun xah-save-all-unsaved ()
  "Save all unsaved files. no ask.
Version 2019-11-05"
  (interactive)
  (save-some-buffers t ))

(if (version< emacs-version "27")
    (add-hook 'focus-out-hook 'xah-save-all-unsaved)
  (setq after-focus-change-function 'xah-save-all-unsaved))

;; magit-diff-buffer-file
;; counsel-recentf
;; counsel-buffer-or-recentf

(defun python-fn (code)
  (let* ((temporary-file-directory ".")
         (tmpfile (make-temp-file "py-" nil ".py")))
    (with-temp-file tmpfile
      (insert code))
    (car (split-string (shell-command-to-string (format "python %s" tmpfile)) "\n$"))))

(defun colorize-compilation-buffer ()
  (toggle-read-only)
  (ansi-color-apply-on-region (point-min) (point-max))
  (toggle-read-only))
(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)

(add-hook 'shell-mode-hook (lambda () (goto-address-mode )))

(setenv "ESHELL" (expand-file-name "~/.emacs_config/scripts/eshell"))
(require 'exec-path-from-shell) ;; if not using the ELPA package

(require 'eshell)
(require 'em-smart)
(setq eshell-where-to-jump 'begin)
(setq eshell-review-quick-commands nil)
(setq eshell-smart-space-goes-to-end t)

; (add-hook 'shell-mode-hook 'company-mode)
; (define-key shell-mode-map (kbd "TAB") 'company-manual-begin))

(exec-path-from-shell-initialize)

(use-package xterm-color
  :config
  (setq comint-output-filter-functions
        (remove 'ansi-color-process-output comint-output-filter-functions))

  (add-hook 'shell-mode-hook
            (lambda () (add-hook 'comint-preoutput-filter-functions
                                 'xterm-color-filter nil t))))
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

(defun display-ansi-colors ()
  (interactive)
  (ansi-color-apply-on-region (point-min) (point-max)))

(defun display-ansi-colors ()
  (interactive)
  (let ((inhibit-read-only t))
    (ansi-color-apply-on-region (point-min) (point-max))))

(require 'ansi-color) ; for `ansi-color-apply-on-region'
(require 'subr-x)     ; for `string-trim-right'

(defun your-eshell-command (command)
  "Execute eshell COMMAND and display output in the echo area."
  (interactive (list (read-shell-command "Eshell command: ")))
  (message "%s" (string-trim-right (eshell-command-result command))))

(defun run_me ()
  (interactive)  ;; https://emacs.stackexchange.com/a/61667/18414
  (your-shell-command (format "%s" buffer-file-name)))


(defun your-ansi-color-apply (s)
  "Like `ansi-color-apply' but use `face' instead of `font-lock-face'."
  (with-temp-buffer
    (insert s)
    (let ((ansi-color-apply-face-function
           (lambda (beg end face)
             (when face
               (put-text-property beg end 'face face)))))
      (ansi-color-apply-on-region (point-min) (point-max)))
    (buffer-string)))

(defun your-shell-command (command)
  "A simplified `shell-command' to support color."
  (interactive (list (read-shell-command "Shell command: ")))
  (message "%s"
           (string-trim-right
            (your-ansi-color-apply
             (shell-command-to-string command)))))

(company-quickhelp-mode)
(eval-after-load 'company
  '(define-key company-active-map (kbd "C-c m") #'company-quickhelp-manual-begin))

(projectile-mode +1)
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c C-g") 'counsel-git)
(global-set-key (kbd "\C-o") 'counsel-git-grep)

;; auto revert mode
(global-auto-revert-mode 1)
(setq auto-revert-use-notify nil)

;; auto refresh dired when file changes
(add-hook 'dired-mode-hook 'auto-revert-mode)

(defun my-revert-buffer-noconfirm ()
  "Call `revert-buffer' with the NOCONFIRM argument set."
  (interactive)
  (revert-buffer nil t))

;; Source: http://www.emacswiki.org/emacs-en/download/misc-cmds.el
(defun revert-buffer-no-confirm ()
    "Revert buffer without confirmation."
    (interactive)
    (revert-buffer :ignore-auto :noconfirm))

(setq counsel-git-grep-cmd-default "git --no-pager grep -F -n --no-color -I -e \"%s\"")

(defun connect-remote ()
  (interactive)
  (dired "/alper@192.168.1.:/"))

;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
;; (defun italic-word ()
;;  (interactive)
;;  (easy-mark) (TeX-font nil 9))

;; (defun bold-word ()
;;  (interactive)
;;  (easy-mark) (TeX-font nil 2))

;; (global-set-key (kbd "\M-o i") 'italic-word)
;; (global-set-key (kbd "\M-o b") 'bold-word)
;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
(font-lock-add-keywords 'shell-mode
                        '(("alias" . font-lock-builtin-face)))

;; (add-hook 'LaTeX-mode-hook (lambda ()
;;                              (local-set-key (kbd "C-c a") 'TeX-command-run-all)
;;                              (local-set-key (kbd "C-c l") 'tex-recenter-output-buffer)
;;                              ))

;; tex-recenter-output-buffer
(setq vc-make-backup-files t)
(setq version-control t ;; Use version numbers for backups.
      kept-new-versions 10 ;; Number of newest versions to keep.
      kept-old-versions 0 ;; Number of oldest versions to keep.
      delete-old-versions t ;; Don't ask to delete excess backup versions.
      backup-by-copying t) ;; Copy all files, don't rename them.

(setq backup-directory-alist '(("" . "~/.emacs.d/backup/per-save")))

(defun force-backup-of-buffer ()
  ;; Make a special "per session" backup at the first save of each
  ;; emacs session.
  (when (not buffer-backed-up)
    ;; Override the default parameters for per-session backups.
    (let ((backup-directory-alist '(("" . "~/.emacs.d/backup/per-session")))
          (kept-new-versions 3))
      (backup-buffer)))
  ;; Make a "per save" backup on each save.  The first save results in
  ;; both a per-session and a per-save backup, to keep the numbering
  ;; of per-save backups consistent.
  (let ((buffer-backed-up nil))
    (backup-buffer)))

(add-hook 'before-save-hook  'force-backup-of-buffer)

(defun le::save-buffer-force-backup (arg)
  (interactive "P")
  (if (consp arg)
      (save-buffer)
    (save-buffer 16)))
(global-set-key [remap save-buffer] 'le::save-buffer-force-backup)

(defun markdown-flyspell-check-word-p ()
  "Return t if `flyspell' should check word just before point.
Used for `flyspell-generic-check-word-predicate'."
  (save-excursion
    (goto-char (1- (point)))
    (not (or (markdown-code-block-at-point-p)
             (markdown-inline-code-at-point-p)
             (markdown-in-comment-p)
             (let ((faces (get-text-property (point) 'face)))
               (if (listp faces)
                   (or (memq 'markdown-reference-face faces)
                       (memq 'markdown-markup-face faces)
                       (memq 'markdown-url-face faces))
                 (memq faces '(markdown-reference-face
                               markdown-markup-face
                               markdown-url-face))))))))

;; Where to look for dictionary files. Default is ~/.emacs.d/dict
(setq company-dict-dir (concat user-emacs-directory "dict/"))

;; Optional: if you want it available everywhere
(add-to-list 'company-backends 'company-dict)


;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
(setq imagemagick-enabled-types t)

(defun image-p (obj)
  "Return non-nil if OBJ is an image"
  (eq (car-safe obj) 'image))

(defun iimage-scale-to-fit-width ()
  "Scale over-sized images in the active buffer to the width of the currently selected window.
  (imagemagick must be enabled)"
  (interactive)
  (let ((max-width (window-width (selected-window) t)))
    (alter-text-property (point-min) (point-max)
                         'display
                         (lambda (prop)
                           (when (image-p prop)
                             (plist-put (cdr prop) :type 'imagemagick)
                             (plist-put (cdr prop) :max-width max-width)
                             prop)))))

(defun iimage-scale-on-window-configuration-change ()
  "Hook function for major mode that display inline images:
Adapt image size via `iimage-scale-to-fit-width' when the window size changes."
  (add-hook 'window-configuration-change-hook #'iimage-scale-to-fit-width t t))

(add-hook 'markdown-mode-hook #'iimage-scale-on-window-configuration-change)
;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
;; -----------------------------------------------------------------
;; link: https://stackoverflow.com/a/25942392/2402577
;; C-h f org-insert-todo-heading RET
;; C-h f org-insert-todo-heading-respect-content RET
(defun org-toggle-todo-and-fold ()
  (interactive)
  (save-excursion
    (org-back-to-heading t) ;; Make sure command works even if point is
                            ;; below target heading
    (cond ((looking-at "\*+ TODO")
           (org-todo "DONE")
           (hide-subtree))
          ((looking-at "\*+ DONE")
           (org-todo "TODO")
           (hide-subtree))
          (t (message "Can only toggle between TODO and DONE.")))))

(define-key org-mode-map (kbd "C-c C-d") 'org-toggle-todo-and-fold)
;; -----------------------------------------------------------------

;; from https://github.com/abo-abo/swiper/issues/1068
(defun my-ivy-with-thing-at-point (cmd &optional dir)
  "Wrap a call to CMD with setting "
  (let ((ivy-initial-inputs-alist
         (list
          (cons cmd (thing-at-point 'symbol)))))
    (funcall cmd nil dir)))

(defun my-counsel-ag-from-here (&optional dir)
  "Start ag but from the directory the file is in (otherwise I would
be using git-grep)."
  (interactive "D")
  (my-ivy-with-thing-at-point
   'counsel-ag
   (or dir (file-name-directory (buffer-file-name)))))

(defun my-counsel-git-grep ()
  (interactive)
  (save-buffer)
  (my-ivy-with-thing-at-point
   'counsel-git-grep))

;; ORG-MODE Setup ------------------------------------------------------------------------------
(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
              (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "PHONE" "MEETING"))))

(setq org-todo-keyword-faces
      (quote (("TODO" :foreground "red" :weight bold)
              ("NEXT" :foreground "blue" :weight bold)
              ("DONE" :foreground "green" :weight bold))))

(defun org-summary-todo (n-done n-not-done)
  "Switch entry to DONE when all subentries are done, to TODO otherwise."
  (let (org-log-done org-log-states)   ; turn off logging
    (org-todo (if (= n-not-done 0) "DONE" "TODO"))))

(add-hook 'org-after-todo-statistics-hook 'org-summary-todo)

(global-set-key (kbd "C-c o")
                (lambda () (interactive) (find-file "~/ebloc-broker/TODO")))

(setq org-babel-python-command "python3")
(setq org-completion-use-ido t)
'(indent-tabs-mode nil)
'(org-src-preserve-indentation nil)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)))
(setq flycheck-check-syntax-automatically '(save idle-buffer-switch idle-change new-line mode-enabled)
      flycheck-idle-buffer-switch-delay 0)

(defun org-archive-done-tasks ()
  (interactive)
  (org-map-entries
   (lambda ()
     (org-archive-subtree)
     (setq org-map-continue-from (org-element-property :begin (org-element-at-point))))
   "/+DONE" 'tree))

;; ;; TODO: if not work try https://stackoverflow.com/a/12304982/2402577
;; (defun revert-buffer-keep-undo (&rest -)
;;   "Revert buffer but keep undo history."
;;   (interactive)
;;   (let ((inhibit-read-only t))
;;     (erase-buffer)
;;     (insert-file-contents (buffer-file-name))
;;     (set-visited-file-modtime (visited-file-modtime))
;;     (set-buffer-modified-p nil)))
;; (setq revert-buffer-function 'revert-buffer-keep-undo)

(define-key prog-mode-map (kbd "C-c t")   #'insert-todo)
(define-key prog-mode-map (kbd "C-c u")   #'insert-seperator)
(define-key org-mode-map  (kbd "C-c C-t") #'org-insert-todo)
(define-key org-mode-map  (kbd "C-c t")   #'org-insert-todo)

;; ====================================================
;;https://unix.stackexchange.com/a/14935/198423
;; (global-set-key "\C-w" 'clipboard-kill-region)
;; (global-set-key "\M-w" 'clipboard-kill-ring-save)
;; (global-set-key "\C-y" 'clipboard-yank)
;; (xclip-mode 1)  ;;;;;;;; created slowness in netlab
;; ====================================================
(use-package org-journal  ;; https://github.com/bastibe/org-journal
  :ensure t
  :defer t
  :init
  ;; Change default prefix key; needs to be set before loading org-journal
  (setq org-journal-prefix-key "C-c j ")  ;; M-x org-journal-new-entry
  :config
  (setq org-journal-dir "~/org/journal/"
        org-journal-date-format "%A, %d %B %Y"))

(defun org-journal-save-entry-and-exit()
  "Simple convenience function.
  Saves the buffer of the current day's entry and kills the window
  Similar to org-capture like behavior"
  (interactive)
  (save-buffer)
  (kill-buffer-and-window))

(define-key org-journal-mode-map (kbd "C-x C-s") 'org-journal-save-entry-and-exit)

(setq lisp-indent-function 'common-lisp-indent-function)

(if (< emacs-major-version 23)
    (make-obsolete 'icicle-scatter 'icicle-scatter-re) ; 2018-01-14
  (make-obsolete 'icicle-scatter 'icicle-scatter-re "2018-01-14"))

(add-to-list 'load-path "~/.emacs.d/lisp/icicles")
(require 'icicles)
(icy-mode 1)
(add-hook 'icicles-mode-hook (lambda ()
                                (local-set-key (kbd "C-p") 'nil)))
(setq icicle-Completions-text-scale-decrease 0.00)
(setq history-length 100)
(put 'minibuffer-history 'history-length 50)
(put 'evil-ex-history 'history-length 50)
(put 'kill-ring 'history-length 25)
;; --------------------------------------------------------
(global-set-key "\C-cr" 'org-capture)
;; (setq org-default-notes-file "~/Dropbox/notes/tasks.org")
(setq org-default-notes-file "~/tasks.org")
(setq org-src-tab-acts-natively t)

;; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
(global-set-key (kbd "C-c q") 'auto-fill-mode)
;; https://emacs.stackexchange.com/a/63665/18414
;; define environments we don't want to autofill:
(defvar unfillable-envs '("figure" "tikzpicture" "table*" "tabular"))
;; add more environments if you like, eg:
;; (defvar unfillable-envs '("figure" "tikzpicture"))

;; create a function to check the environment first, then fill:
(defun my-filtered-fill ()
  (unless (member (LaTeX-current-environment) unfillable-envs)
    (do-auto-fill)))

;; setup LaTeX/AucTex to use auto-fill-mode, but with our fill-function:
(defun my-tex-auto-fill ()
  (auto-fill-mode)
  (setq auto-fill-function 'my-filtered-fill))

(add-hook 'LaTeX-mode-hook 'my-tex-auto-fill)

(defun goto-def-or-rgrep ()
  "Go to definition of thing at point or do an rgrep in project if that fails"
  (interactive)
  (condition-case nil (rope-goto-definition)
    (error (rope-goto-definition (thing-at-point 'symbol)))))

(global-set-key "\C-x\C-j" 'xref-find-definitions)
(global-set-key "\C-x\C-k" 'xref-pop-marker-stack)
(font-lock-add-keywords 'python-mode
                        '(("\\(log\\)(.*)" 1 font-lock-keyword-face)))

;; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
(defun disable-lsp-conn-msg-advice (func &rest r)
  (unless (string-prefix-p "Connected to" (car r))
    (apply func r)))

(advice-add 'lsp--info :around #'disable-lsp-conn-msg-advice)
;; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

(setq company-auto-complete t)
(global-set-key (kbd "C-c C-k") 'company-complete)

;; lsp-workspace-folders-add      ; for adding root project repo
(use-package python :ensure nil)

;; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
(defun my-set-fill-column (arg)
  "Set `fill-column' to specified argument.
Use \\[universal-argument] followed by a number to specify a column.
Just \\[universal-argument] as argument means to use the current column."
  (interactive
   (list (or current-prefix-arg
             ;; We used to use current-column silently, but C-x f is too easily
             ;; typed as a typo for C-x C-f, so we turned it into an error and
             ;; now an interactive prompt.
             (read-number "Set fill-column to: " (current-column)))))
  (if (consp arg)
      (setq arg (current-column)))
  (if (not (integerp arg))
      ;; Disallow missing argument; it's probably a typo for C-x C-f.
      (error "my-set-fill-column requires an explicit argument")
    ;; (message "Fill column set to %d (was %d)" arg fill-column) <<< COMMENT OUT THIS LINE
    (setq fill-column arg)))

(add-hook 'python-mode-hook
  (lambda ()
    (setq indent-tabs-mode  nil
          python-indent-offset  4
          tab-width         4)
    (let ((inhibit-message  t))
      (my-set-fill-column 80))))

(require 'swiper)
(ivy-mode)
(setq ivy-use-virtual-buffers t)
(setq ivy-initial-inputs-alist nil)
(setq enable-recursive-minibuffers t)

(global-set-key (kbd "M-x") 'counsel-M-x)
(use-package counsel
    :config (setq counsel-ag-base-command "ag --vimgrep -a %s"))

(progn  ;; https://github.com/abo-abo/swiper/issues/2717
  (set-face-attribute 'ivy-minibuffer-match-face-3 nil :foreground "white" :background "darkgreen")
  (set-face-attribute 'ivy-minibuffer-match-face-4 nil :foreground "white" :background "blue")
  (set-face-attribute 'swiper-match-face-2         nil :foreground "white" :background "red")
  (set-face-attribute 'swiper-match-face-3         nil :foreground "white" :background "darkgreen")
  (set-face-attribute 'swiper-match-face-4         nil :foreground "white" :background "blue"))

(savehist-mode 1) ;; ERROR in macOS
(setq server-client-instructions nil)
;; (setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(setq custom-file "~/.emacs.d/config/customize.el") (load-file custom-file)
;; https://emacs.stackexchange.com/a/64377/18414
(with-eval-after-load 'ibuf-ext
  (dolist (name '("*lsp-log*" "*pyls::stderr*" "*Disabled Command*"))
    (push (regexp-quote name) ibuffer-never-show-predicates)))

(require 'yasnippet)
(yas-global-mode 1)
(yas-reload-all)

(define-key yas-minor-mode-map [(tab)] nil);
(define-key yas-minor-mode-map (kbd "TAB") nil);
(define-key yas-minor-mode-map (kbd "C-c C-i") 'yas-expand)

(defvar yas-keymap
  (let ((map (make-sparse-keymap)))
     (define-key map (kbd "TAB")   (yas-filtered-definition 'yas-next-field-or-maybe-expand))))

;; https://github.com/jorgenschaefer/pyvenv
(require 'pyvenv)
(pyvenv-activate "~/venv/")

(defun my-custom-settings-fn ()
  (setq indent-tabs-mode nil)   ;; nil for spaces
  (setq tab-stop-list (number-sequence 2 200 2))
  (setq tab-width 4)
  (setq indent-line-function 'insert-tab))

(add-hook 'pine-script-mode-hook 'my-custom-settings-fn)

(font-lock-add-keywords nil '(("\\([\{\}\\[\]\(\)]+\\)" 1 font-lock-keyword-face prepend)))
(custom-set-faces
 '(show-paren-match ((t (:background "red" :foreground "black"))))
 '(show-paren-mismatch ((((class color)) (:background "red" :foreground "white")))))

(setq python-indent-guess-indent-offset t)
(setq python-indent-guess-indent-offset-verbose nil)

(setq python-python-command "~/venv/bin/python3")
(setq python-shell-interpreter "~/venv/bin/python3")

(defun ask-user-about-supersession-threat (fn)
  "blatantly ignore files that changed on disk"
  )
(defun ask-user-about-lock (file opponent)
  "always grab lock"
  t)
(setq revert-without-query '(".*"))

(defun smart-line-beginning ()
  "Move point to the beginning of text on the current line; if that is already
the current position of point, then move it to the beginning of the line."
  (interactive)
  (let ((pt (point)))
    (back-to-indentation)  ;; (beginning-of-line-text)
    (when (eq pt (point))
      (beginning-of-line))))

(global-set-key "\C-a" 'smart-line-beginning)

; (setq-default toggle-case-fold-search 0)  ; Turn Off Smart Case Sensitivity
(defun my-find-files ()
  (interactive)
  (message "press t to toggle mark for all files found && Press Q for Query-Replace in Files...")
  (find-dired "~/ebloc-broker" "-name \\*.py ! -name flycheck_\\*.py ! -name __init__.py"))

(global-set-key (kbd "M-z") 'my-find-files)
(global-set-key (kbd "M-d") 'nil)

(defun backward-delete-char-stop-at-read-only (n &optional killflag)
  "Do as `backward-delete-char' but stop at read-only text."
  (interactive "p\nP")
  (unless (or (get-text-property (point) 'read-only)
          (eq (point) (point-min))
          (get-text-property (1- (point)) 'read-only))
    (setq n (min (- (point) (point-min)) n))
    (setq n (- (point) (previous-single-property-change (point) 'read-only nil (- (point) n))))
    (backward-delete-char n killflag)))

(define-key minibuffer-local-map (kbd "C-h") #'backward-delete-char-stop-at-read-only)
(define-key minibuffer-local-map (kbd "C-n") #'next-line-or-history-element)
(define-key minibuffer-local-map (kbd "C-p") #'previous-line-or-history-element)
(define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)

(add-hook 'magit-mode-hook (lambda () (magit-delta-mode +1)))

(custom-set-faces
 '(diff-added ((t (:foreground "#149914" :background nil :inherit nil))))
 '(diff-removed ((t (:foreground "#991414" :background nil :inherit nil)))))

(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

(add-hook 'smerge-mode-hook `(lambda () (flycheck-mode -1)))

(global-set-key (kbd "C-x C-b") 'break-point)
(global-set-key (kbd "C-x C-u") 'ibuffer)  ;; basili tutunca boyutu buyuyor

;; https://emacs.stackexchange.com/a/18162/18414
(defun remove-extra-blank-lines ()
  "replace multiple blank lines with a single one"
  (interactive)
  (setq orig (point))
  (goto-char (point-min))
  (while (re-search-forward "\\(^\\s-*$\\)\n" nil t)
    (replace-match "\n")
    (forward-char 1))
  (goto-char orig))

(defun alper-end () (interactive)(message "End Alper"))

;; ;; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
;; ;;                                     THE_END
;; ;; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

;; /usr/share/yasnippet-snippets/python-mode
;; ~/.emacs.d/snippets

;; ;; https://github.com/marcwebbie/auto-virtualenv
;; (require 'auto-virtualenv)
;; (add-hook 'python-mode-hook 'auto-virtualenv-set-virtualenv)

;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
;; https://stackoverflow.com/a/2985357/2402577
;; ===========================================
;; C-a toggle between the beginning of the line and the beginning of the code. //https://stackoverflow.com/a/6037523/2402577
;; (defun beginning-of-line-or-indentation ()
;;   "move to beginning of line, or indentation"
;;   (interactive)
;;   (if (bolp)
;;       (back-to-indentation)
;;     (beginning-of-line)))

;; (defun clear-undo-tree ()
;;   (interactive)
;;   (setq buffer-undo-tree nil))
;; (global-set-key [(control c) u] 'clear-undo-tree)
;; (modify-all-frames-parameters '((fullscreen . maximized)))
;; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
;; (which-key-mode)
;; (which-key-setup-side-window-bottom)
;; (which-key-setup-minibuffer)
;; (setq which-key-show-early-on-C-h t)
;; (setq which-key-special-keys '("SPC" "TAB" "RET" "ESC" "DEL"))
;; (setq which-key-idle-delay 1.1)  ;; (which-key-setup-side-window-right)
