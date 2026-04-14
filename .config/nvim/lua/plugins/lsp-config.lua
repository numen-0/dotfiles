-- return {}
return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            { "mason-org/mason.nvim",              opts = {} },
            { "williamboman/mason-lspconfig.nvim", opts = {} },
        },
        config = function()
            -- local lspconfig = require("lspconfig")
            local lsp = vim.lsp
            local util = require("lspconfig.util")

            local capabilities = nil
            if pcall(require, "cmp_nvim_lsp") then
                capabilities = require("cmp_nvim_lsp").default_capabilities()
            end

            local servers = {
                jdtls = true,
                pyright = true,
                biome = true,
                cssls = true,
                html = true,
                luals = {
                    capabilities = {
                        offsetEncoding = "utf-8",
                    },
                    root_dir = util.root_pattern(".git", ".todo", "bob"),
                },
                bashls = {
                    root_dir = util.root_pattern(".git", ".todo", "bob"),
                },
                clangd = {
                    cmd = {
                        "clangd",
                        "--background-index",
                        "--pch-storage=memory",
                        "--clang-tidy",
                        "--suggest-missing-includes",
                        "--cross-file-rename",
                        "--completion-style=detailed",
                    },
                    init_options = {
                        clangdFileStatus = true,
                        usePlaceholders = true,
                        completeUnimported = true,
                        semanticHighlighting = true,
                    },
                    -- filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
                    filetypes = { "c" },
                    single_file_support = false,
                    root_dir = util.root_pattern(
                        '.clangd',
                        '.clang-tidy',
                        '.clang-format',
                        'compile_commands.json',
                        'compile_flags.txt',
                        'configure.ac',
                        '.git',
                        'bob'
                    ),
                    capabilities = {
                        textDocument = {
                            completion = {
                                editsNearCursor = true,
                            },
                        },
                        offsetEncoding = "utf-8",
                    },
                },
            }

            servers.clangd = nil -- deactivate cland

            -- require("mason-lspconfig").setup({ ensure_installed = vim.tbl_keys(servers) })

            for name, config in pairs(servers) do
                if config == true then config = {} end
                if config == nil then goto continue end
                config = vim.tbl_deep_extend("force", {}, {
                    capabilities = capabilities,
                }, config)

                lsp.config[name] = config
                lsp.enable(name)
                -- lsp[name].setup(config)
                :: continue ::
            end

            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = function(ev)
                    -- -- Enable completion triggered by <c-x><c-o>
                    -- vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

                    -- local kset = vim.keymap.set
                    local kset = require("mappings").map2
                    local opts = { buffer = ev.buf }

                    kset('n', 'gD', lsp.buf.declaration, opts)
                    kset('n', 'gd', lsp.buf.definition, opts)
                    kset('n', 'K', lsp.buf.hover, opts)
                    kset('n', 'gi', lsp.buf.implementation, opts)
                    kset('n', '<C-k>', lsp.buf.signature_help, opts)
                    -- kset('n', '<space>wa', lsp.buf.add_workspace_folder, opts)
                    -- kset('n', '<space>wr', lsp.buf.remove_workspace_folder, opts)
                    -- kset('n', '<space>wl', function()
                    --     print(vim.inspect(lsp.buf.list_workspace_folders()))
                    -- end, opts)
                    kset('n', '<space>D', lsp.buf.type_definition, opts)
                    -- kset('n', '<space>rn', lsp.buf.rename, opts)
                    kset({ 'n', 'v' }, '<space>ca', lsp.buf.code_action, opts)
                    kset('n', 'gr', lsp.buf.references, opts)
                    kset('n', '<space>gf', function()
                        lsp.buf.format({ async = true })
                    end, opts)
                end,
            })

            vim.keymap.set("", "<leader>l", function()
                local config = vim.diagnostic.config() or {}
                if config.virtual_text then
                    vim.diagnostic.config { virtual_text = false, virtual_lines = true }
                else
                    vim.diagnostic.config { virtual_text = true, virtual_lines = false }
                end
            end, { desc = "Toggle lsp_lines" })
        end,
    },
}
