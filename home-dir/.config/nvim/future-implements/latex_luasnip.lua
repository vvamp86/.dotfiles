local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

-- Context condition functions
local function in_math()
    return vim.fn['vimtex#syntax#in_math']() == 1
end

local function in_comment()
    return vim.fn['vimtex#syntax#in_comment']() == 1
end

local function not_in_comment()
    return vim.fn['vimtex#syntax#in_comment']() == 0
end

-- Only mk and dm work outside math environments, everything else requires math
ls.add_snippets("tex", {
  -- ===== SNIPPETS THAT WORK EVERYWHERE (except comments) =====
  s({ trig = "mk", name = "Inline math", condition = not_in_comment }, {
    t("$"), i(1), t("$")
  }),
  s({ trig = "dm", name = "Display math", condition = not_in_comment }, {
    t("$$\n"), i(1), t("\n$$")
  }),
  s({ trig = "beg", name = "Begin environment", condition = not_in_comment }, {
    t("\\begin{"), i(1), t("}\n"),
    i(2), t("\n\\end{"), rep(1), t("}")
  }),

  -- ===== SNIPPETS THAT REQUIRE MATH ENVIRONMENT =====
  -- Greek letters
  s({ trig = "@a", name = "Alpha", condition = in_math }, t("\\alpha")),
  s({ trig = "@b", name = "Beta", condition = in_math }, t("\\beta")),
  s({ trig = "@g", name = "Gamma", condition = in_math }, t("\\gamma")),
  s({ trig = "@G", name = "Capital Gamma", condition = in_math }, t("\\Gamma")),
  s({ trig = "@d", name = "Delta", condition = in_math }, t("\\delta")),
  s({ trig = "@D", name = "Capital Delta", condition = in_math }, t("\\Delta")),
  s({ trig = "@e", name = "Epsilon", condition = in_math }, t("\\epsilon")),
  s({ trig = ":e", name = "Varepsilon", condition = in_math }, t("\\varepsilon")),
  s({ trig = "@z", name = "Zeta", condition = in_math }, t("\\zeta")),
  s({ trig = "@t", name = "Theta", condition = in_math }, t("\\theta")),
  s({ trig = "@T", name = "Capital Theta", condition = in_math }, t("\\Theta")),
  s({ trig = ":t", name = "Vartheta", condition = in_math }, t("\\vartheta")),
  s({ trig = "@i", name = "Iota", condition = in_math }, t("\\iota")),
  s({ trig = "@k", name = "Kappa", condition = in_math }, t("\\kappa")),
  s({ trig = "@l", name = "Lambda", condition = in_math }, t("\\lambda")),
  s({ trig = "@L", name = "Capital Lambda", condition = in_math }, t("\\Lambda")),
  s({ trig = "@s", name = "Sigma", condition = in_math }, t("\\sigma")),
  s({ trig = "@S", name = "Capital Sigma", condition = in_math }, t("\\Sigma")),
  s({ trig = "@u", name = "Upsilon", condition = in_math }, t("\\upsilon")),
  s({ trig = "@U", name = "Capital Upsilon", condition = in_math }, t("\\Upsilon")),
  s({ trig = "@o", name = "Omega", condition = in_math }, t("\\omega")),
  s({ trig = "@O", name = "Capital Omega", condition = in_math }, t("\\Omega")),
  s({ trig = "ome", name = "Omega alt", condition = in_math }, t("\\omega")),
  s({ trig = "Ome", name = "Capital Omega alt", condition = in_math }, t("\\Omega")),

  -- Text environment (in math mode)
  s({ trig = "text", name = "Text in math", condition = in_math }, {
    t("\\text{"), i(1), t("}"), i(2)
  }),

  -- Basic operations
  s({ trig = "sr", name = "Square", condition = in_math }, t("^{2}")),
  s({ trig = "cb", name = "Cube", condition = in_math }, t("^{3}")),
  s({ trig = "rd", name = "Exponent", condition = in_math }, {
    t("^{"), i(1), t("}"), i(2)
  }),
  s({ trig = "_", name = "Subscript", condition = in_math }, {
    t("_{"), i(1), t("}"), i(2)
  }),
  s({ trig = "sts", name = "Text subscript", condition = in_math }, {
    t("_\\text{"), i(1), t("}")
  }),
  s({ trig = "sqrt", name = "Square root", condition = in_math }, {
    t("\\sqrt{ "), i(1), t(" }"), i(2)
  }),
  s({ trig = "squ", name = "Square", condition = in_math }, {
    t("\\square"), i(1)
  }),
  s({ trig = "ang", name = "Angle", condition = in_math }, {
    t("\\angle "), i(1)
  }),
  s({ trig = "//", name = "Fraction", condition = in_math }, {
    t("\\frac{"), i(1), t("}{"), i(2), t("}"), i(3)
  }),
  s({ trig = "ee", name = "Exponential", condition = in_math }, {
    t("e^{ "), i(1), t(" }"), i(2)
  }),
  s({ trig = "invs", name = "Inverse", condition = in_math }, t("^{-1}")),
  s({ trig = "conj", name = "Conjugate", condition = in_math }, t("^{*}")),

  -- Functions and operators
  s({ trig = "Re", name = "Real part", condition = in_math }, t("\\mathrm{Re}")),
  s({ trig = "Im", name = "Imaginary part", condition = in_math }, t("\\mathrm{Im}")),
  s({ trig = "bf", name = "Bold face", condition = in_math }, {
    t("\\mathbf{"), i(1), t("}")
  }),
  s({ trig = "rm", name = "Roman", condition = in_math }, {
    t("\\mathrm{"), i(1), t("}"), i(2)
  }),
  s({ trig = "bb", name = "Blackboard", condition = in_math }, {
    t("\\mathbb{"), i(1), t("}"), i(2)
  }),
  s({ trig = "cal", name = "Calligraphic", condition = in_math }, {
    t("\\mathcal{"), i(1), t("}"), i(2)
  }),
  s({ trig = "scr", name = "Script", condition = in_math }, {
    t("\\mathscr{"), i(1), t("}"), i(2)
  }),

  -- Symbols
  s({ trig = "ooo", name = "Infinity", condition = in_math }, t("\\infty")),
  s({ trig = "sum", name = "Sum", condition = in_math }, t("\\sum")),
  s({ trig = "prod", name = "Product", condition = in_math }, t("\\prod")),
  s({ trig = "lim", name = "Limit", condition = in_math }, {
    t("\\lim_{ "), i(1, "n"), t(" \\to "), i(2, "\\infty"), t(" } "), i(3)
  }),
  s({ trig = "-+", name = "Minus plus", condition = in_math }, t("\\mp")),
  s({ trig = "...", name = "Dots", condition = in_math }, t("\\dots")),
  s({ trig = "nabl", name = "Nabla", condition = in_math }, t("\\nabla")),
  s({ trig = "del", name = "Del", condition = in_math }, t("\\nabla")),
  s({ trig = "xx", name = "Times", condition = in_math }, t("\\times")),
  s({ trig = "**", name = "Cdot", condition = in_math }, t("\\cdot")),
  s({ trig = "para", name = "Parallel", condition = in_math }, t("\\parallel")),

  -- Relations
  s({ trig = "===", name = "Equivalent", condition = in_math }, t("\\equiv")),
  s({ trig = "!=", name = "Not equal", condition = in_math }, t("\\neq")),
  s({ trig = ">=", name = "Greater or equal", condition = in_math }, t("\\geq")),
  s({ trig = "<=", name = "Less or equal", condition = in_math }, t("\\leq")),
  s({ trig = ">>", name = "Much greater", condition = in_math }, t("\\gg")),
  s({ trig = "<<", name = "Much less", condition = in_math }, t("\\ll")),
  s({ trig = "+-", name = "Plus minus", condition = in_math }, t("\\pm")),
  s({ trig = "simm", name = "Similar", condition = in_math }, t("\\sim")),
  s({ trig = "sim=", name = "Approx equal", condition = in_math }, t("\\simeq")),
  s({ trig = "tri=", name = "Triangle equal", condition = in_math }, t("\\triangleq")),
  s({ trig = "prop", name = "Proportional", condition = in_math }, t("\\propto")),

  -- Arrows
  s({ trig = "<->", name = "Left-right arrow", condition = in_math }, t("\\leftrightarrow")),
  s({ trig = "->", name = "To", condition = in_math }, t("\\to")),
  s({ trig = "<-", name = "Gets", condition = in_math }, t("\\gets")),
  s({ trig = "!>", name = "Mapsto", condition = in_math }, t("\\mapsto")),
  s({ trig = "=>", name = "Implies", condition = in_math }, t("\\implies")),
  s({ trig = "=<", name = "Implied by", condition = in_math }, t("\\impliedby")),

  -- Set operations
  s({ trig = "and", name = "Intersection", condition = in_math }, t("\\cap")),
  s({ trig = "orr", name = "Union", condition = in_math }, t("\\cup")),
  s({ trig = "inn", name = "In", condition = in_math }, t("\\in")),
  s({ trig = "land", name = "Logical and", condition = in_math }, t("\\land")),
  s({ trig = "lor", name = "Logical or", condition = in_math }, t("\\lor")),
  s({ trig = "notin", name = "Not in", condition = in_math }, t("\\not\\in")),
  s({ trig = "\\\\\\", name = "Set minus", condition = in_math }, t("\\setminus")),
  s({ trig = "sub=", name = "Subset equal", condition = in_math }, t("\\subseteq")),
  s({ trig = "sup=", name = "Superset equal", condition = in_math }, t("\\supseteq")),
  s({ trig = "eset", name = "Empty set", condition = in_math }, t("\\emptyset")),
  s({ trig = "set", name = "Set", condition = in_math }, {
    t("\\{ "), i(1), t(" \\}"), i(2)
  }),

  -- Common sets
  s({ trig = "LL", name = "Lagrangian", condition = in_math }, t("\\mathcal{L}")),
  s({ trig = "HH", name = "Hamiltonian", condition = in_math }, t("\\mathcal{H}")),
  s({ trig = "CC", name = "Complex numbers", condition = in_math }, t("\\mathbb{C}")),
  s({ trig = "RR", name = "Real numbers", condition = in_math }, t("\\mathbb{R}")),
  s({ trig = "ZZ", name = "Integers", condition = in_math }, t("\\mathbb{Z}")),
  s({ trig = "NN", name = "Natural numbers", condition = in_math }, t("\\mathbb{N}")),
  s({ trig = "FF", name = "Field", condition = in_math }, t("\\mathbb{F}")),
  s({ trig = "PP", name = "Probability", condition = in_math }, t("\\mathbb{P}")),
  s({ trig = "EE", name = "Expectation", condition = in_math }, t("\\mathbb{E}")),
  s({ trig = "VV", name = "Variance", condition = in_math }, t("\\mathbb{V}")),
  s({ trig = "cov", name = "Covariance", condition = in_math }, t("\\mathbf{cov}")),
  s({ trig = "Corr", name = "Correlation", condition = in_math }, t("\\mathbf{Corr}")),
  s({ trig = "Pr", name = "Probability", condition = in_math }, t("\\Pr")),
  s({ trig = "Var", name = "Variance", condition = in_math }, t("\\mathbf{Var}")),
  s({ trig = "Bias", name = "Bias", condition = in_math }, t("\\mathbf{Bias}")),

  -- Accents
  s({ trig = "hat", name = "Hat", condition = in_math }, {
    t("\\hat{"), i(1), t("}"), i(2)
  }),
  s({ trig = "+hat", name = "Wide hat", condition = in_math }, {
    t("\\widehat{"), i(1), t("}"), i(2)
  }),
  s({ trig = "bar", name = "Bar", condition = in_math }, {
    t("\\bar{"), i(1), t("}"), i(2)
  }),
  s({ trig = "dot", name = "Dot", condition = in_math }, {
    t("\\dot{"), i(1), t("}"), i(2)
  }),
  s({ trig = "ddot", name = "Double dot", condition = in_math }, {
    t("\\ddot{"), i(1), t("}"), i(2)
  }),
  s({ trig = "cdot", name = "Center dot", condition = in_math }, t("\\cdot")),
  s({ trig = "tilde", name = "Tilde", condition = in_math }, {
    t("\\tilde{"), i(1), t("}"), i(2)
  }),
  s({ trig = "und", name = "Underline", condition = in_math }, {
    t("\\underline{"), i(1), t("}"), i(2)
  }),
  s({ trig = "vec", name = "Vector", condition = in_math }, {
    t("\\vec{"), i(1), t("}"), i(2)
  }),

  -- Common variables with subscripts
  s({ trig = "xnn", name = "x_n", condition = in_math }, t("x_{n}")),
  s({ trig = "xii", name = "x_i", condition = in_math }, t("x_{i}")),
  s({ trig = "xjj", name = "x_j", condition = in_math }, t("x_{j}")),
  s({ trig = "xp1", name = "x_{n+1}", condition = in_math }, t("x_{n+1}")),
  s({ trig = "ynn", name = "y_n", condition = in_math }, t("y_{n}")),
  s({ trig = "yii", name = "y_i", condition = in_math }, t("y_{i}")),
  s({ trig = "yjj", name = "y_j", condition = in_math }, t("y_{j}")),

  -- Derivatives and integrals
  s({ trig = "par", name = "Partial derivative", condition = in_math }, {
    t("\\frac{ \\partial "), i(1, "y"), t(" }{ \\partial "), i(2, "x"), t(" } "), i(3)
  }),
  s({ trig = "ddt", name = "Time derivative", condition = in_math }, t("\\frac{d}{dt} ")),
  s({ trig = "oint", name = "Contour integral", condition = in_math }, t("\\oint")),
  s({ trig = "iint", name = "Double integral", condition = in_math }, t("\\iint")),
  s({ trig = "iiint", name = "Triple integral", condition = in_math }, t("\\iiint")),

  -- Brackets
  s({ trig = "avg", name = "Average", condition = in_math }, {
    t("\\langle "), i(1), t(" \\rangle "), i(2)
  }),
  s({ trig = "norm", name = "Norm", condition = in_math }, {
    t("\\lvert "), i(1), t(" \\rvert "), i(2)
  }),
  s({ trig = "Norm", name = "Double norm", condition = in_math }, {
    t("\\lVert "), i(1), t(" \\rVert "), i(2)
  }),
  s({ trig = "ceil", name = "Ceiling", condition = in_math }, {
    t("\\lceil "), i(1), t(" \\rceil "), i(2)
  }),
  s({ trig = "floor", name = "Floor", condition = in_math }, {
    t("\\lfloor "), i(1), t(" \\rfloor "), i(2)
  }),

  -- Matrix environments (in math mode)
  s({ trig = "pmat", name = "Parenthesis matrix", condition = in_math }, {
    t("\\left(\\begin{array}{}\n"), i(1), t("\n\\end{array}\\right)")
  }),
  s({ trig = "bmat", name = "Bracket matrix", condition = in_math }, {
    t("\\left[\\begin{array}{}\n"), i(1), t("\n\\end{array}\\right]")
  }),
  s({ trig = "Bmat", name = "Brace matrix", condition = in_math }, {
    t("\\left\\{\\begin{array}{}\n"), i(1), t("\n\\end{array}\\right\\}")
  }),
  s({ trig = "vmat", name = "Determinant matrix", condition = in_math }, {
    t("\\left|\\begin{array}{}\n"), i(1), t("\n\\end{array}\\right|")
  }),
  s({ trig = "matrix", name = "Matrix", condition = in_math }, {
    t("\\begin{array}{}\n"), i(1), t("\n\\end{array}")
  }),

  -- Other environments (in math mode)
  s({ trig = "cases", name = "Cases", condition = in_math }, {
    t("\\begin{cases}\n"), i(1), t("\n\\end{cases}")
  }),
  s({ trig = "align", name = "Align", condition = in_math }, {
    t("\\begin{align}\n"), i(1), t("\n\\end{align}")
  }),

  -- Physics (in math mode)
  s({ trig = "kbt", name = "kT", condition = in_math }, t("k_{B}T")),
  s({ trig = "msun", name = "Solar mass", condition = in_math }, t("M_{\\odot}")),
  s({ trig = "dag", name = "Dagger", condition = in_math }, t("^{\\dagger}")),
  s({ trig = "o+", name = "Direct sum", condition = in_math }, t("\\oplus")),
  s({ trig = "oxx", name = "Tensor product", condition = in_math }, t("\\otimes")),

  -- Quantum mechanics (in math mode)
  s({ trig = "bra", name = "Bra", condition = in_math }, {
    t("\\bra{"), i(1), t("} "), i(2)
  }),
  s({ trig = "ket", name = "Ket", condition = in_math }, {
    t("\\ket{"), i(1), t("} "), i(2)
  }),
  s({ trig = "brk", name = "Braket", condition = in_math }, {
    t("\\braket{ "), i(1), t(" | "), i(2), t(" } "), i(3)
  }),
}, { key = "vimtex_math_snippets" })

print("LaTeX snippets loaded successfully!")
