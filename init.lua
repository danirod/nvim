-- Bootstrap a fennel environment and jump to the actual config
vim.pack.add({ "https://github.com/rktjmp/hotpot.nvim" }, { confirm = false })
require("hotpot")
require("deezconf")

-- Keybindings
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>")
