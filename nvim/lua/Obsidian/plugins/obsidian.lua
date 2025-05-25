-- Import obsidian.nvim
return {
  'epwalsh/obsidian.nvim',
  version = '*',
  lazy = true,
  ft = 'markdown', -- load only for markdown files
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  opts = {
    workspaces = {
      {
        name = 'notes',
        path = '',
      },
    },
    completion = {
      nvim_cmp = true,
      min_chars = 2,
    },
  },
}
