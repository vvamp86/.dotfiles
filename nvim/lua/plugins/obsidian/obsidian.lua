-- Import obsidian.nvim
local vault_path = require('config.obsidian_local').vault_path

local function is_in_obsidian_vault()
  local buf_path = vim.fn.expand '%:p'
  return buf_path:find(vault_path) ~= nil
end

return {
  {
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
          path = vault_path,
        },
      },
      completion = {
        nvim_cmp = true,
        min_chars = 2,
      },
      wiki_link_func = "use_alias_only",
      templates = {
        folder = "Template",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
        -- A map for custom variables, the key should be the variable and the value a function
        substitutions = {},
      },

      picker = {
      -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
        name = "telescope.nvim",
        -- Optional, configure key mappings for the picker. These are the defaults.
        -- Not all pickers support all mappings.
        note_mappings = {
          -- Create a new note from your query.
          new = "<C-x>",
          -- Insert a link to the selected note.
          insert_link = "<C-l>",
        },
        tag_mappings = {
          -- Add tag(s) to current note.
          tag_note = "<C-x>",
          -- Insert a tag at the current location.
          insert_tag = "<C-l>",
        },
      },
      ui = {
        enable = true, -- set to false to disable all additional syntax features
        update_debounce = 200, -- update delay after a text change (in milliseconds)
        max_file_length = 5000, -- disable UI features for files with more than this many lines
        -- Define how various check-boxes are displayed
        checkboxes = {
          -- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
          [' '] = { char = '󰄱', hl_group = 'ObsidianTodo' },
          ['x'] = { char = '', hl_group = 'ObsidianDone' },
          ['>'] = { char = '', hl_group = 'ObsidianRightArrow' },
          ['~'] = { char = '󰰱', hl_group = 'ObsidianTilde' },
          ['!'] = { char = '', hl_group = 'ObsidianImportant' },
          -- Replace the above with this if you don't have a patched font:
          -- [" "] = { char = "☐", hl_group = "ObsidianTodo" },
          -- ["x"] = { char = "✔", hl_group = "ObsidianDone" },
          -- You can also add more custom ones...
        },
        -- Use bullet marks for non-checkbox lists.
        bullets = { char = '•', hl_group = 'ObsidianBullet' },
        external_link_icon = { char = '', hl_group = 'ObsidianExtLinkIcon' },
        -- Replace the above with this if you don't have a patched font:
        -- external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
        reference_text = { hl_group = 'ObsidianRefText' },
        highlight_text = { hl_group = 'ObsidianHighlightText' },
        tags = { hl_group = 'ObsidianTag' },
        block_ids = { hl_group = 'ObsidianBlockID' },
        hl_groups = {
          -- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
          ObsidianTodo = { bold = true, fg = '#e78a4e' },
          ObsidianDone = { bold = true, fg = '#7daea3' },
          ObsidianRightArrow = { bold = true, fg = '#e78a4e' },
          ObsidianTilde = { bold = true, fg = '#472322' },
          ObsidianImportant = { bold = true, fg = '#ea6962' },
          ObsidianBullet = { bold = true, fg = '#7daea3' },
          ObsidianRefText = { underline = true, fg = '#d3869b' },
          ObsidianExtLinkIcon = { fg = '#d3869b' },
          ObsidianTag = { italic = true, fg = '#7daea3' },
          ObsidianBlockID = { italic = true, fg = '#7daea3' },
          ObsidianHighlightText = { bg = '#75662e' },
        },
      },
    },

    },
    config = function()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'markdown',
        callback = function()
          vim.wo.conceallevel = 2
        end,
      })
    end,
  {
    'lervag/vimtex',
    cond = is_in_obsidian_vault,
    ft = 'md', -- Load only for Markdown files
    init = function()
      -- Disable all VimTeX features except conceal
      vim.g.vimtex_compiler_enabled = 0
      vim.g.vimtex_indent_enabled = 0
      vim.g.vimtex_imaps_enabled = 0
      vim.g.vimtex_mappings_enabled = 0
      vim.g.vimtex_text_obj_enabled = 0
      vim.g.vimtex_motion_enabled = 0
      vim.g.vimtex_fold_enabled = 0
      vim.g.vimtex_quickfix_enabled = 0
      vim.g.vimtex_format_enabled = 0
      vim.g.vimtex_doc_enabled = 0
      vim.g.vimtex_view_enabled = 0
      vim.g.vimtex_toc_enabled = 0
      vim.g.vimtex_complete_enabled = 0

      -- Enable only conceal
      vim.g.vimtex_enabled = 1
      vim.g.vimtex_syntax_enabled = 1
      vim.g.vimtex_syntax_conceal = {
        accents = 1,
        ligatures = 1,
        greek = 1,
        math_bounds = 1,
        math_delimiters = 1,
        math_fracs = 1,
        math_super_sub = 1,
        math_symbols = 1,
        styles = 1,
      }
    end,
    config = function()
      vim.wo.conceallevel = 2
    end,
  },
}
