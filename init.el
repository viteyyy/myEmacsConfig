;; Configuração básica do Emacs
(setq inhibit-startup-message t)     ; Desabilita a tela inicial do Emacs

(tool-bar-mode -1)                   ; Oculta a barra de ferramentas
(menu-bar-mode -1)                   ; Oculta a barra de menu
(scroll-bar-mode -1)                 ; Oculta a barra de rolagem
(tooltip-mode -1)                    ; Oculta dicas

(global-display-line-numbers-mode t) ; Exibe numeração de linhas
(column-number-mode t)               ; Exibe coluna atual na modeline

;; Alertas visuais
(setq visible-bell t)

;; Espaçamento das bordas laterais
(set-fringe-mode 10)

;; Largura da tabulação
(setq-default tab-width 12)

;; Inicializar o Emacs em tela cheia
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Outros
(delete-selection-mode t)            ; O texto digitado substitui a seleção

;; Rolagem mais suave
(setq mouse-wheel-scroll-amount '(2 ((shift) . 1)) ; 2 linhas por vez
      mouse-wheel-progressive-speed nil            ; Não acelera a rolagem
      mouse-wheel-follow-mouse 't                  ; Rola a janela sob o mouse
      scroll-step 1)                               ; Rola 1 linha com teclado

;; Quebras de linha
(global-visual-line-mode t)

;; Organizando os backups
(setq backup-directory-alist '(("." . "~/.saves")))

;; Fonte padrão
(set-face-attribute 'default nil :font "Monospace" :height 140)

;; Tipo de cursor
(setq-default cursor-type 'box)

;; Função para criar um novo buffer
(defun debmx-new-buffer ()
  "Cria um novo buffer 'sem nome'."
  (interactive)
  (let ((debmx/buf (generate-new-buffer "sem-nome")))
    (switch-to-buffer debmx/buf)
    (funcall initial-major-mode)
    (setq buffer-offer-save t)
    debmx/buf))

;; Modo inicial
(setq initial-major-mode 'prog-mode)
(setq initial-buffer-choice 'debmx-new-buffer)

(setq package-check-signature 'allow-unsigned)

;; Verifica e inicia o package.el
(require 'package)

;; Definição de repositórios
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/") t)

;; Inicialização do sistema de pacotes
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

; Instalação do use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(use-package try
  :ensure t)

(use-package which-key ;; ajuda nos keybindings do Emacs
  :ensure t
  :config (which-key-mode))

(use-package auto-complete ;; auto complete
  :ensure t
  :init
  (progn
    (ac-config-default)
    (global-auto-complete-mode t)))

(use-package all-the-icons
  :ensure t)
  
(use-package neotree ;; árvore de arquivos
  :ensure t
  :config
  (progn
    (setq neo-theme (if (display-graphic-p) 'icons 'arrow)))
  :bind (("M-\\" . 'neotree-toggle))) ;; Alt-\ esconde a side-bar da árvore de arquivos

(use-package ace-window  ;; Organização de janelas
  :ensure t
  :bind (("C-x o" . ace-window)))

(use-package flycheck ;; Warnings
  :ensure t
  :init (global-flycheck-mode t))

(use-package smartparens ;; Auto-complete de símbolos
  :ensure smartparens  ;; install the package
  :hook (prog-mode text-mode markdown-mode) ;; add `smartparens-mode` to these hooks
  :config
  ;; load default config
  (require 'smartparens-config))

(require 'smartparens)

;; remap electric delete functions to smartparens function
(define-key smartparens-strict-mode-map [remap c-electric-delete-forward] 'sp-delete-char)
(define-key smartparens-strict-mode-map [remap c-electric-backspace] 'sp-backward-delete-char)

(sp-with-modes sp-c-modes
  (sp-local-pair "{" nil :post-handlers '(("||\n[i]" "RET")))
  (sp-local-pair "/*" "*/" :post-handlers '(("| " "SPC")
                                            ("* ||\n[i]" "RET"))))

;; inline formulas for doxygen
(sp-with-modes sp-c-modes
  (sp-local-pair "\\f[" "\\f]" :when '(sp-in-comment-p))
  (sp-local-pair "\\f$" "\\f$" :when '(sp-in-comment-p)))

(provide 'smartparens-c)
;; smartparens-c.el ends here

;; Atalhos personalizados
(global-set-key (kbd "M-<down>") 'enlarge-window)
(global-set-key (kbd "M-<up>") 'shrink-window)
(global-set-key (kbd "M-<left>") 'enlarge-window-horizontally)
(global-set-key (kbd "M-<right>") 'shrink-window-horizontally)

;; Tema
(use-package inkpot-theme
  :ensure t
  :config
  (load-theme 'inkpot t))

;; melpa stuff
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ispell-dictionary nil)
 '(package-selected-packages
   '(smartparens flycheck inkpot-theme ace-window all-the-icons neotree auto-complete which-key try use-package gnu-elpa-keyring-update)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
