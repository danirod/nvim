(import-macros {: uses-pack! : wk-spec!} :deezmacros)

(uses-pack! "https://github.com/folke/twilight.nvim"
            "https://github.com/folke/zen-mode.nvim")

(let [twilight (require :twilight)
      zen (require :zen-mode)
      wk (require :which-key)]
  (twilight.setup {:dimming {:alpha 0.5
                             :color [:Normal "#ffffff"]
                             :inactive true}
                   :context 10
                   :exclude []})
  (zen.setup {:window {:width 100}})
  (wk.add [(wk-spec! :<Leader>zz zen.toggle {:desc "Toggle zen mode"})
           (wk-spec! :<Leader>zt twilight.toggle {:desc "Toggle twilight"})]))
