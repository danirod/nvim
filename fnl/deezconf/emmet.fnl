(import-macros {: uses-pack! : wk-spec!} :deezmacros)

(uses-pack! "https://github.com/olrtg/nvim-emmet")

(let [emmet (require :nvim-emmet)
      wk (require :which-key)]
  (wk.add [(wk-spec! :<leader>xe emmet.wrap_with_abbreviation)]))
