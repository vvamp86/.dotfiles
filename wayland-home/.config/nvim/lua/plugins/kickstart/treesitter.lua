return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    branch = 'master',
    lazy = false,
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
        'latex', -- add LaTeX here once working
      },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    config = function(_, opts)
      -- Add custom parser for LaTeX
      -- local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      -- parser_config.latex = {
        -- install_info = {
          -- url = "https://github.com/latex-lsp/tree-sitter-latex",
          -- files = { "src/parser.c" },
          -- generate = true, -- <— generate parser.c from grammar.js
          -- branch = "main",
        -- },
        -- filetype = "tex",
      -- }

      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}

