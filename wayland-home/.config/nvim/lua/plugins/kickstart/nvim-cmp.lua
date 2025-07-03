-- cmp setup
return {
  'NMAC427/guess-indent.nvim', -- guesses indent length
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {},
  },
  { -- add cmp
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
      'saadparwaiz1/cmp_luasnip',
      'L3MON4D3/LuaSnip',
      'rafamadriz/friendly-snippets',
      'folke/lazydev.nvim',
    },
    --- @module 'nvim-cmp'
    --- @type nvim-cmp.Config
    opts = function()
      local cmp = require("cmp")
      return {
        mapping = {
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { 'i', 's' }),

          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { 'i', 's' }),

          ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
          }),
        },

        sources = {
          default = {
            { name = 'nvim_lsp' },
            { name = 'path', option = { label_trailing_slash = true } },
            { name = 'snippets' },
            { name = 'lazydev' },
            { name = 'obsidian' },
          },
          providers = {
            lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
          },
        },

        snippets = { preset = 'luasnip' },

        appearance = {
          nerd_font_variant = 'mono',
        },

        completion = {
          documentation = { auto_show = false, auto_show_delay_ms = 500 },
        },

        fuzzy = { implementation = 'lua' },

        signature = { enabled = true },
      }
    end,
  },
}
