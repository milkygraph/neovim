local plugins = {
    { "github/copilot.vim",
        lazy=false,
        config = function ()
            vim.g['copilot_no_tab_map'] = true
            vim.g['copilot_assume_mapped'] = true
            vim.api.nvim_set_keymap('i', '<C-a>', 'copilot#Accept("<CR>")', {expr = true, silent=true})
        end,
    },
    {"fatih/vim-go",
        lazy=false,
        config = function ()
            vim.g.go_doc_keywordprg_enabled = 0
        end
    },
    {"kdheepak/lazygit.nvim", lazy=false},
    {"nvim-treesitter/nvim-treesitter-context", lazy=false},
    {"folke/zen-mode.nvim",
        opts = {
            window = {
                width = 120,
                options = {
                    number = true,
                    relativenumber = true,
                    laststatus = 0, -- turn off the statusline in zen mode
                }
            },
        },
        lazy=false
    },
    {
        "mfussenegger/nvim-dap",
        lazy=false,
        config = function(_, _)
            local dap = require("dap")

            dap.adapters.lldb = {
                type = "executable",
                command = "lldb-vscode-15",
                name = "lldb",
            }

            dap.configurations.cpp = {
                {
                    name = "Launch with arguments",
                    type = "lldb",
                    request = "launch",
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    end,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = true,
                    args = function()
                        return vim.split(vim.fn.input("Arguments: "), " ")
                    end,
                    runInTerminal = false,
                },
            }

            dap.configurations.c = dap.configurations.cpp

            dap.configurations.python = {
                {
                    type = "python",
                    request = "launch",
                    name = "Launch Python file",
                    program = "${file}",
                    pythonPath = function()
                        return vim.fn.exepath("python3")
                    end,
                },
            }

            local function dap_mappings()
                vim.api.nvim_set_keymap("n", "<Leader>du", '<Cmd>lua require"dapui".toggle()<CR>', {
                    silent = true,
                    noremap = true,
                })
                vim.api.nvim_set_keymap("n", "<C-b>", '<Cmd>DapToggleBreakpoint<CR>', {
                    silent = true,
                    noremap = true,
                })
                vim.api.nvim_set_keymap("n", "<F5>", '<Cmd>DapContinue<CR>',{
                    silent = true,
                    noremap = true,
                })
                vim.api.nvim_set_keymap("n", "<F10>", '<Cmd>DapStepOver<CR>',{
                    silent = true,
                    noremap = true,
                })
                vim.api.nvim_set_keymap("n", "<F12>", '<Cmd>DapStepInto<CR>',{
                    silent = true,
                    noremap = true,
                })
                vim.api.nvim_set_keymap("n", "<F29>", '<Cmd>DapTerminate<CR>',{
                    silent = true,
                    noremap = true,
                })
            end

            dap_mappings()
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        event = "VeryLazy",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")
            dapui.setup()
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
        end,
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = "mfussenegger/nvim-dap",
        lazy=false,
        opts = {
            handlers = {},
            ensure_installed = {
                "codelldb",
            },
        },
    },
    {
        "mfussenegger/nvim-dap-python",
        lazy = false,
        config = function ()
            require("dap-python").setup("python3")
        end
    },
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("trouble").setup({
                auto_open = false,
                auto_close = true,
                auto_preview = false,
                auto_fold = false,
                use_diagnostic_signs = true,
            })
        end,
        opts = {
            severity = nil,
        },
        lazy = false,
    },
    {
        'kdheepak/lazygit.nvim',
        config = function()
            vim.api.nvim_set_keymap('n', '<leader>lg', '<cmd>LazyGit<CR>', { noremap = true, silent = true })
        end
    },
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        lazy = false,
        config = function ()
            local harpoon = require("harpoon")
            harpoon:setup({})

            -- basic telescope configuration
            local conf = require("telescope.config").values
            local function toggle_telescope(harpoon_files)
                local file_paths = {}
                for _, item in ipairs(harpoon_files.items) do
                    table.insert(file_paths, item.value)
                end

                require("telescope.pickers").new({}, {
                    prompt_title = "Harpoon",
                    finder = require("telescope.finders").new_table({
                        results = file_paths,
                    }),
                    previewer = conf.file_previewer({}),
                    sorter = conf.generic_sorter({}),
                    initial_mode = "insert",
                }):find()
            end

            vim.keymap.set("n", "<C-e>", function()
                toggle_telescope(harpoon:list())
                vim.api.nvim_feedkeys("", "n", true)
            end,
                { desc = "Open harpoon window" })
            vim.keymap.set("n", "<leader>a", function() harpoon:list():append() end)

            -- Toggle previous & next buffers stored within Harpoon list
            vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
            vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)
        end
    },
    {
        'stevearc/oil.nvim',
        opts = {},
        lazy = true,
        -- Optional dependencies
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function ()
            require("oil").setup()
            vim.api.nvim_set_keymap('n', '<leader>o', '<cmd>Oil<CR>', { noremap = true, silent = true })
        end
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        lazy = false,
        opts = {
        }
    },
    {
        "tpope/vim-dadbod",
        lazy = false,
    },
    {
        "kristijanhusak/vim-dadbod-ui",
        dependencies = {
            { 'tpope/vim-dadbod', lazy = true },
            { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql', 'psql' }, lazy = true },
        },
        cmd = {
            'DBUI',
            'DBUIToggle',
            'DBUIAddConnection',
            'DBUIFindBuffer',
        },
        init = function()
            -- Your DBUI configuration
            vim.g.db_ui_use_nerd_fonts = 1
       end,
    },
    {
        'milkygraph/zone.nvim',
        lazy = false,
        config = function ()
            require('zone').setup{
                style = "treadmill",
                exclude_filetypes = { "TelescopePrompt", "NvimTree", "neo-tree", "dashboard", "lazy" },
                -- More options to come later

                treadmill = {
                    direction = "left",
                    headache = true,
                    tick_time = 30,     -- Lower, the faster
                    -- Opts for Treadmill style
                },
                epilepsy = {
                    stage = "aura",     -- "aura" or "ictal"
                    tick_time = 100,
                },
                dvd = {
                    -- text = {"line1", "line2", "line3", "etc"}
                    tick_time = 100,
                    -- Opts for Dvd style
                },
            }
        end,
    }
}

return plugins
