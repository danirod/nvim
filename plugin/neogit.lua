local neogit = require("neogit")

neogit.setup({
  kind = "split_above",
})

vim.keymap.set("n", "<Leader>gg", neogit.open)
