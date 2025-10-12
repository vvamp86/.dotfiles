-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Auto Trailing Whitespace Remover
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  command = [[%s/\s\+$//e]],
})

-- expand tabs as spaces no matter what
vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufWritePre' }, {
  pattern = '*',
  callback = function()
    if vim.bo.modifiable and vim.bo.buftype == '' then
      vim.cmd 'retab'
    end
  end,
})

-- Autosave every 30 minutes (1800000 ms)
vim.fn.timer_start(1800000, function()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf)
        and vim.api.nvim_buf_get_option(buf, "modified") then
      vim.api.nvim_buf_call(buf, function()
        vim.cmd("silent! write")
        print("autosaved " .. vim.fn.expand("%:t"))
      end)
    end
  end
end, { ["repeat"] = -1 })

