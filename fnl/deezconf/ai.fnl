(import-macros {: uses-pack! : wk-spec!} :deezmacros)

; TODO: just install and use opencode

(uses-pack! "https://github.com/carlos-algms/agentic.nvim"
            "https://github.com/github/copilot.vim")

(let [agentic (require :agentic)
      wk (require :which-key)]
  (agentic.setup {:provider :codex-acp :windows {:position :left :width "30%"}})
  (wk.add [(wk-spec! :<Leader>aa agentic.toggle {:desc "Toggle AI sidebar"})
           (wk-spec! :<Leader>ar agentic.restore_session
                     {:desc "Recall AI session"})]))
