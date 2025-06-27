local M = {}

local function get_visual_selection()
  local _, csrow, cscol, _ = unpack(vim.fn.getpos("'<"))
  local _, cerow, cecol, _ = unpack(vim.fn.getpos("'>"))

  local lines = vim.fn.getline(csrow, cerow)
  if #lines == 0 then return '' end

  lines[#lines] = string.sub(lines[#lines], 1, cecol)
  lines[1] = string.sub(lines[1], cscol)

  return table.concat(lines, '\n')
end


-- Replace full lines, overwrite between visual marks
local function replace_selection(new_text)
  local _, csrow, cscol, _ = unpack(vim.fn.getpos("'<"))
  local _, cerow, cecol, _ = unpack(vim.fn.getpos("'>"))

  local lines = vim.split(new_text, '\n', {plain=true})

  -- Adjust indices for 0-based API:
  csrow, cerow = csrow - 1, cerow - 1
  cscol, cecol = cscol - 1, cecol - 1

  if #lines == 1 then
    -- Single line replacement: replace from cscol to cecol on csrow
    vim.api.nvim_buf_set_text(0, csrow, cscol, cerow, cecol, lines)
  else
    -- Multi-line replacement:

    -- Replace start line from cscol to end of line
    local first_line = lines[1]
    vim.api.nvim_buf_set_text(0, csrow, cscol, csrow, -1, {first_line})

    -- Replace full middle lines if any
    if cerow - csrow > 1 then
      local mid_lines = {}
      for i = 2, #lines - 1 do
        table.insert(mid_lines, lines[i])
      end
      if #mid_lines > 0 then
        vim.api.nvim_buf_set_lines(0, csrow + 1, cerow, false, mid_lines)
      end
    end

    -- Replace last line from start to cecol
    local last_line = lines[#lines]
    vim.api.nvim_buf_set_text(0, cerow, 0, cerow, cecol, {last_line})
  end
end


local function run_python_conversion(code_template, text)
  -- Escape Lua → Python safely by writing to a temp file
  local tmpfile = os.tmpname()
  local f = io.open(tmpfile, "w")
  f:write(text)
  f:close()

  local py_script = string.format([[
import re
from pylatexenc.latex2text import LatexNodes2Text
from pylatexenc.latexencode import unicode_to_latex

with open(%q, 'r') as f:
    text = f.read()

def convert_math(text):
    def replace_inline(match):
        opener = match.group(1)
        content = match.group(2)
        closer = match.group(3)
        try:
            result = %s
        except Exception as e:
            result = content
        return opener + result + closer

    pattern = r'(?<!\\)(\${1,2})(.*?)(?<!\\)(\1)'
    return re.sub(pattern, replace_inline, text, flags=re.DOTALL)

print(convert_math(text))
  ]], tmpfile, code_template)

  local result = vim.system({ "python3", "-c", py_script }, { text = true }):wait()

  os.remove(tmpfile)

  if result.code == 0 then
    return result.stdout:gsub('\n$', '')
  else
    vim.notify("Python error:\n" .. result.stderr, vim.log.levels.ERROR)
    return text
  end
end

function M.latex_to_unicode()
  local input = get_visual_selection()
  if input == '' then return end
  local output = run_python_conversion("LatexNodes2Text().latex_to_text(content)", input)
  replace_selection(output)
end

function M.unicode_to_latex()
  local input = get_visual_selection()
  if input == '' then return end
  local output = run_python_conversion("unicode_to_latex(content)", input)
  replace_selection(output)
end

return M
