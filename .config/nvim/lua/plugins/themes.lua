return {
    { "rose-pine/neovim", name = "rose-pine" },
    {
        "numen-0/leun.nvim",
        -- dir = "~/stuff/code/nvim/leun.nvim",
        lazy = false,
        name = "leun",
        dependencies = { "rktjmp/lush.nvim" },
        config = function()
            local leun = require("leun")

            leun.setup({
                flavour = "beetroot",
                -- flavour = "palegarden",
                user_flavours = {
                    palegarden = { color1 = "#dfb5d6", color2 = "#7c5868", },
                    cola       = { color2 = "#11c7fc", color1 = "#f50c0b", },
                    raphael    = { color2 = "#f67720", color1 = "#02843a", },
                    redcabbage = { color2 = "#4cb99e", color1 = "#c01c52", },

                    pink       = { color2 = "#ec84d4", color1 = "#96a2bd", },
                    test       = { color2 = "#4b588c", color1 = "#ed0790", },
                    test2      = { color2 = "#ed0790", color1 = "#4b588c", },
                    warn       = { color2 = "#e1f63f", color1 = "#af836c", },
                    ice        = { color1 = "#3e829f", color2 = "#5bede7", },
                    deep_blue  = { color2 = "#757ecb", color1 = "#2a2f5e", },
                    slime      = { color1 = "#e1ab67", color2 = "#5eee8e", },
                    purple     = { color1 = "#4e174d", color2 = "#b578dc", },
                    leaf       = { color1 = "#42ea8c", color2 = "#96e350", },
                    red_green  = { color1 = "#fb2f45", color2 = "#7a9c72", },
                    random1    = { color2 = "#fab5b8", color1 = "#ba50d8", },
                    random2    = { color1 = "#4437da", color2 = "#07e1ab", },
                    random3    = { color2 = "#06b9ea", color1 = "#b148c3", },
                    random4    = { color1 = "#34ebbe", color2 = "#f7d455", },
                    verde      = { color1 = "#53ce6f", color2 = "#52db6a", },
                    p          = { color1 = "#4f2653", color2 = "#aec6c8", },
                },
                mark_list = {
                    "palegarden", "redcabbage", "cola", "beetroot",
                    "lime", "red", "raphael",
                },
            })
            -- TODO: add :hi NormalFloat guibg=NONE
            -- TODO: test this flavours and commit new update

            -- leun.random()
            leun.load()

            -- [optional]
            -- change flav. using the mark list
            local mappings = require("mappings")
            mappings.map2("n", "<leader><up>", leun.prev_mark, {})
            mappings.map2("n", "<leader><down>", leun.next_mark, {})
            mappings.map2("n", "<leader><right>", leun.random, {})
            mappings.map2("n", "<leader><left>", leun.get_palette, {})

            -- extra highlight for the CursorLine
            vim.cmd("autocmd InsertEnter * highlight CursorLine guibg=#181818")
            vim.cmd("autocmd InsertLeave * highlight CursorLine guibg=#121212")
        end,
    }
}
