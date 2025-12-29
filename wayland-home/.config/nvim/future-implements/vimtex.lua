--Additional Settings Possible

    -- Indentation settings
    vim.g.vimtex_indent_enabled = false            -- Disable auto-indent from Vimtex
    vim.g.tex_indent_items = false                 -- Disable indent for enumerate
    vim.g.tex_indent_brace = false                 -- Disable brace indent

    -- Suppression settings
    vim.g.vimtex_quickfix_mode = 0                 -- Suppress quickfix on save/build
    vim.g.vimtex_log_ignore = {                    -- Suppress specific log messages
      'Underfull',
      'Overfull',
      'specifier changed to',
      'Token not allowed in a PDF string',
    }

    -- Other settings
    vim.g.vimtex_mappings_enabled = false          -- Disable default mappings
    vim.g.tex_flavor = 'latex'                     -- Set file type for TeX files
  end,

------------------------------------------------------------
local auto_save_enabled = false
local auto_save_timer = nil

function _G.toggle_auto_save()
    if auto_save_enabled then
        if auto_save_timer then
            auto_save_timer:close()
            auto_save_timer = nil
        end
        print("Auto-save disabled")
    else
        auto_save_timer = vim.loop.new_timer()
        auto_save_timer:start(0, 60000, vim.schedule_wrap(function()
            if vim.bo.modified then
                vim.cmd("write")
                print("Auto-saved at " .. os.date("%H:%M:%S"))
            end
        end))
        print("Auto-save enabled (every 60s)")
    end
    auto_save_enabled = not auto_save_enabled
end

-- Map to a key, e.g., <leader>as
vim.keymap.set("n", "<leader>as", "<cmd>lua toggle_auto_save()<CR>", {noremap = true, silent = true})

---------------------------------------------------
-- Use Tab to jump through placeholders in LaTeX
vim.api.nvim_create_autocmd("FileType", {
  pattern = "tex",
  callback = function()
    vim.keymap.set("i", "<Tab>", function()
      return vim.fn["vimtex#imaps#jump"](1) and "" or "<Tab>"
    end, {expr = true, buffer = true})
  end
})

---------------------------------------------------
vim.g.vimtex_imaps_list = {
  -- Fractions with placeholders
  { lhs = "ff", rhs = [[\frac{$1}{$2}]], wrapper = "vimtex#imaps#wrap_math" },

  -- Square root with placeholder
  { lhs = "sq", rhs = [[\sqrt{$1}]], wrapper = "vimtex#imaps#wrap_math" },

  -- Sum with placeholders
  { lhs = "sum", rhs = [[\sum_{$1}^{$2}]], wrapper = "vimtex#imaps#wrap_math" },

  -- Integral with placeholders
  { lhs = "int", rhs = [[\int_{$1}^{$2}]], wrapper = "vimtex#imaps#wrap_math" },

  -- Text formatting with placeholders
  { lhs = "bf", rhs = [[\textbf{$1}]], wrapper = "vimtex#imaps#wrap_environment" },

  -- Environment with multiple placeholders
  { lhs = "ali", rhs = [[\begin{align}$1\end{align}$2]], wrapper = "vimtex#imaps#wrap_environment" },
}
