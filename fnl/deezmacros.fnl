;; Calls the given rules when a filetype is detected
;; For instance, when you open a file of a specific type.
(fn on-filetype! [pattern & rules]
  `(vim.api.nvim_create_autocmd :FileType
                                {:pattern ,pattern
                                 :callback (fn [] ,(unpack rules))}))

;; Install a package using the native neovim package manager
(fn uses-pack! [& spec]
  `(vim.pack.add ,spec {:confirm false}))

;; Configures an autocmd hook that gets triggered when the pack with the given name is installed or updated.
(fn on-pack-changed! [pname hook]
  `(let [is-spec# (fn [ev#]
                    (and (or (= ev#.data.kind :install)
                             (= ev#.data.kind :update))
                         (= ev#.data.spec.name ,pname)))
         callback# (fn [ev#]
                     (if (is-spec# ev#) (,hook ev#.data)))]
     (vim.api.nvim_create_autocmd :PackChanged {:callback callback#})))

;; Simplifies the interface when calling which-key.add by wrapping all those ugly 1s and 2s
(fn wk-spec! [name ?mapping ?rest]
  (let [spec `{1 ,name}]
    (when ?mapping
      (tset spec 2 ?mapping))
    (when ?rest
      (each [k v (pairs ?rest)]
        (tset spec k v)))
    spec))

{: on-filetype! : uses-pack! : wk-spec! : on-pack-changed!}
