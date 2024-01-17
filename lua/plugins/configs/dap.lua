local dap = require('dap')

dap.adapters.cpp = {
  type = 'executable',
  attach = {
    pidProperty = "pid",
    pidSelect = "ask"
  },
  command = 'lldb-vscode',
  env = {
    LLDB_LAUNCH_FLAG_LAUNCH_IN_TTY = "YES"
  },
  name = "lldb"
}

dap.configurations.cpp = {
  {
    name = "Launch with arguments",
    type = "lldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to program: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = "${workspaceFolder}",
    args = {"./population1.csv", "out.csv", "v"},
  }
}

return dap
