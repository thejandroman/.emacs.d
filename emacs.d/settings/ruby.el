;;; ruby.el --- Summary
;;; Code:
;;; Commentary:

;; List of possible locations for rbenv
(defvar rbenv-paths)
(setq rbenv-paths
      '("/usr/local/rbenv"
        "/usr/local/bin/rbenv"))

;; Use the first rbenv path that responds as executable
(defvar rbenv-path)
(setq rbenv-path
      (cl-find 't rbenv-paths :key 'file-executable-p))

(use-package rbenv
  :ensure t
  :config
  (defvar rbenv-installation-dir)
  (setq rbenv-installation-dir rbenv-path)
  (global-rbenv-mode))

(use-package ruby-mode
  :ensure t
  :config
  (setq ruby-insert-encoding-magic-comment nil))

;; Disable reek
(setq-default flycheck-disabled-checkers
              (append flycheck-disabled-checkers
                      '(ruby-reek)))
(custom-set-variables
 '(flycheck-ruby-rubocop-executable "~/.rbenv/shims/rubocop" ))

(add-to-list 'interpreter-mode-alist
             '("shell-ruby" . ruby-mode))

;; make web-mode play nice with smartparens
(defun my-web-mode-hook ()
  (setq web-mode-enable-auto-pairing nil))

(add-hook 'web-mode-hook  'my-web-mode-hook)

(defun sp-web-mode-is-code-context (id action context)
  (and (eq action 'insert)
       (not (or (get-text-property (point) 'part-side)
                (get-text-property (point) 'block-side)))))

(sp-local-pair 'web-mode "<" nil :when '(sp-web-mode-is-code-context))

(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))

(provide 'ruby)

;;; ruby.el ends here
