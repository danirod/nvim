(import-macros {: wk-spec!} :deezmacros)

(let [wk (require :which-key)]
  (wk.add [(wk-spec! :<C-N> :<cmd>bnext<cr> {:desc "Next buffer"})
           (wk-spec! :<C-P> :<cmd>bprev<cr> {:desc "Previous buffer"})]))
