-- Use vimtex to conceal LaTeX in obsidian.md
return {
  'lervag/vimtex',
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
}
