(fn mk-buffer [content]
  (let [buffer (vim.api.nvim_create_buf false true)
        preoptions {:buftype :nofile
                    :bufhidden :wipe
                    :swapfile false
                    :filetype :lua}
        postoptions {:modifiable false :readonly true}]
    (each [opt val (pairs preoptions)]
      (vim.api.nvim_buf_set_option buffer opt val))
    (vim.api.nvim_buf_set_lines buffer 0 -1 false content)
    (each [opt val (pairs postoptions)]
      (vim.api.nvim_buf_set_option buffer opt val))
    buffer))

(macro half [v]
  `(math.floor (/ ,v 2)))

(fn open-as-float [buffer]
  (let [width (math.floor (* vim.o.columns 0.75))
        height (math.floor (* vim.o.lines 0.7))
        winopts {:relative :editor
                 : width
                 : height
                 :col (half (- vim.o.columns width))
                 :row (half (- vim.o.lines height))
                 :style :minimal
                 :border :rounded}
        win (vim.api.nvim_open_win buffer true winopts)]
    (vim.keymap.set :n :q :<cmd>close<cr> {: buffer :silent true :nowait true})
    win))

(fn inspect-in-buffer [data]
  (let [content (-> data
                    (vim.inspect)
                    (vim.split "\n"))
        buffer (mk-buffer content)]
    (open-as-float buffer)))

(fn pack-is-installed [ev pname]
  (and (= ev.data.kind :install) (= ev.data.spec.name pname)))

{: inspect-in-buffer}
