-- dap
local dap = require("dap")

-- codelldb: C/C++/Rust
dap.adapters.codelldb = {
  type = "server",
  port = "${port}",
  executable = {
    command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
    args = { "--port", "${port}" },
  },
}
dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
  },
}
dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

-- Go via Delve
dap.adapters.go = {
  type = "executable",
  command = vim.fn.stdpath("data") .. "/mason/bin/go-debug-adapter",
}
dap.configurations.go = {
  {
    type = "go",
    name = "Debug",
    request = "launch",
    showLog = false,
    program = "${file}",
    dlvToolPath = vim.fn.stdpath("data") .. "/mason/bin/dlv",
  },
}

-- Python
dap.adapters.python = function(cb, config)
  if config.request == "attach" then
    ---@diagnostic disable-next-line: undefined-field
    local port = (config.connect or config).port
    ---@diagnostic disable-next-line: undefined-field
    local host = (config.connect or config).host or "127.0.0.1"
    cb({
      type = "server",
      port = assert(port, "`connect.port` is required for a python `attach` configuration"),
      host = host,
      options = {
        source_filetype = "python",
      },
    })
  else
    cb({
      type = "executable",
      command = vim.fn.stdpath("data") .. "/mason/bin/debugpy-adapter",
      options = {
        source_filetype = "python",
      },
    })
  end
end
dap.configurations.python = {
  {
    type = "python",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    pythonPath = function()
      local cwd = vim.fn.getcwd()
      if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
        return cwd .. "/venv/bin/python"
      elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
        return cwd .. "/.venv/bin/python"
      else
        return "/usr/bin/python"
      end
    end,
  },
}

-- NodeJS / JavaScript
dap.adapters["pwa-node"] = {
  type = "server",
  host = "localhost",
  port = "${port}",
  executable = {
    command = vim.fn.stdpath("data") .. "/mason/bin/js-debug-adapter",
    args = { "${port}" },
  },
}
dap.configurations.javascript = {
  {
    type = "pwa-node",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    cwd = "${workspaceFolder}",
  },
}
dap.configurations.typescript = dap.configurations.javascript

-- Ruby (requires adding rdbg manually to your Gemfile)
dap.adapters.ruby = function(callback, config)
  callback({
    type = "server",
    host = "127.0.0.1",
    port = "${port}",
    executable = {
      command = "bundle",
      args = {
        "exec",
        "rdbg",
        "-n",
        "--open",
        "--port",
        "${port}",
        "-c",
        "--",
        "bundle",
        "exec",
        config.command,
        config.script,
      },
    },
  })
end
dap.configurations.ruby = {
  {
    type = "ruby",
    name = "debug current file",
    request = "attach",
    localfs = true,
    command = "ruby",
    script = "${file}",
  },
  {
    type = "ruby",
    name = "run current spec file",
    request = "attach",
    localfs = true,
    command = "rspec",
    script = "${file}",
  },
}

dap.configurations.java = {
  {
    name = "Java",
    javaExec = "java",
    request = "launch",
    type = "java",
    mainClass = function()
      return vim.fn.input("Main class: ")
    end,
  },
  {
    type = "java",
    request = "attach",
    name = "Debug (Attach) - Remote",
    hostName = "127.0.0.1",
    port = 5005,
  },
}

-- dapui
local dapui = require("dapui")
dapui.setup({
  layouts = {
    {
      elements = {
        {
          id = "scopes",
          size = 0.25,
        },
        {
          id = "breakpoints",
          size = 0.25,
        },
        {
          id = "stacks",
          size = 0.25,
        },
        {
          id = "watches",
          size = 0.25,
        },
      },
      position = "right",
      size = 40,
    },
    {
      elements = {
        {
          id = "repl",
          size = 0.5,
        },
        {
          id = "console",
          size = 0.5,
        },
      },
      position = "bottom",
      size = 10,
    },
  },
})
dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end

vim.keymap.set("n", "<Leader>du", dapui.toggle)
vim.keymap.set("n", "<Leader>db", dap.toggle_breakpoint)
vim.keymap.set("n", "<Leader>dc", function()
  local condition = vim.fn.input("Condition: ")
  dap.toggle_breakpoint(condition)
end)

-- after thought, using leader chords for these keys would be
-- extremely unhelpful when doing things like step-step-step-next-step
-- so just use function keys for this
vim.keymap.set("n", "<f5>", dap.continue)
vim.keymap.set("n", "<f10>", dap.step_over)
vim.keymap.set("n", "<f11>", dap.step_into)
vim.keymap.set("n", "<f12>", dap.step_out)
