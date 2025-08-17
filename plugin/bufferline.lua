vim.opt.termguicolors = true

local bufferline = require("bufferline")

local function inverse(table)
  return { fg = table.bg, bg = table.fg }
end

bufferline.setup({
  options = {
    show_buffer_close_icons = false,
    numbers = "ordinal",
    separator_style = "thin",
    style_preset = {
      bufferline.style_preset.no_italic,
    },
    diagnostics = "nvim_lsp",
    color_icons = true,
    show_tab_indicators = true,

    offsets = {
      {
        filetype = "neo-tree",
        highlight = "Directory",
        separator = true,
      },
    },
  },
})

vim.keymap.set("n", "<Leader><Space>", ":BufferLinePick<CR>")
