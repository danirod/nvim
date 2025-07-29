-- Add missing imports

local function fix_missing_imports()
  vim.lsp.buf.code_action({
    apply = true,
    filter = function(action)
      return action.title == "source.addMissingImports.ts"
    end,
  })
end

vim.keymap.set("n", "gfi", fix_missing_imports)
