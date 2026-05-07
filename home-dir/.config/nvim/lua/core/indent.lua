local function augroup(name)
  return vim.api.nvim_create_augroup("lazynvim_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd('TextYankPost', {
  group = augroup('kickstart-highlight-yank'),
  desc = 'Highlight when yanking (copying) text',
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = augroup('md'),
  pattern = { 'md' },
  callback = function()
    vim.cmd 'SoftPencil'

    vim.opt.conceallevel = 0

    vim.opt.foldmethod = 'indent'
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = augroup('tex'),
  pattern = { 'tex' },
  callback = function()
    vim.opt.tabstop = 4
    vim.opt.softtabstop = 4
    vim.opt.shiftwidth = 4

    -- vim.g.vimtex_complete_close_braces = 1
    vim.g.vimtex_syntax_conceal_disable = 1

    vim.cmd 'SoftPencil'

    vim.opt.conceallevel = 0

    vim.opt.syntax = 'on'
    vim.opt.foldmethod = 'indent'
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = augroup('python'),
  pattern = { 'python' },
  callback = function()
    vim.opt.tabstop = 4
    vim.opt.softtabstop = 4
    vim.opt.shiftwidth = 4

    vim.cmd 'SoftPencil'

    vim.opt.syntax = 'on'
    vim.opt.foldmethod = 'indent'

    -- vim.opt_local.tabstop = 4
    -- vim.opt_local.softtabstop = 4
    -- vim.opt_local.shiftwidth = 4
    --
    -- vim.cmd 'SoftPencil'
    --
    -- vim.opt_local.syntax = 'on'
    -- vim.opt_local.foldmethod = 'indent'
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = augroup('c'),
  pattern = { 'c', 'h', 'cpp' },
  callback = function()
    vim.opt.tabstop = 4
    vim.opt.softtabstop = 4
    vim.opt.shiftwidth = 4

    vim.cmd 'SoftPencil'

    vim.opt.syntax = 'on'
    vim.opt.foldmethod = 'indent'
  end,
})
