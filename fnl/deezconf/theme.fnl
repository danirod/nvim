(import-macros {: on-filetype! : uses-pack!} :deezmacros)

(uses-pack! "https://github.com/navarasu/onedark.nvim")
(uses-pack! "https://github.com/nvim-mini/mini.icons")
(uses-pack! "https://github.com/nvim-tree/nvim-web-devicons")

;; onedark my beloved
(let [onedark (require :onedark)]
  (onedark.setup {:style :darker})
  (onedark.load))

;; custom rulers and colorcolumns for specific filetypes
(let [rulers {:gitcommit [50 72] :changelog [72]}]
  (each [pattern columns (pairs rulers)]
    (on-filetype! pattern (set vim.opt_local.colorcolumn columns))))
