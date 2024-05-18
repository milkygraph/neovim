local M = {}

M.lspconfig = {
    plugin = true,
    n = {
        ["gr"] = {
            function()
                vim.cmd [[:Telescope lsp_references]]
            end,
            "Find LSP references",
        },
        ["<leader>lf"] = {
            function()
                vim.cmd [[:Telescope lsp_document_symbols]]
            end,
            "Find LSP symbols",
        }
    }
}

M.trouble = {
    n = {
        ["<leader>tt"] = {
            function()
                require("trouble").toggle()
            end,
            "Toggle Trouble",
        },
    }
}

M.zenmode = {
    n = {
        ["<leader>zz"] = {
            function()
                require("zen-mode").toggle()
            end,
            "Toggle Zen Mode",
        },
    }
}

M.telescope = {
    n = {
        ["<leader>fg"] = {
            function ()
                -- Check if the current directory is a git repo
                local git_dir = vim.fn.finddir(".git/..", ".;")
                if git_dir == "" then
                    print("Not a git repo")
                    return
                end
                vim.cmd [[:Telescope git_files]]
            end,
            "Find git files",
        }
    }
}

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

return M
