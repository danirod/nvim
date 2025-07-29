-- vim.o.background = "dark"
-- require("onedarkpro").setup({
--   options = {
--     transparency = true,
--   },
-- })
-- require("onedarkpro").load()

-- local c = require("vscode.colors").get_colors()
-- require("vscode").setup({
--   transparent = true,
--   italic_comments = false,
--   group_overrides = {
--     StatusLine = { fg = c.vscFront, bg = c.vscUiBlue },
--     StatusLineNC = { fg = c.vscGray, bg = c.vscUiBlue },
--     LspInlayHint = { fg = c.vscGray },
--   },
-- })
-- require("vscode").load()

vim.cmd("hi Normal guibg=NONE")
vim.cmd("hi ModeMsg guibg=NONE")
vim.cmd("hi Whitespace ctermfg=blue guifg=NvimDarkGrey4")
