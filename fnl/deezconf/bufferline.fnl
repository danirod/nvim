(import-macros {: uses-pack! : wk-spec!} :deezmacros)

(set vim.opt.termguicolors true)

(uses-pack! "https://github.com/akinsho/bufferline.nvim")

(let [bufferline (require :bufferline)
      wk (require :which-key)]
  (bufferline.setup {:options {:color_icons true
                               :diagnostics :nvim_lsp
                               :numbers :ordinal
                               :offsets [{:filetype :neo-tree
                                          :highlight :Directory
                                          :separator false}]
                               :separator_style :thin
                               :show_buffer_close_icons false
                               :show_tab_indicators true
                               :style_preset [bufferline.style_preset.no_italic]}})
  (wk.add [{1 :<Leader><Space>
            2 ":BufferLinePick<CR>"
            :desc "Pick a buffer from the bufferline"}]))
