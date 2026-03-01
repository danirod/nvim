(import-macros {: uses-pack! : wk-spec!} :deezmacros)

(uses-pack! "https://github.com/akinsho/toggleterm.nvim")

(let [toggleterm (require :toggleterm)
      wk (require :which-key)]
  (toggleterm.setup {:open_mapping "<C-\\>"})
  (wk.add [(wk-spec! :<C-h> "<cmd>wincmd h<cr>" {:mode :t})
           (wk-spec! :<C-j> "<cmd>wincmd j<cr>" {:mode :t})
           (wk-spec! :<C-k> "<cmd>wincmd k<cr>" {:mode :t})
           (wk-spec! :<C-l> "<cmd>wincmd l<cr>" {:mode :t})
           (wk-spec! :<esc> "<C-\\><C-n>" {:mode :t})]))
