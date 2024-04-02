-- "Theme"
local function reload_theme()
  vim.cmd([[
    match ExtraWhitespace /\s\+$/
    highlight ExtraWhitespace ctermbg=1
    highlight Whitespace ctermfg=236
    highlight Pmenu ctermbg=235 ctermfg=15
    highlight Pmenusel ctermbg=240 ctermfg=15
    highlight VertSplit cterm=NONE ctermbg=NONE ctermfg=7
    highlight StatusLine cterm=NONE ctermfg=yellow ctermbg=darkblue
    highlight StatusLineNC cterm=NONE ctermfg=yellow ctermbg=darkblue
    highlight LspInlayHint ctermfg=238 guifg=238
  ]])
end

-- The following should survive changing the colorscheme
reload_theme()
vim.api.nvim_create_autocmd("ColorScheme", {
  desc = "Cosmetic changes",
  callback = reload_theme,
})

-- Most of the options are set by a global $HOME/.editorconfig.
vim.opt.wrap = false
vim.opt.showmatch = true
vim.opt.list = true

-- Keybindings
vim.keymap.set("n", "<C-N>", "<cmd>bnext<cr>")
vim.keymap.set("n", "<C-P>", "<cmd>bprev<cr>")
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>")
vim.g.mapleader = ","
