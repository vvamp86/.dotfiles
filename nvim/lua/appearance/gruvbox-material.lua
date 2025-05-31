return {
  'sainnhe/gruvbox-material',
  lazy = false,
  priority = 1000,
  config = function()
    vim.g.gruvbox_material_background = 'hard'
    vim.g.gruvbox_material_foreground = 'original'
    vim.g.gruvbox_material_enable_italic = true
    vim.g.gruvbox_material_ui_contrast = 'high' -- optional, for sharper splits/borders

    -- Detect if in GUI (like Neovide) or terminal
    if vim.fn.has 'gui_running' == 1 or vim.g.neovide or vim.g.gonvim_running then
      -- GUI-specific settings
      vim.g.gruvbox_material_transparent_background = 1
    else
      -- Terminal-specific settings
      vim.g.gruvbox_material_transparent_background = 0
    end
    vim.cmd.colorscheme 'gruvbox-material'
  end,
}
