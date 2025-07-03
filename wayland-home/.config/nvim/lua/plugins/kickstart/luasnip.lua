-- LuaSnip
return {
  "L3MON4D3/LuaSnip",
  version = "2.*",
  build = (function()
    if vim.fn.has "win32" == 1 or vim.fn.executable "make" == 0 then
      return
    end
    return "make install_jsregexp"
  end)(),
  dependencies = {
    {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
  },
  opts = {
    -- Optional: you can enable autosnippets and other globals here
    enable_autosnippets = true,
    update_events = "TextChanged,TextChangedI",
  },
  config = function(_, opts)
    require("luasnip").config.set_config(opts)

    -- Optional: load from `~/.config/nvim/snippets` if you use custom Lua snippets
    require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/snippets" })
  end,
}
