(import-macros {: uses-pack! : wk-spec!} :deezmacros)

; Keybindings not working?
; (uses-pack! "https://github.com/chentoast/marks.nvim")

(uses-pack! "https://github.com/tomasky/bookmarks.nvim")

(let [bookmarks (require :bookmarks)
      wk (require :which-key)
      bookfile (.. (vim.fn.stdpath :data) :/bookmarks)]
  (bookmarks.setup {:save_file bookfile})
  (wk.add [(wk-spec! :<Leader>mm bookmarks.bookmark_toggle
                     {:desc "Toggle bookmark"})
           (wk-spec! :<Leader>mn bookmarks.bookmark_next
                     {:desc "Next bookmark"})
           (wk-spec! :<Leader>mp bookmarks.bookmark_prev
                     {:desc "Previous bookmark"})]))
