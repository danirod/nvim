(let [lint (require :lint)
      try_lint (fn [] (lint.try_lint))]
  (set lint.linters.clangtidy.args [:--extra-arg=-Wall :--quiet]) ; So that clang languages show errors like unused variables and such.
  (set lint.linters.by_ft {:c [:clangtidy]
                           :cpp [:clangtidy]
                           :h [:clangtidy]
                           :proto [:buf_lint]
                           :markdown [:markdownlint]
                           :gitcommit [:gitlint]
                           :yaml [:yamllint]}) ; Many LSPs already lint. Only those whose LSP does not lint should be added here.
  (vim.api.nvim_create_autocmd [:BufEnter
                                :BufReadPost
                                :InsertLeave
                                :BufWritePost]
                               {:callback try_lint}))
