return {
  'NvChad/nvim-colorizer.lua',
  config = function()
    require('colorizer').setup {
      filetypes = { '*' }, -- Enable for all filetypes
      user_default_options = {
        RGB = true,
        RRGGBB = true,
        names = true,
        css = true,
        css_fn = true,
        mode = 'background', -- "foreground" or "virtualtext"
        tailwind = true,
      },
    }
  end,
}
