-- Get tabs lol
return {
  'akinsho/bufferline.nvim',
  version = "*", -- optional: can specify a version or tag
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require("bufferline").setup({
      options = {
        mode = "tabs",
        numbers = "none",
        diagnostics = "nvim_lsp",
        close_command = "bdelete! %d",
        right_mouse_command = "bdelete! %d",
        left_mouse_command = "buffer %d",
        middle_mouse_command = nil,
        buffer_close_icon = "",
        modified_icon = "●",
        close_icon = "",
        show_close_icon = false,
        show_buffer_close_icons = false,
        show_tab_indicators = true,
        always_show_bufferline = true,
        separator_style = "slope", -- "thin" | "thick" | "slant"
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            highlight = "Directory",
            separator = true
          }
        },
      }
    })
  end
}

