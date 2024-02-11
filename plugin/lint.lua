local lint = require("lint")

-- So that clang languages show errors like unused variables and such
lint.linters.clangtidy.args = {
  "--extra-arg=-Wall",
  "--quiet",
}

-- Note: many LSP already lint. Only languages whose reference LSP does not
-- lint (or languages where there is no LSP) should be added here.
lint.linters_by_ft = {
  c = { "clangtidy" },
  cpp = { "clangtidy" },
  h = { "clangtidy" },
  proto = { "buf_lint" },
  markdown = { "markdownlint" },
  gitcommit = { "gitlint" },
  yaml = { "yamllint" },
}

-- Lint automatically on file open, on stop inserting, and after saving.
-- TODO: Can I lint on TextChanged, or will it be too much?
vim.api.nvim_create_autocmd({ "BufEnter", "BufReadPost", "InsertLeave", "BufWritePost" }, {
  callback = function()
    lint.try_lint()
  end,
})
