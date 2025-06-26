-- Import obsidian.nvim
local vault_path = require('config.obsidian_local').vault_path

local function is_in_obsidian_vault()
  local buf_path = vim.fn.expand '%:p'
  return buf_path:find(vault_path) ~= nil
end

return {
  "lervag/vimtex",
  ft = { "tex", "markdown" },
  init = function()
    local is_obsidian = is_in_obsidian_vault or false
    local ft = vim.bo.filetype

    -- Obsidian Markdown config
    if is_obsidian and ft == "markdown" then
      vim.g.vimtex_enabled = 1
      vim.g.vimtex_syntax_enabled = 1
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

      vim.g.vimtex_syntax_conceal = {
        accents = 1,
        ligatures = 1,
        cites = 1,
        fancy = 1,
        greek = 1,
        math_bounds = 1,
        math_delimiters = 1,
        math_fracs = 1,
        math_super_sub = 1,
        math_symbols = 1,
        sections = 1,
        styles = 1,
      }

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          vim.wo.conceallevel = 2
          vim.wo.concealcursor = "nc"
        end,
      })
    end

    -- Regular LaTeX file config
    if ft == "tex" then
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_compiler_latexmk = {
        continuous = 1,
        build_dir = os.getenv("HOME") .. "/Downloads",
      }

      vim.g.vimtex_syntax_conceal = {
        accents = 1,
        ligatures = 1,
        cites = 1,
        fancy = 1,
        greek = 1,
        math_bounds = 1,
        math_delimiters = 1,
        math_fracs = 1,
        math_super_sub = 1,
        math_symbols = 1,
        sections = 1,
        styles = 1,
      }

      vim.opt.conceallevel = 2
      vim.opt.concealcursor = "nc"
    end
  end,
  keys = {
    { "<leader>ll", "<cmd>VimtexCompile<cr>", desc = "Compile LaTeX", ft = "tex" },
    { "<leader>lv", "<cmd>VimtexView<cr>", desc = "View PDF", ft = "tex" },
  },
}

