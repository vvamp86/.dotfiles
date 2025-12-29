return { local M = {}

-- Create augroup
local augroup = vim.api.nvim_create_augroup("AutoSave", { clear = true })

-- Store timers in buffer-local variable
vim.b.autosave_timers = vim.b.autosave_timers or {}

-- Function to start auto-save for current buffer
function M.start_auto_save()
    local bufnr = vim.api.nvim_get_current_buf()
    local filename = vim.fn.expand("%:t")

    print("Starting auto-save for buffer: " .. bufnr .. " - " .. filename)

    -- Clear existing timer for this buffer
    if vim.b.autosave_timers[bufnr] then
        vim.b.autosave_timers[bufnr]:stop()
        vim.b.autosave_timers[bufnr] = nil
        print("Cleared existing timer for buffer: " .. bufnr)
    end

    -- Create new timer
    local timer = vim.loop.new_timer()
    vim.b.autosave_timers[bufnr] = timer

    timer:start(30000, 30000, vim.schedule_wrap(function()
        if vim.api.nvim_buf_is_valid(bufnr) and vim.bo.modified and not vim.bo.readonly then
            print("Auto-saving buffer: " .. bufnr)
            vim.cmd("silent! update")
            vim.notify("Auto-saved " .. filename, vim.log.levels.INFO, { title = "AutoSave" })
        end
    end))

    vim.notify("Auto-save enabled for " .. filename, vim.log.levels.INFO, { title = "AutoSave" })
    print("Auto-save timer started for buffer: " .. bufnr)
end

-- Function to stop auto-save for current buffer
function M.stop_auto_save()
    local bufnr = vim.api.nvim_get_current_buf()
    local filename = vim.fn.expand("%:t")

    print("Stopping auto-save for buffer: " .. bufnr)

    if vim.b.autosave_timers[bufnr] then
        vim.b.autosave_timers[bufnr]:stop()
        vim.b.autosave_timers[bufnr] = nil
        vim.notify("Auto-save disabled for " .. filename, vim.log.levels.INFO, { title = "AutoSave" })
        print("Auto-save stopped for buffer: " .. bufnr)
    else
        vim.notify("Auto-save was not enabled for " .. filename, vim.log.levels.WARN, { title = "AutoSave" })
        print("No active timer found for buffer: " .. bufnr)
    end
end

-- Function to toggle auto-save
function M.toggle_auto_save()
    local bufnr = vim.api.nvim_get_current_buf()
    if vim.b.autosave_timers[bufnr] then
        M.stop_auto_save()
    else
        M.start_auto_save()
    end
end

-- Auto-enable for .tex files on buffer enter
vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
    group = augroup,
    pattern = "*.tex",
    callback = function(args)
        local bufnr = args.buf
        local filename = vim.fn.expand("%:t")
        print("TeX file detected: " .. filename .. " (buffer: " .. bufnr .. ")")

        if not vim.b.autosave_timers[bufnr] then
            print("Starting auto-save for TeX file")
            M.start_auto_save()
        else
            print("Auto-save already running for this buffer")
        end
    end,
})

-- Clean up timers when buffers are wiped out
vim.api.nvim_create_autocmd("BufWipeout", {
    group = augroup,
    callback = function(args)
        local bufnr = args.buf
        if vim.b.autosave_timers and vim.b.autosave_timers[bufnr] then
            print("Cleaning up timer for wiped buffer: " .. bufnr)
            vim.b.autosave_timers[bufnr]:stop()
            vim.b.autosave_timers[bufnr] = nil
        end
    end,
})

-- Set up commands for easy toggling
vim.api.nvim_create_user_command("AutoSaveEnable", function()
    M.start_auto_save()
end, { desc = "Enable auto-save for current buffer" })

vim.api.nvim_create_user_command("AutoSaveDisable", function()
    M.stop_auto_save()
end, { desc = "Disable auto-save for current buffer" })

vim.api.nvim_create_user_command("AutoSaveToggle", function()
    M.toggle_auto_save()
end, { desc = "Toggle auto-save for current buffer" })

vim.api.nvim_create_user_command("AutoSaveStatus", function()
    local bufnr = vim.api.nvim_get_current_buf()
    if vim.b.autosave_timers[bufnr] then
        print("Auto-save: ENABLED for buffer " .. bufnr)
        vim.notify("Auto-save: ENABLED", vim.log.levels.INFO)
    else
        print("Auto-save: DISABLED for buffer " .. bufnr)
        vim.notify("Auto-save: DISABLED", vim.log.levels.WARN)
    end
end, { desc = "Check auto-save status" })

-- Key mappings for easy access (optional)
vim.keymap.set('n', '<leader>as', M.toggle_auto_save, { desc = 'Toggle auto-save' })
vim.keymap.set('n', '<leader>ae', M.start_auto_save, { desc = 'Enable auto-save' })
vim.keymap.set('n', '<leader>ad', M.stop_auto_save, { desc = 'Disable auto-save' })
vim.keymap.set('n', '<leader>ast', '<cmd>AutoSaveStatus<CR>', { desc = 'Auto-save status' })

print("Auto-save module loaded successfully!")

return M
}
