-- LAZY -----------------------------------------------------------------------
require("lazy_setup")

-- CONF -----------------------------------------------------------------------
require("settings")
local map = require("mappings")
require("autocmds")
local utils = require("utils")

require("myplugs.zenmode").setup()
require("myplugs.statusline")
local draft = require("myplugs.draft")
require("myplugs.shell").setup()

map.map2('n', '<leader>ed', draft.open_draft,
    { noremap = true, desc = "Open global draft file" })

map.map2('n', '<leader>eb', function()
    draft.open_scratch({ ft = "bash", name = "[scratch.bash]", head = { "#!/bin/bash", "" } })
end, { noremap = true, desc = "Open bash scratch buffer" })
map.map2('n', '<leader>es', function()
    draft.open_scratch({ ft = "sh", name = "[scratch.sh]", head = { "#!/bin/sh", "" } })
end, { noremap = true, desc = "Open bash scratch buffer" })
map.map2('n', '<leader>el', function()
    draft.open_scratch({ ft = "lua", name = "[scratch.lua]", head = { "#!/usr/bin/env lua", "" } })
end, { noremap = true, desc = "Open lua scratch buffer" })
map.map2('n', '<leader>em', function()
    draft.open_scratch({ ft = "markdown", name = "[scratch.md]", head = { "# scratch.md" } })
end, { noremap = true, desc = "Open markdown scratch buffer" })


-- UNLOAD ---------------------------------------------------------------------
-- https://github.com/letieu/nvim-config/blob/master/lua/options.lua
-- https://www.reddit.com/r/neovim/comments/opipij/guide_tips_and_tricks_to_reduce_startup_and/
-- disable some builtin vim plugins
local disabled_built_ins = {
    "2html_plugin",
    "bugreport",
    "compiler",
    "getscript",
    "getscriptPlugin",
    "gzip",
    "logipat",
    "matchit",
    -- "matchparen",
    -- "netrw",
    -- "netrwFileHandlers",
    -- "netrwPlugin",
    -- "netrwSettings",
    "optwin",
    "rplugin",
    "rrhelper",
    "spellfile_plugin",
    "sql_completion",
    "synmenu",
    "tar",
    "tarPlugin",
    "tutor",
    "tutor_mode_plugin",
    "vimball",
    "vimballPlugin",
    "zip",
    "zipPlugin",
    -- "ftplugin",
    -- "syntax",
}
for _, plugin in pairs(disabled_built_ins) do
    vim.g["loaded_" .. plugin] = 1
end

utils.unload("mappings")
utils.unload("autocmds")
