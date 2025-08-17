require("neo-tree").setup({
  window = {
    width = 35,
    position = "right",
    auto_resize = true,
  },
  hijack_netrw_behavior = "open_default",
  filtered_items = {
    hide_dotfiles = false,
    hide_gitignore = false,
    visible = false,
  },
})

vim.keymap.set("n", "<Leader>nt", ":Neotree reveal toggle<CR>", { silent = true })
