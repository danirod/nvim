local fzf = require("fzf-lua")

fzf.setup({ "fzf-native" })

vim.keymap.set("n", "<Leader>,", fzf.files)
vim.keymap.set("n", "<Leader>;", fzf.buffers)
vim.keymap.set("n", "<C-T>", fzf.grep)
