local twilight = require("twilight")

twilight.setup({
  dimming = {
    alpha = 0.5,
    color = { "Normal", "#ffffff" },
    inactive = true,
  },
  context = 10,
  exclude = {},
})

local zen = require("zen-mode")

zen.setup({
  window = {
    width = 100,
  },
})

vim.keymap.set("n", "<Leader>zz", zen.toggle)
vim.keymap.set("n", "<Leader>zt", twilight.toggle)
