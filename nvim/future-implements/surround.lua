-- nvim-surround - Surround text with quotes, brackets, and more

return {
  "kylechui/nvim-surround",
  version = "*",  -- Use the latest stable release
  event = "VeryLazy",
  config = function()
    require("nvim-surround").setup({
      -- Configuration here (leave default for now)
      keymaps = {
        insert = "<C-g>s",
        insert_line = "<C-g>S",
        normal = "ys",
        normal_cur = "yss",
        normal_line = "yS",
        normal_cur_line = "ySS",
        visual = "S",
        visual_line = "gS",
        delete = "ds",
        change = "cs",
      },

      -- Configure LaTeX surroundings
      surrounds = {
        -- LaTeX specific surroundings
        ["E"] = {
          add = function()
            return { { "\\begin{" .. vim.fn.input("Environment: ") .. "}" }, { "\\end{" .. vim.fn.input("Environment: ") .. "}" } }
          end,
        },
        ["$"] = {
          add = { "$", "$" },
          find = "%$.-[^\\]%$",
          delete = "^(.)().-(.)()$"
        },
        ["i"] = {
          add = { "\\textit{", "}" },
        },
        ["b"] = {
          add = { "\\textbf{", "}" },
        },
        ["t"] = {
          add = { "\\texttt{", "}" },
        },
        ["u"] = {
          add = { "\\underline{", "}" },
        },
        ["q"] = {
          add = { "``", "''" },  -- LaTeX quotes
        },
        ["Q"] = {
          add = { "`", "'" },    -- LaTeX single quotes
        },
      },

      -- Aliases configure alternative names for surrounds
      aliases = {
        ["b"] = { ")", "]", "}", ">", "〉", "」", "』", "〕", "】", "〗", "〙", "〛", "❯" },
        ["q"] = { "'", '"', "`" },
      },
    })
  end,
}
