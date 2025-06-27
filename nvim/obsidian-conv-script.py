import re
import json

# Paste your snippet list as a JSON array (remove comments or handle them)
snippet_data = [
    # ... paste your snippet dicts here without comments ...
]

def escape_lua_str(s):
    # Escape backslashes and double quotes for Lua string literals
    return s.replace("\\", "\\\\").replace('"', '\\"')

def parse_placeholder(m):
    # Extract index and default text
    idx = int(m.group(1))
    default = m.group(2)
    if default:
        return f'i({idx+1}, "{default}")'
    else:
        return f'i({idx+1})'

def convert_replacement(rep):
    # Replace placeholders like $0, $1, ${1:default} with LuaSnip insert nodes
    # Handle ${VISUAL} as a dynamic node that inserts selected text or placeholder
    rep = rep.replace("${VISUAL}", 'snip.env.TM_SELECTED_TEXT or ""')

    # Pattern for ${index:default} or $index
    pattern = re.compile(r"\$\{(\d+):([^}]+)\}|\$(\d+)")

    parts = []
    last_pos = 0

    for m in pattern.finditer(rep):
        start, end = m.span()
        # Text before placeholder
        text_part = rep[last_pos:start]
        if text_part:
            text_part = escape_lua_str(text_part)
            if "\n" in text_part:
                lines = text_part.split("\\n")
                for i, line in enumerate(lines):
                    # Keep line breaks as separate text nodes
                    if i > 0:
                        parts.append('t({"", ""})')
                    if line:
                        parts.append(f't("{line}")')
            else:
                parts.append(f't("{text_part}")')

        if m.group(1):  # ${index:default}
            idx = int(m.group(1))
            default = m.group(2)
            parts.append(f'i({idx+1}, "{default}")')
        else:  # $index
            idx = int(m.group(3))
            parts.append(f'i({idx+1})')

        last_pos = end

    # Remaining text
    text_part = rep[last_pos:]
    if text_part:
        text_part = escape_lua_str(text_part)
        if "\n" in text_part:
            lines = text_part.split("\\n")
            for i, line in enumerate(lines):
                if i > 0:
                    parts.append('t({"", ""})')
                if line:
                    parts.append(f't("{line}")')
        else:
            parts.append(f't("{text_part}")')

    return parts

def convert_trigger(trig):
    # Convert string triggers or regex triggers
    if isinstance(trig, str):
        if trig.startswith("/") and trig.endswith("/"):
            # regex trigger, remove slashes and return lua pattern string
            pattern = trig[1:-1]
            pattern = escape_lua_str(pattern)
            return f'regex("{pattern}")'
        else:
            return f'"{trig}"'
    else:
        return f'"{str(trig)}"'

def main(snippets):
    print("local ls = require('luasnip')")
    print("local s = ls.snippet")
    print("local t = ls.text_node")
    print("local i = ls.insert_node")
    print("local f = ls.function_node")
    print("local d = ls.dynamic_node")
    print("local snip = nil\n")
    print("return {")

    for snip in snippets:
        trig = snip.get("trigger")
        rep = snip.get("replacement")
        desc = snip.get("description", "")
        opts = snip.get("options", "")
        priority = snip.get("priority", None)

        # Skip function replacements (manual)
        if callable(rep):
            print(f"  -- Skipped snippet with JS function replacement: {trig}")
            continue

        trigger_lua = convert_trigger(trig)
        body_nodes = convert_replacement(rep)
        body_str = ", ".join(body_nodes)

        comment = f"-- {desc}" if desc else ""
        prio_str = f", priority = {priority}" if priority is not None else ""

        print(f"  s({trigger_lua}, {{ {body_str} }}){prio_str}, {comment}")

    print("}")
