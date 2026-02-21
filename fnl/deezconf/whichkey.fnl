(import-macros {: uses-pack! : wk-spec!} :deezmacros)

(uses-pack! "https://github.com/folke/which-key.nvim")

(let [which-key (require :which-key)]
  (which-key.setup {:preset :modern :delay 0})
  (which-key.add (wk-spec! :<leader>? which-key.show)))

(set vim.opt.timeoutlen 0)
(set vim.g.mapleader ",")
