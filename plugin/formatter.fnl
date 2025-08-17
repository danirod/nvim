(let [formatter (require :formatter)
      blp (. (require :formatter.filetypes.blueprint) :blueprint_compiler)
      clangformat (. (require :formatter.filetypes.c) :clangformat)
      jq (. (require :formatter.filetypes.json) :jq)
      prettier (. (require :formatter.filetypes.javascript) :prettier)
      gofmt (. (require :formatter.filetypes.go) :gofmt)
      goimports (. (require :formatter.filetypes.go) :goimports)
      stylua (. (require :formatter.filetypes.lua) :stylua)
      black (. (require :formatter.filetypes.python) :black)
      rubocop (. (require :formatter.filetypes.ruby) :rubocop)
      rustfmt (. (require :formatter.filetypes.rust) :rustfmt)
      xmlformat (. (require :formatter.filetypes.xml) :xmlformat)
      trailing (. (require :formatter.filetypes.any)
                  :remove_trailing_whitespace)
      fnlfmt {:exe :fnlfmt :args ["-"] :stdin true}]
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
  (vim.api.nvim_create_autocmd :BufWritePost {:command :FormatWrite}))

;; TODO: Disable format on save
