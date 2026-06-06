(import-macros {: uses-pack! : api-key! : wk-spec!} :deezmacros)

(uses-pack! "https://github.com/milanglacier/minuet-ai.nvim"
            "https://github.com/nickjvandyke/opencode.nvim")

; Minuet and Deepseek AI is something like Copilot or Cursor Tab.
(let [minuet (require :minuet)
      wk (require :which-key)
      deepseek-api-key (api-key! :tokens/deepseek/minuet)
      deepseek-options {:name :deepseek
                        :model :deepseek-v4-flash
                        :api_key (fn [] deepseek-api-key)
                        :optional {:stop ["\n\n"]
                                   :thinking {:type :disabled}
                                   :max_tokens 256
                                   :top_p 0.9}}
      provider-options {:openai_fim_compatible deepseek-options}
      duet-deepseek-options {:model :deepseek-v4-flash
                             :end_point "https://api.deepseek.com/beta/completions"
                             :api_key (fn [] deepseek-api-key)
                             :optional {:thinking {:type :disabled}}}
      duet-options {:provider :openai_compatible
                    :provider_options {:openai_compatible duet-deepseek-options}}]
  (minuet.setup {:provider :openai_fim_compatible
                 :notify :debug
                 :request_timeout 4
                 :virtualtext {:auto_trigger_ft [:ruby
                                                 :javascript
                                                 :typescript
                                                 :c
                                                 :lua
                                                 :fennel]
                               :keymap {:accept :<Tab>
                                        :prev "<A-[>"
                                        :next "<A-]>"
                                        :dismiss :<A-Esc>}}
                 :provider_options provider-options
                 :duet duet-options})
  (wk.add [(wk-spec! :<A-d> "<cmd>Minuet duet predict"
                     {:mode [:i :n] :silent true :desc "Predict duet"})
           (wk-spec! :<A-a> "<cmd>Minuet duet apply"
                     {:mode [:i :n] :silent true :desc "Apply duet"})
           (wk-spec! :<A-x> "<cmd>Minuet duet dismiss"
                     {:mode [:i :n] :silent true :desc "Dismiss duet"})]))

; I come to the conclussion that it is better to just open opencode in a different tmux pane.
; If you are all in in agentic programming you are not going to use Neovim anyway.
; The bare minimum is to at least open Opencode inside Neovim in case I forget to use tmux.
(let [opencode (require :opencode)
      wk (require :which-key)]
  (wk.add [(wk-spec! :<Leader>ao opencode.toggle
                     {:mode :n :desc "Toggle opencode"})]))
