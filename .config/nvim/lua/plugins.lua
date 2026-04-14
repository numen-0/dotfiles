return {
    {
        "lukas-reineke/virt-column.nvim",
        lazy = true,
        event = { "BufReadPost", "BufNewFile" },
        opts = { char = "▕", },
    },
    {
        "smjonas/inc-rename.nvim",
        lazy = true,
        event = { 'LspAttach' },
        opts = {},
        init = function()
            vim.keymap.set("n", "<leader>rn", function()
                return ":IncRename " .. vim.fn.expand("<cword>")
            end, { expr = true })
        end
    },
    {
        "mbbill/undotree",
        lazy = true,
        event = { "BufReadPost", "BufNewFile" },
        init = function()
            vim.g.undotree_WindowLayout       = 3
            vim.g.undotree_DiffAutoOpen       = false
            vim.g.undotree_HelpLine           = false
            vim.g.undotree_SetFocusWhenToggle = 1
            require("mappings").map2("n", "<leader>u", vim.cmd.UndotreeToggle)
        end,
    },
    {
        "NvChad/nvim-colorizer.lua",
        lazy = true,
        -- event = { "BufReadPost", "BufNewFile" },
        ft = { "css", "html", "lua", "vim" },
        opts = {
            filetypes = {
                css  = { names = true, rgb_fn = true, hsl_fn = true },
                html = { names = true },
                "lua",
                "vim",
            },
            user_default_options = {
                names = false,
            },
            buftypes = {},
        },
    },
    {
        "RRethy/vim-illuminate",
        lazy = true,
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require('illuminate').configure({
                providers = {
                    'lsp',
                    'treesitter',
                    'regex',
                },
                delay = 100,
                filetypes_denylist = {
                    'dirbuf',
                    'dirvish',
                    'fugitive',
                },
                under_cursor = true,
                large_file_cutoff = nil,
                large_file_overrides = nil,
                min_count_to_highlight = 1,
                should_enable = function(_) return true end,
                case_insensitive_regex = false,
            })

            require("autocmds").new('ColorScheme', {
                callback = function()
                    vim.cmd("hi default IlluminatedWordText  gui=underline")
                    vim.cmd("hi default IlluminatedWordRead  gui=underline")
                    vim.cmd("hi default IlluminatedWordWrite gui=underline")
                end,
                pattern  = '*',
                desc     = "Reload vim-illuminate highlights"
            })
        end
    },
    {
        "numToStr/Comment.nvim",
        lazy = true,
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("Comment").setup({})
            local ft = require('Comment.ft')
            ft.set("carmen", { "// %s" })
            -- ft.set("asm", { "; %s" })
        end,
    },
    {
        "numen-0/beta.nvim",
        priority = 500,
        opts = {
            logo = {
                lines = {
                    [[┳┓    ┓┏•    ]],
                    [[┃┃┏┓┏┓┃┃┓┏┳┓ ]],
                    [[┛┗┗ ┗┛┗┛┗┛╹┗•]],
                },
                align = { offset = 0, style = "center" },
            },
            text = {
                lines = {
                    [["An idiot admires complexity, a genius admires simplicity"]],
                    [[                                            Terry A. Davis]],
                },
                align = { offset = 0, style = "center" },
            },
            gap = 0,
            user_command = false,
            hide_cursor  = false,
            unload_after = true,
        },
    },
    {
        -- "numen-0/doodle.nvim",
        dir = "~/stuff/code/nvim/doodle.nvim",
        opts = {},
    },
    {
        -- "numen-0/chisel.nvim",
        dir = "~/stuff/code/nvim/chisel.nvim",
        opts = {},
    },
    {
        -- "numen-0/glide.nvim",
        dir = "~/stuff/code/nvim/glide.nvim",
        opts = {},
    },
    {
        -- "numen-0/jab.nvim",
        dir = "~/stuff/code/nvim/jab.nvim",
        opts = {},
    },
    {
        -- "numen-0/temoji.nvim",
        dir = "~/stuff/code/nvim/temoji.nvim",
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "nvim-lua/plenary.nvim",
        },
        config = function()
            local temoji = require("temoji")
            temoji.setup({
                packs = {
                    ["ext"] = {
                        "ext", "hi",
                        { rep = "<><",      tags = { "fish" } },
                        { rep = "('._.)",   tags = { "nervous", "big" } },
                        { rep = ">:(",      tags = { "angly" } },
                        { rep = "^_^",      tags = { "happy" } },
                        { rep = "d(^c^ )",  tags = { "happy" } },
                    },
                    ["core"] = false,
                }
            })
            vim.keymap.set("n", "<leader>te", function()
                temoji.pick()
            end, { desc = "Pick a text emoji" })
            vim.keymap.set("n", "<leader>tr", function()
                temoji.pick({ "ascii" })
            end, { desc = "Pick a text emoji" })
            vim.keymap.set("n", "<leader>ts", function()
                temoji.random({ "ascii" })
            end, { desc = "Pick random text emoji with tag 'serious'" })
        end,
    },
}
