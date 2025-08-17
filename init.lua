require("hotpot")

-- "Theme"
local function reload_theme()
  vim.cmd([[
    match ExtraWhitespace /\s\+$/
    highlight ExtraWhitespace ctermbg=1
    highlight Whitespace ctermfg=236
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

vim.opt.signcolumn = "yes"
vim.opt.number = true
vim.opt.relativenumber = true

-- Keybindings
vim.keymap.set("n", "<C-N>", "<cmd>bnext<cr>")
vim.keymap.set("n", "<C-P>", "<cmd>bprev<cr>")
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>")
vim.g.mapleader = ","

-- Some rulers
-- https://github.com/barreiroleo/nvim-config/blob/cb9532653540a32a4a2fdab53b85749f2bfda19a/after/plugin/autocmds.lua#L46-L52
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "gitcommit" },
  callback = function()
    vim.opt_local.colorcolumn = { 50, 72 }
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "changelog" },
  callback = function()
    vim.opt_local.colorcolumn = { 72 }
  end,
})
