(import-macros {: on-filetype! : uses-pack!} :deezmacros)

; nvim-treesitter's registry only supports GitHub -- use ts-install
; https://github.com/nvim-treesitter/nvim-treesitter/pull/8316
; https://github.com/nvim-treesitter/nvim-treesitter/pull/8405
; https://github.com/nvim-treesitter/nvim-treesitter/pull/8120
; https://github.com/nvim-treesitter/nvim-treesitter/issues/8265

(uses-pack! "https://github.com/nvim-treesitter/nvim-treesitter")
(uses-pack! "https://github.com/lewis6991/ts-install.nvim")

(local blueprint
       {:install_info {:url "https://gitlab.com/gabmus/tree-sitter-blueprint"
                       :revision :355ef84ef8a958ac822117b652cf4d49bac16c79}})

(let [treesitter (require :nvim-treesitter)
      ts-install (require :ts-install)
      languages [:blueprint
                 :c
                 :dockerfile
                 :elixir
                 :fennel
                 :go
                 :java
                 :javascript
                 :lua
                 :ruby
                 :rust
                 :svelte
                 :typescript]]
  (treesitter.setup)
  (ts-install.setup {:parsers {: blueprint}
                     :ensure_install languages
                     :auto_install true})
  (on-filetype! languages (vim.treesitter.start)))
