-- luasnip
local luasnip = require("luasnip")

vim.keymap.set({ "i", "s" }, "<C-L>", function()
  luasnip.jump(1)
end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-K>", function()
  luasnip.jump(0)
end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-J>", function()
  luasnip.jump(-1)
end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-E>", function()
  if luasnip.choice_active() then
    luasnip.change_choice(1)
  end
end, { silent = true })

require("luasnip.loaders.from_vscode").lazy_load({
  paths = { "~/.config/nvim/snippets/" },
})
