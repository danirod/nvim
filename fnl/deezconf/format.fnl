(import-macros {: uses-pack! : wk-spec!} :deezmacros)

(uses-pack! "https://github.com/mhartington/formatter.nvim")

(let [formatter (require :formatter)
      wk (require :which-key)
      black (. (require :formatter.filetypes.python) :black)
      blp {:exe :blueprint-compiler :args [:format :-f] :stdin false}
      clangformat (. (require :formatter.filetypes.c) :clangformat)
      fnlfmt {:exe :fnlfmt :args ["-"] :stdin true}
      gofmt (. (require :formatter.filetypes.go) :gofmt)
      goimports (. (require :formatter.filetypes.go) :goimports)
      jq (. (require :formatter.filetypes.json) :jq)
      prettier (. (require :formatter.filetypes.javascript) :prettier)
      rubocop (. (require :formatter.filetypes.ruby) :rubocop)
      rustfmt (. (require :formatter.filetypes.rust) :rustfmt)
      stylua (. (require :formatter.filetypes.lua) :stylua)
      trailing (. (require :formatter.filetypes.any)
                  :remove_trailing_whitespace)
      xmlformat (. (require :formatter.filetypes.xml) :xmlformat)]
  (formatter.setup {:logging true
                    :filetype {:blueprint [blp]
                               :c [clangformat]
                               :cpp [clangformat]
                               :fennel [fnlfmt]
                               :go [gofmt goimports]
                               :h [clangformat]
                               :java [clangformat]
                               :javascript [prettier]
                               :json [jq prettier]
                               :lua [stylua]
                               :typescript [prettier]
                               :python [black]
                               :ruby [rubocop]
                               :rust [rustfmt]
                               :svelte [prettier]
                               :vue [prettier]
                               :xml [xmlformat]
                               :* [trailing]}})

  (fn disable-auto-format []
    (set vim.b.disable_auto_format true)
    (print "Autoformat disabled"))

  (fn enable-auto-format []
    (set vim.b.disable_auto_format nil)
    (print "Autoformat enabled"))

  (fn toggle-auto-format []
    (if (= vim.b.disable_auto_format nil)
        (disable-auto-format)
        (enable-auto-format)))

  (fn format-write []
    (when (not vim.b.disable_auto_format)
      (vim.cmd :FormatWriteLock)))

  (fn format-now []
    (vim.cmd :FormatLock))

  (vim.api.nvim_create_user_command :FormatOnSaveDisable disable-auto-format {})
  (vim.api.nvim_create_user_command :FormatOnSaveEnable enable-auto-format {})
  (vim.api.nvim_create_user_command :FormatOnSaveToggle toggle-auto-format {})
  (vim.api.nvim_create_autocmd :BufWritePost {:callback format-write})
  (wk.add [(wk-spec! :<leader>ff format-now {:desc "Format file now"})
           (wk-spec! :<leader>ft toggle-auto-format {:desc "Toggle autoformat"})
           (wk-spec! :<leader>fe enable-auto-format {:desc "Enable autoformat"})
           (wk-spec! :<leader>fd disable-auto-format
                     {:desc "Disable autoformat"})]))
