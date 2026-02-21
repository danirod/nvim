(import-macros {: uses-pack! : wk-spec!} :deezmacros)

(uses-pack! "https://github.com/nvim-lua/plenary.nvim"
            "https://github.com/MunifTanjim/nui.nvim"
            "https://github.com/nvim-neo-tree/neo-tree.nvim")

(let [neotree (require :neo-tree)
      wk (require :which-key)
      window {:width 35 :position :right :auto_resize true}
      filtered_items {:hide_dotfiles false
                      :hide_gitignore false
                      :visible false}
      options {: window :hijack_netrw_behavior :open_default : filtered_items}]
  (neotree.setup options)
  (wk.add (wk-spec! :<leader>nt ":Neotree reveal<cr>"))
  (wk.add (wk-spec! :<leader>nq ":Neotree close<cr>")))
