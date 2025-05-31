-- Import vimtex.nvim
return {
  'lervag/vimtex',
  ft = 'tex', -- Lazy load
  keys = { -- Load only when these keys are pressed
    { '<leader>ll', '<cmd>VimtexCompile<cr>', desc = 'Compile LaTeX' },
    { '<leader>lv', '<cmd>VimtexView<cr>', desc = 'View PDF' },
  },
  init = function()
    -- VimTeX configuration goes here, e.g.
    vim.g.vimtex_view_method = 'zathura'
    vim.g.vimtex_compiler_latexmk = {
      continuous = 1, -- Auto-recompile
      build_dir = '~/Downloads', -- Store output in Downloads
    }
  end,
}
