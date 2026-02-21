;; LSP and completion. I might merge this and format.fnl into coding.fnll

(import-macros {: uses-pack! : wk-spec!} :deezmacros)

(uses-pack! "https://github.com/williamboman/mason.nvim"
            "https://github.com/williamboman/mason-lspconfig.nvim"
            "https://github.com/hrsh7th/cmp-nvim-lsp"
            "https://github.com/hrsh7th/nvim-cmp"
            "https://github.com/saadparwaiz1/cmp_luasnip"
            "https://github.com/j-hui/fidget.nvim"
            "https://github.com/neovim/nvim-lspconfig")

;; Mason can take care of installing and enabling some servers.
(let [mason (require :mason)
      mason-lspconfig (require :mason-lspconfig)
      mason-servers [:clangd
                     :cmake
                     :eslint
                     :elixirls
                     :gopls
                     :intelephense
                     :pylsp
                     :rust_analyzer
                     :svelte
                     :ts_ls
                     :tailwindcss
                     :unocss
                     :astro
                     :ruby_lsp
                     :lua_ls
                     :lemminx]]
  (mason.setup)
  (mason-lspconfig.setup {:ensure_installed mason-servers
                          :automatic_enable mason-servers}))

;; LSP server configurations
(vim.lsp.config :intelephense {:cmd [:env :HOME=/tmp :intelephense :--stdio]})
(vim.lsp.config :lua_ls
                {:settings {:Lua {:completion {:callSnippet :Replace}
                                  :runtime {:version :LuaJIT}
                                  :workspace {:library (vim.api.nvim_get_runtime_file ""
                                                                                      true)}
                                  :telemetry {:enable false}
                                  :diagnostics {:globals [:vim]}}}})

(vim.lsp.enable :blueprint_ls)
(vim.lsp.enable :vala_ls)

;; TODO: configure keybindings. K for the hover docs.
;; TODO: assert completion is working.

(fn lsp-attach-callback [args]
  (let [client-id args.data.client_id
        client (vim.lsp.get_client_by_id client-id)
        buffer args.buf]
    (when (and client (client:supports_method :textDocument/inlayHint))
      (vim.lsp.inlay_hint.enable true {:bufnr buffer}))))

(let [group (vim.api.nvim_create_augroup :user_lsp {:clear true})]
  (vim.api.nvim_create_autocmd :LspAttach
                               {: group :callback lsp-attach-callback}))

;; cmp is the completion engine -- not usually required, but i also want to have luasnip
(let [cmp (require :cmp)
      luasnip (require :luasnip)]
  (cmp.setup {:snippet {:expand (fn [args]
                                  (luasnip.lsp_expand args.body))}
              :sources (cmp.config.sources [{:name :nvim_lsp} {:name :luasnip}]
                                           [{:name :buffer}])
              :mapping (cmp.mapping.preset.insert {:<C-b> (cmp.mapping.scroll_docs -4)
                                                   :<C-f> (cmp.mapping.scroll_docs 4)
                                                   :<C-Space> (cmp.mapping.complete)
                                                   :<C-e> (cmp.mapping.abort)
                                                   :<C-o> (cmp.mapping.confirm {:select true})})
              :window {:completion (cmp.config.window.bordered)
                       :documentation (cmp.config.window.bordered)}}))

;; LSP status notifications
(let [fidget (require :fidget)]
  (fidget.setup {:notification {:window {:winblend 0 :border :none}}}))

; Note: I am intentionally NOT disabling semantic formatting because maybe the thing has gone better
; in the last two years. I am still vigilant and this comment is mostly a recall for me to port

; that part of the snippet if it starts doing bad things.
