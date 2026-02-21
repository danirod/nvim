(import-macros {: uses-pack! : wk-spec!} :deezmacros)

(uses-pack! "https://github.com/L3MON4D3/LuaSnip")

(let [luasnip (require :luasnip)
      wk (require :which-key)]
  (wk.add [(wk-spec! :<C-L> #(luasnip.jump 1)
                     {:mode [:i :s] :silent true :desc "Next snippet point"})
           (wk-spec! :<C-K> #(luasnip.jump 0)
                     {:mode [:i :s] :silent true :desc "Current snippet point"})
           (wk-spec! :<C-J> #(luasnip.jump -1)
                     {:mode [:i :s]
                      :silent true
                      :desc "Previous snippet point"})
           (wk-spec! :<C-E>
                     #(when (luasnip.choice_active) (luasnip.change_choice 1))
                     {:mode [:i :s] :silent true :desc "Choice next snippet"})]))

(let [vscode (require :luasnip.loaders.from_vscode)]
  (vscode.lazy_load {:paths ["~/.config/nvim/snippets/"]}))
