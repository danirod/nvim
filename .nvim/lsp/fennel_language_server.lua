-- https://github.com/rydesun/fennel-language-server#neovim
return {
  settings = {
    fennel = {
      workspace = {
        library = vim.api.nvim_list_runtime_paths(),
      },
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
}
