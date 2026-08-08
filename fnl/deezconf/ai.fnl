(import-macros {: uses-pack! : api-key! : wk-spec!} :deezmacros)

(uses-pack! "https://github.com/milanglacier/minuet-ai.nvim"
            "https://github.com/nickjvandyke/opencode.nvim")

; Inline completions
(let [minuet (require :minuet)
      wk (require :which-key)
      tab-languages [:bash
                     :c
                     :cpp
                     :fennel
                     :html
                     :javascript
                     :javascriptreact
                     :meson
                     :lua
                     :python
                     :php
                     :ruby
                     :rust
                     :toml
                     :typescript
                     :typescriptreact]
      deepseek-endpoint "https://api.deepseek.com/chat/completions"
      deepseek-model :deepseek-v4-flash
      deepseek-api-key (api-key! :tokens/deepseek/minuet)
      deepseek-options {:name :deepseek
                        :model deepseek-model
                        :end_point deepseek-endpoint
                        :api_key (fn [] deepseek-api-key)
                        :optional {:thinking {:type :disabled}
                                   :max_tokens 256
                                   :top_p 0.9}}
      provider-options {:openai_compatible deepseek-options}
      duet-deepseek-options {:name :deepseek
                             :model deepseek-model
                             :end_point deepseek-endpoint
                             :api_key (fn [] deepseek-api-key)
                             :optional {:thinking {:type :disabled}}}
      duet-skip-env (fn [bufnr]
                      (let [buffer (vim.api.nvim_buf_get_name bufnr)
                            filename (vim.fn.fnamemodify buffer :t)]
                        (not (string.find filename :.env 1 true))))
      duet-options {:provider :openai_compatible
                    :provider_options {:openai_compatible duet-deepseek-options}
                    :recent_edits {:enabled true
                                   :enable_predicates [duet-skip-env]}}]
  (minuet.setup {:provider :openai_compatible
                 :notify :debug
                 :request_timeout 4
                 :throttle 1000
                 :debounce 400
                 :virtualtext {:auto_trigger_ft tab-languages
                               :keymap {:accept :<Tab>
                                        :prev "<A-[>"
                                        :next "<A-]>"
                                        :dismiss :<A-Esc>}}
                 :provider_options provider-options
                 :duet duet-options})
  (wk.add [(wk-spec! :<Leader>ap "<cmd>Minuet duet predict<cr>"
                     {:mode [:i :n] :silent true :desc "Predict duet"})
           (wk-spec! :<Leader>ac "<cmd>Minuet duet apply<cr>"
                     {:mode [:i :n] :silent true :desc "Apply duet"})
           (wk-spec! :<Leader>ax "<cmd>Minuet duet dismiss<cr>"
                     {:mode [:i :n] :silent true :desc "Dismiss duet"})]))

; Fallback. Use a tmux split for opencode, trust me bro.
(let [opencode (require :opencode)
      wk (require :which-key)]
  (wk.add [(wk-spec! :<Leader>ao opencode.toggle
                     {:mode :n :desc "Toggle opencode"})]))
