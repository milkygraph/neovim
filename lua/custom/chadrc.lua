local M = {}

M.plugins = "custom.plugins"
M.mappings = require "custom.mappings"
M.ui = {
    hl_override = {
        Comment = {italic = true, fg = "white"},
        ["@exception"] = {
            italic = true,
        },

        ["@float"] = {
            italic = true,
        },

        ["@keyword"] = {
            italic = true,
        },

        ["@keyword.function"] = {
            italic = true,
        },

        ["@function"] = {
            italic = true,
        },
    }
}

vim.cmd [[
    set foldmethod=expr
    set foldexpr=nvim_treesitter#foldexpr()
    set foldlevel=20
]]


vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "CmpNormal", { bg = "none" })

-- set tab widths
vim.opt.tabstop = 4


-- vim.opt.colorcolumn = "80"
vim.opt.wrap = false

return M
