local M = {}

-- Default config
M.config = {
    draft_path   = vim.fn.stdpath("data") .. "/draft.md",
    draft_ft     = "markdown",

    scratch_head = nil,
    scratch_name = "[scratch]",
    scratch_ft   = "",
}

--- open draft file
--- opt = { ft?:string, path?:string }
---@param  opt table?
---@return integer buf
function M.open_draft(opt)
    opt = opt or {}
    local path = opt.path or M.config.draft_path
    local ft = opt.ft or M.config.draft_ft

    -- Ensure parent directory exists
    -- vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")

    -- Open the draft file
    vim.cmd("edit " .. vim.fn.fnameescape(path))
    vim.cmd("set ft=" .. ft)
    return vim.api.nvim_get_current_buf()
end

--- open unlisted scratch buff
--- opt = { ft?:string, name?:string, head?:string[] }
---@param  opt table?
---@return integer buf
function M.open_scratch(opt)
    opt = opt or {}
    local name = opt.name or M.config.scratch_name
    local ft = opt.ft or M.config.scratch_ft

    -- try to find existing buffer
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buf) then
            local tail = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
            if tail == name then
                vim.api.nvim_set_current_buf(buf)
                return buf
            end
        end
    end

    -- open
    local buf = vim.api.nvim_create_buf(true, true)
    vim.bo[buf].filetype = ft
    vim.bo[buf].bufhidden = "wipe"
    vim.api.nvim_buf_set_name(buf, name)

    vim.api.nvim_set_current_buf(buf)

    -- head
    local head = opt.head or M.config.scratch_head
    if head and vim.api.nvim_buf_line_count(buf) == 1 then
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, head)
        vim.api.nvim_win_set_cursor(0, { #head, 0 })
    end

    return buf
end

function M.setup(opts)
    M.config = vim.tbl_extend("force", M.config, opts or {})
end

return M
