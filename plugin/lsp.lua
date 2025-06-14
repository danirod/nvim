require("mason").setup()
require("mason-lspconfig").setup()

-- Import capabilities and attach
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Configure language servers
local lspconfig = require("lspconfig")

local servers = {
  { "blueprint_ls" },
  { "clangd" },
  { "cmake" },
  { "eslint" },
  { "elixirls" },
  { "gopls" },
  -- { "jdtls" },
  { "intelephense", {
    cmd = { "env", "HOME=/tmp", "intelephense", "--stdio" },
  } },
  { "pylsp" },
  { "rust_analyzer" },
  { "svelte" },
  { "ts_ls" },
  { "lemminx" },
  { "lua_ls" },
  { "unocss" },
  { "vala_ls" },
  { "volar" },
}

for _, server in ipairs(servers) do
  local server_name = server[1]
  local server_config = {
    capabilities = capabilities,
  }
  if #server == 2 then
    for k, v in pairs(server[2]) do
      server_config[k] = v
    end
  end
  lspconfig[server_name].setup(server_config)
end

lspconfig.lua_ls.setup({
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace",
      },
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        globals = { "vim", "require" },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
      telemetry = {
        enable = false,
      },
    },
  },
})

-- Disable semantic highlight
local disable_semantic_highlight = function()
  local compl = vim.fn.getcompletion("@lsp", "highlight")
  for _, group in ipairs(compl) do
    vim.api.nvim_set_hl(0, group, {})
  end
end
vim.api.nvim_create_autocmd("ColorScheme", {
  desc = "Disable semantic highlights",
  callback = disable_semantic_highlight,
})
disable_semantic_highlight()

vim.keymap.set("n", "gA", function()
  require("fzf-lua").lsp_code_actions({
    previewer = false,
    winopts = { height = 0.33, width = 0.5 },
  })
end)

-- Key mappings
vim.keymap.set("n", "gp", vim.diagnostic.open_float)

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
    local opts = { buffer = ev.buf }

    -- local key mappings
    vim.keymap.set("n", "gt", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gt", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

    -- inlay hints
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
    end
  end,
})

-- cmp for completion engine
local cmp = require("cmp")
local luasnip = require("luasnip")
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
  }, {
    { name = "buffer" },
  }),
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<C-o>"] = cmp.mapping.confirm({ select = true }),
  }),
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
})

-- https://github.com/neovim/neovim/issues/30985
for _, method in ipairs({ "textDocument/diagnostic", "workspace/diagnostic" }) do
  local default_diagnostic_handler = vim.lsp.handlers[method]
  vim.lsp.handlers[method] = function(err, result, context, config)
    if err ~= nil and err.code == -32802 then
      return
    end
    return default_diagnostic_handler(err, result, context, config)
  end
end

require("fidget").setup({})
