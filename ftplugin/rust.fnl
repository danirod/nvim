(import-macros {: on-filetype! : uses-pack! : on-pack-changed!} :deezmacros)

(on-pack-changed! :cargo.nvim
                  (fn [data]
                    (vim.system [:cargo :build :--release] {:cwd data.path})))

(uses-pack! "https://github.com/nwiizo/cargo.nvim")
