
--[[
cool shell
+-------------------------------------------+
| $ cmd                                     |
+-------------------------------------------+
| output                                    |
| output                                    |
| output                                    |
| output                                    |
| output                                    |
| output                                    |
+-------------------------------------------+

TODO: command history (just undoo history), run preview
BUG: adds one extra empty line at the end
BUG: pipe in doesn't work
BUG: on open focus and insert mode
--]]

local M = {}

local state = nil

local function create_buffer()
    local buf = vim.api.nvim_create_buf(false, true)
    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].swapfile = false
    return buf
end

local function resize()
    if not state or not state.cmd.win or not vim.api.nvim_win_is_valid(state.cmd.win) then
        return
    end

    local line_count = vim.api.nvim_buf_line_count(state.cmd.buf)
    local height = math.max(1, line_count)

    vim.api.nvim_win_set_height(state.cmd.win, height)
end

function M.clear(buf)
    if not state or not state.cmd.win or not vim.api.nvim_win_is_valid(state.cmd.win) then
        return
    end
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "" })
end

function M.close()
    if state.cmd.win and vim.api.nvim_win_is_valid(state.cmd.win) then
        vim.api.nvim_win_close(state.cmd.win, true)
    end
    if state.out.win and vim.api.nvim_win_is_valid(state.out.win) then
        vim.api.nvim_win_close(state.out.win, true)
    end

    state = nil
end

local function set_keymaps()
    vim.keymap.set("n", "<leader><CR>", function()
        M.run()
    end, { buffer = state.cmd.buf })
    vim.keymap.set("n", "<C-q>", function()
        M.close()
    end, { buffer = state.cmd.buf })
    vim.keymap.set("n", "<C-l>", function()
        M.clear(state.cmd.buf)
    end, { buffer = state.cmd.buf })
end

local function run_system(cmd, input, callback)
    vim.system(
        { "sh", "-c", cmd },
        { stdin = input },
        function(obj)
            vim.schedule(function()
                callback(obj.stdout or obj.stderr or "")
            end)
        end
    )
end

function M.run()
    if not state or not state.cmd.win or not vim.api.nvim_win_is_valid(state.cmd.win) then
        return
    end

    local lines = vim.api.nvim_buf_get_lines(state.cmd.buf, 0, -1, false)
    local cmd = table.concat(lines, "\n")

    if cmd == "" then
        return
    end

    local mode = "replace"

    if cmd:sub(1,1) == "|" then
        mode = "pipe"
        cmd = cmd:sub(2)
    elseif cmd:sub(1,1) == ">" then
        mode = "append"
        cmd = cmd:sub(2)
    end

    local function handle_output(output)
        local split = vim.split(output, "\n", { plain = true })

        if mode == "pipe" then
            vim.api.nvim_buf_set_lines(state.out.buf, 0, -1, false, split)
        elseif mode == "append" then
            vim.api.nvim_buf_set_lines(state.out.buf, -1, -1, false, split)
        else -- replace
            vim.api.nvim_buf_set_lines(state.out.buf, 0, -1, false, split)
        end
    end


    if mode == "pipe" then
        local input = table.concat(
            vim.api.nvim_buf_get_lines(state.out.buf, 0, -1, false),
            "\n"
        )
        run_system(cmd, input, handle_output)
    else
        run_system(cmd, nil, handle_output)
    end

    M.clear(state.cmd.buf)
    resize()
end

function M.open()
    if state then M.close() end
    state = {
        cmd = {},
        out = {},
    }

    state.cmd.buf = create_buffer()
    state.out.buf = create_buffer()

    vim.cmd("vsplit")
    state.out.win = vim.api.nvim_get_current_win()

    vim.cmd("aboveleft split")
    state.cmd.win = vim.api.nvim_get_current_win()

    vim.api.nvim_win_set_buf(state.cmd.win, state.cmd.buf)
    vim.api.nvim_win_set_buf(state.out.win, state.out.buf)

    -- conf
    local co = vim.bo[state.cmd.buf]
    local cw = vim.wo[state.cmd.win]
    co.filetype         = "bash"
    cw.number           = true
    cw.colorcolumn      = "0"
    cw.numberwidth      = 4

    local oo = vim.bo[state.out.buf]
    local ow = vim.wo[state.out.win]
    ow.number           = true
    ow.colorcolumn      = "0"
    ow.numberwidth      = 4


    set_keymaps()

    vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
        buffer = state.cmd.buf,
        callback = resize,
    })

    resize()
end


function M.setup(opt)
    vim.api.nvim_create_user_command("CoolShell", function()
        M.open()
    end, {})
    vim.keymap.set("n", "<leader><CR>", function()
        M.close()
        M.open()
    end)
end

return M

