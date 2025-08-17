(let [fzf (require :fzf-lua)]
  (fzf.setup {1 :fzf-native})
  (fzf.register_ui_select)

  (vim.keymap.set "n" "<Leader>," fzf.files)
  (vim.keymap.set "n" "<Leader>;" fzf.buffers)
  (vim.keymap.set "n" "<C-T>" fzf.grep))
