(import-macros {: uses-pack! : api-key! : wk-spec!} :deezmacros)

(uses-pack! "https://github.com/milanglacier/minuet-ai.nvim")

; I couldn't find an AI engine that suited my intentions, so I basically made
; my own here. This is minuet-ai, but configured in manual mode instead of
; triggering a completion proposal every time a key is pressed.
;
; There were a bunch of reasons on why I did it this way:
;
; - I don't want inline completions being triggered automatically because even
;   through there is a throttle, most of them will be requested when the code
;   is not ready for an autocomplete suggestion, which means that the proposals
;   will be garbage.
; - Plus, all these completions that have to be ignored are a waste of compute
;   and money. Both for local LLM models where I have to pay for my electricity
;   or let minuet basically tear and wear my GPU card, and for cloud LLM models
;   where these completions waste money and are possibly harmful. Let's save
;   energy by only completing when needed.
; - For most flash models, as well as local ones, the completions are very bad
;   quality due to the latency requirements. I'd rather have one single
;   completion proposal with a well-defined prompt, than a thousand completion
;   proposals made by a garbage prompt.
; - For agentic programming, it probably makes more sense to delegate the AI to
;   an external program like OpenCode, Codex or Cursor, rather than trying to
;   chug the LLM into Neovim anyway. This mode is more like "I want to code,
;   but I am too lazy to write another loop".

(local minuet (require :minuet))
(local virtualtext (require :minuet.virtualtext))
(local wk (require :which-key))

(local deepseek {:id :deepseek-v4-pro
                 :root "https://api.deepseek.com/chat/completions"
                 :api-key (api-key! :tokens/deepseek/minuet)})

(local debug-request (.. (vim.fn.stdpath :cache) :/minuet-last-request.json))
(fn log-prompt [request]
  (vim.fn.writefile [(vim.json.encode request.body)] debug-request)
  request)

(local line-scope-prompt
       "The user is asking for a small completion that would finish the current line. Do not insert a line break and do not insert more than one line. Follow the semantics of the programming language and file.")

(local chunk-scope-prompt
       "The user is asking for a completion that would continue the code currently being written. Provide up to 3 lines that would complete the code being written in the cursor position. The completion may begin with an additional leading line break if needed. Do not invent additional code or move up in the scope.")

(local larger-chunk-scope-prompt
       "The user is asking explicitly for a larger completion that would continue the code currently being written. Provide 3 to 8 lines that would complete the code being written in the cursor position. The completion may begin with an additional line break if needed. Do not invent additional functions or statements or move up in the scope besides the completion.")

;; Taken from the minuet-ai default prompt. I have to modify it because the preset scopes may contradict the default one.
(local completion-guidelines
       "Guidelines:
1. Insert the completion after the <cursorPosition> marker.
2. Preserve the existing whitespace and indentation.
3. Return exactly one completion.
4. Return only insertable text without explanations or Markdown fences.
5. Do not repeat code already present around <cursorPosition>.")

(let [model deepseek
      model-options {:name :deepseek
                     :model model.id
                     :end_point model.root
                     :api_key (fn [] model.api-key)
                     :transform [log-prompt]
                     :system {:template "{{{prompt}}}
{{{guidelines}}}
{{{completion_scope}}}
{{{n_completion_template}}}"
                              :guidelines completion-guidelines
                              :completion_scope "Provide a concise completion that would continue the code at the cursor."}
                     :optional {:thinking {:type :disabled}
                                :max_tokens 256
                                :top_p 0.9}}
      provider-options {:openai_compatible model-options :n_completions 1}
      line-preset {:provider_options {:openai_compatible {:system {:completion_scope line-scope-prompt}
                                                          :optional {:max_tokens 128}}}}
      chunk-preset {:provider_options {:openai_compatible {:system {:completion_scope chunk-scope-prompt}
                                                           :optional {:max_tokens 256}}}}
      larger-chunk-preset {:provider_options {:openai_compatible {:system {:completion_scope larger-chunk-scope-prompt}
                                                                  :optional {:max_tokens 512}}}}]
  (fn completion []
    (virtualtext.action.dismiss)
    (virtualtext.action.next))

  (fn complete-line []
    (minuet.change_preset :line)
    (completion))

  (fn complete-chunk []
    (minuet.change_preset :chunk)
    (completion))

  (fn complete-larger-chunk []
    (minuet.change_preset :larger)
    (completion))

  (minuet.setup {:provider :openai_compatible
                 :notify :debug
                 :request_timeout 4
                 :virtualtext {:auto_trigger_ft []
                               :keymap {:accept :<Tab>
                                        :prev "<A-[>"
                                        :next "<A-]>"
                                        :dismiss :<A-Esc>}}
                 :provider_options provider-options
                 :presets {:line line-preset
                           :chunk chunk-preset
                           :larger larger-chunk-preset}})
  (wk.add [(wk-spec! :<C-i>1 complete-line
                     {:mode [:i :n] :silent true :desc "Complete line"})
           (wk-spec! :<C-i>2 complete-chunk
                     {:mode [:i :n] :silent true :desc "Complete chunk"})
           (wk-spec! :<C-i>3 complete-larger-chunk
                     {:mode [:i :n] :silent true :desc "Complete larger chunk"})]))
