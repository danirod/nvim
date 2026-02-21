(import-macros {: uses-pack! : wk-spec!} :deezmacros)

(local wk (require :which-key))

(uses-pack! "https://github.com/lewis6991/gitsigns.nvim"
            "https://github.com/nvim-lua/plenary.nvim"
            "https://github.com/NeogitOrg/neogit")

(let [gitsigns (require :gitsigns)]
  (gitsigns.setup {:current_line_blame true
                   :current_line_blame_opts {:virt_text_pos :right_align
                                             :delay 0}})
  (wk.add [(wk-spec! :<Leader>g {:group :Git})
           (wk-spec! :<Leader>gb gitsigns.toggle_current_line_blame
                     {:desc "Toggle Git blame"})
           (wk-spec! :<Leader>gs gitsigns.stage_hunk {:desc "Stage hunk"})
           (wk-spec! :<Leader>gn (fn [] (gitsigns.nav_hunk :next))
                     {:desc "Next hunk"})
           (wk-spec! :<Leader>gp (fn [] (gitsigns.nav_hunk :prev))
                     {:desc "Previous hunk"})
           (wk-spec! :<Leader>go gitsigns.preview_hunk
                     {:desc "Open hunk popup"})
           (wk-spec! :<Leader>gi gitsigns.preview_hunk_inline
                     {:desc "Open hunk inline"})]))

(let [neogit (require :neogit)]
  (neogit.setup {})
  (wk.add (wk-spec! :<Leader>gg neogit.open {:desc "Enter Git interface"})))
