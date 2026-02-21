(import-macros {: uses-pack! : wk-spec!} :deezmacros)

(uses-pack! "https://github.com/junegunn/fzf"
            "https://github.com/ibhagwan/fzf-lua")

(let [fzf (require :fzf-lua)
      wk (require :which-key)]
  (fzf.setup {1 :fzf-native})
  (fzf.register_ui_select)
  (wk.add [(wk-spec! "<Leader>," fzf.files {:desc "List files"})
           (wk-spec! :<Leader>. fzf.buffers {:desc "List buffers"})
           (wk-spec! :<C-T> fzf.grep {:desc "Start grep"})]))
