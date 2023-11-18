local M = {}

M.onedark = {
  -- Theme inspired by Atom
  'navarasu/onedark.nvim',
  priority = 1000,
  config = function()
    local green = "#99bc80"
    local orange = "#ce7700"
    local light_orange = "#ee9770"
    local yellow = "#dfbe81"

    -- borders on lsp popup
    local border = { border = "rounded" }
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, border)
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, border)
    vim.diagnostic.config { float = border }

    require('onedark').setup {
      style = "warm",     -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
      transparent = true, -- Show/hide background
      -- colors = {
      --     orange = green,
      --     green = light_orange,
      -- },
      highlights = {
        ['@punctuation'] = { fg = yellow },
        ['@punctuation.bracket'] = { fg = yellow },
        ['@punctuation.delimiter'] = { fg = yellow },
        ['@lsp.type.type'] = { fg = green },
        ['@type'] = { fg = green },
        ['Type'] = { fg = green },
        ['@lsp.type.struct'] = { fg = green },
        ['Structure'] = { fg = green },
        ['@operator'] = { fg = orange },
      },
    }

    vim.cmd.colorscheme 'onedark'
  end,
}

M.darcula = {
  "doums/darcula",
  config = function()
    vim.cmd.colorscheme("darcula")
  end

}

M.catppuccin = {
  "catppuccin/nvim",
  config = function()
    require("catppuccin").setup {
      background = {
        light = "latte",
        dark = "mocha",
      },
      color_overrides = {
        latte = {
          rosewater = "#c14a4a",
          flamingo = "#c14a4a",
          red = "#c14a4a",
          maroon = "#c14a4a",
          pink = "#945e80",
          mauve = "#945e80",
          peach = "#c35e0a",
          yellow = "#b47109",
          green = "#6c782e",
          teal = "#4c7a5d",
          sky = "#4c7a5d",
          sapphire = "#4c7a5d",
          blue = "#45707a",
          lavender = "#45707a",
          text = "#654735",
          subtext1 = "#73503c",
          subtext0 = "#805942",
          overlay2 = "#8c6249",
          overlay1 = "#8c856d",
          overlay0 = "#a69d81",
          surface2 = "#bfb695",
          surface1 = "#d1c7a3",
          surface0 = "#e3dec3",
          base = "#f9f5d7",
          mantle = "#f0ebce",
          crust = "#e8e3c8",
        },
        mocha = {
          rosewater = "#ea6962",
          flamingo = "#ea6962",
          red = "#ea6962",
          maroon = "#ea6962",
          pink = "#d3869b",
          mauve = "#d3869b",
          peach = "#e78a4e",
          yellow = "#d8a657",
          green = "#a9b665",
          teal = "#89b482",
          sky = "#89b482",
          sapphire = "#89b482",
          blue = "#7daea3",
          lavender = "#7daea3",
          text = "#ebdbb2",
          subtext1 = "#d5c4a1",
          subtext0 = "#bdae93",
          overlay2 = "#a89984",
          overlay1 = "#928374",
          overlay0 = "#595959",
          surface2 = "#4d4d4d",
          surface1 = "#404040",
          surface0 = "#292929",
          base = "#1d2021",
          mantle = "#191b1c",
          crust = "#141617",
        },
      },
      transparent_background = true,
      show_end_of_buffer = false,
      integration_default = false,
      integrations = {
        barbecue = { dim_dirname = true, bold_basename = true, dim_context = false, alt_background = false },
        cmp = true,
        gitsigns = true,
        hop = true,
        illuminate = true,
        native_lsp = { enabled = true, inlay_hints = { background = true } },
        neogit = true,
        neotree = true,
        semantic_tokens = true,
        treesitter = true,
        treesitter_context = true,
        vimwiki = true,
        which_key = true,
      },
      highlight_overrides = {
        all = function(colors)
          return {
            Visual = { fg = "#ffffff", bg = "#6060aa" },
            CmpItemMenu = { fg = colors.surface2 },
            CursorLineNr = { fg = colors.text },
            FloatBorder = { bg = colors.base, fg = colors.surface0 },
            GitSignsChange = { fg = colors.peach },
            LineNr = { fg = colors.overlay0 },
            LspInfoBorder = { link = "FloatBorder" },
            NeoTreeDirectoryIcon = { fg = colors.subtext0 },
            NeoTreeDirectoryName = { fg = colors.subtext0 },
            NeoTreeFloatBorder = { link = "TelescopeResultsBorder" },
            NeoTreeGitConflict = { fg = colors.red },
            NeoTreeGitDeleted = { fg = colors.red },
            NeoTreeGitIgnored = { fg = colors.overlay0 },
            NeoTreeGitModified = { fg = colors.peach },
            NeoTreeGitStaged = { fg = colors.green },
            NeoTreeGitUnstaged = { fg = colors.red },
            NeoTreeGitUntracked = { fg = colors.green },
            NeoTreeIndent = { fg = colors.surface1 },
            NeoTreeNormal = { bg = colors.mantle },
            NeoTreeNormalNC = { bg = colors.mantle },
            NeoTreeRootName = { fg = colors.subtext0, style = { "bold" } },
            NeoTreeTabActive = { fg = colors.text, bg = colors.mantle },
            NeoTreeTabInactive = { fg = colors.surface2, bg = colors.crust },
            NeoTreeTabSeparatorActive = { fg = colors.mantle, bg = colors.mantle },
            NeoTreeTabSeparatorInactive = { fg = colors.crust, bg = colors.crust },
            NeoTreeWinSeparator = { fg = colors.base, bg = colors.base },
            NormalFloat = { bg = colors.base },
            Pmenu = { bg = colors.mantle, fg = "" },
            PmenuSel = { bg = colors.surface0, fg = "" },
            -- TelescopePreviewBorder = { bg = colors.crust, fg = colors.crust },
            -- TelescopePreviewNormal = { bg = colors.crust },
            -- TelescopePreviewTitle = { fg = colors.crust, bg = colors.crust },
            -- TelescopePromptBorder = { bg = colors.surface0, fg = colors.surface0 },
            -- TelescopePromptCounter = { fg = colors.mauve, style = { "bold" } },
            -- TelescopePromptNormal = { bg = colors.surface0 },
            -- TelescopePromptPrefix = { bg = colors.surface0 },
            -- TelescopePromptTitle = { fg = colors.surface0, bg = colors.surface0 },
            -- TelescopeResultsBorder = { bg = colors.mantle, fg = colors.mantle },
            -- TelescopeResultsNormal = { bg = colors.mantle },
            -- TelescopeResultsTitle = { fg = colors.mantle, bg = colors.mantle },
            -- TelescopeSelection = { bg = colors.surface0 },
            VertSplit = { bg = colors.base, fg = colors.surface0 },
            WhichKeyFloat = { bg = colors.mantle },
            YankHighlight = { bg = colors.surface2 },
            FidgetTask = { fg = colors.subtext1 },
            FidgetTitle = { fg = colors.peach },

            IblIndent = { fg = colors.surface0 },
            IblScope = { fg = colors.overlay0 },

            Boolean = { fg = colors.mauve },
            Number = { fg = colors.mauve },
            Float = { fg = colors.mauve },

            PreProc = { fg = colors.mauve },
            PreCondit = { fg = colors.mauve },
            Include = { fg = colors.mauve },
            Define = { fg = colors.mauve },
            Conditional = { fg = colors.red },
            Repeat = { fg = colors.red },
            Keyword = { fg = colors.red },
            Typedef = { fg = colors.red },
            Exception = { fg = colors.red },
            Statement = { fg = colors.red },

            Error = { fg = colors.red },
            StorageClass = { fg = colors.peach },
            Tag = { fg = colors.peach },
            Label = { fg = colors.peach },
            Structure = { fg = colors.peach },
            Operator = { fg = colors.peach },
            Title = { fg = colors.peach },
            Special = { fg = colors.yellow },
            SpecialChar = { fg = colors.yellow },
            Type = { fg = colors.yellow, style = { "bold" } },
            Function = { fg = colors.green, style = { "bold" } },
            Delimiter = { fg = colors.subtext1 },
            Ignore = { fg = colors.subtext1 },
            Macro = { fg = colors.teal },

            TSAnnotation = { fg = colors.mauve },
            TSAttribute = { fg = colors.mauve },
            TSBoolean = { fg = colors.mauve },
            TSCharacter = { fg = colors.teal },
            TSCharacterSpecial = { link = "SpecialChar" },
            TSComment = { link = "Comment" },
            TSConditional = { fg = colors.red },
            TSConstBuiltin = { fg = colors.mauve },
            TSConstMacro = { fg = colors.mauve },
            TSConstant = { fg = colors.text },
            TSConstructor = { fg = colors.green },
            TSDebug = { link = "Debug" },
            TSDefine = { link = "Define" },
            TSEnvironment = { link = "Macro" },
            TSEnvironmentName = { link = "Type" },
            TSError = { link = "Error" },
            TSException = { fg = colors.red },
            TSField = { fg = colors.blue },
            TSFloat = { fg = colors.mauve },
            TSFuncBuiltin = { fg = colors.green },
            TSFuncMacro = { fg = colors.green },
            TSFunction = { fg = colors.green },
            TSFunctionCall = { fg = colors.green },
            TSInclude = { fg = colors.red },
            TSKeyword = { fg = colors.red },
            TSKeywordFunction = { fg = colors.red },
            TSKeywordOperator = { fg = colors.peach },
            TSKeywordReturn = { fg = colors.red },
            TSLabel = { fg = colors.peach },
            TSLiteral = { link = "String" },
            TSMath = { fg = colors.blue },
            TSMethod = { fg = colors.green },
            TSMethodCall = { fg = colors.green },
            TSNamespace = { fg = colors.yellow },
            TSNone = { fg = colors.text },
            TSNumber = { fg = colors.mauve },
            TSOperator = { fg = colors.peach },
            TSParameter = { fg = colors.text },
            TSParameterReference = { fg = colors.text },
            TSPreProc = { link = "PreProc" },
            TSProperty = { fg = colors.blue },
            TSPunctBracket = { fg = colors.text },
            TSPunctDelimiter = { link = "Delimiter" },
            TSPunctSpecial = { fg = colors.blue },
            TSRepeat = { fg = colors.red },
            TSStorageClass = { fg = colors.peach },
            TSStorageClassLifetime = { fg = colors.peach },
            TSStrike = { fg = colors.subtext1 },
            TSString = { fg = colors.teal },
            TSStringEscape = { fg = colors.green },
            TSStringRegex = { fg = colors.green },
            TSStringSpecial = { link = "SpecialChar" },
            TSSymbol = { fg = colors.text },
            TSTag = { fg = colors.peach },
            TSTagAttribute = { fg = colors.green },
            TSTagDelimiter = { fg = colors.green },
            TSText = { fg = colors.green },
            TSTextReference = { link = "Constant" },
            TSTitle = { link = "Title" },
            TSTodo = { link = "Todo" },
            TSType = { fg = colors.yellow, style = { "bold" } },
            TSTypeBuiltin = { fg = colors.yellow, style = { "bold" } },
            TSTypeDefinition = { fg = colors.yellow, style = { "bold" } },
            TSTypeQualifier = { fg = colors.peach, style = { "bold" } },
            TSURI = { fg = colors.blue },
            TSVariable = { fg = colors.text },
            TSVariableBuiltin = { fg = colors.mauve },

            ["@annotation"] = { link = "TSAnnotation" },
            ["@attribute"] = { link = "TSAttribute" },
            ["@boolean"] = { link = "TSBoolean" },
            ["@character"] = { link = "TSCharacter" },
            ["@character.special"] = { link = "TSCharacterSpecial" },
            ["@comment"] = { link = "TSComment" },
            ["@conceal"] = { link = "Grey" },
            ["@conditional"] = { link = "TSConditional" },
            ["@constant"] = { link = "TSConstant" },
            ["@constant.builtin"] = { link = "TSConstBuiltin" },
            ["@constant.macro"] = { link = "TSConstMacro" },
            ["@constructor"] = { link = "TSConstructor" },
            ["@debug"] = { link = "TSDebug" },
            ["@define"] = { link = "TSDefine" },
            ["@error"] = { link = "TSError" },
            ["@exception"] = { link = "TSException" },
            ["@field"] = { link = "TSField" },
            ["@float"] = { link = "TSFloat" },
            ["@function"] = { link = "TSFunction" },
            ["@function.builtin"] = { link = "TSFuncBuiltin" },
            ["@function.call"] = { link = "TSFunctionCall" },
            ["@function.macro"] = { link = "TSFuncMacro" },
            ["@include"] = { link = "TSInclude" },
            ["@keyword"] = { link = "TSKeyword" },
            ["@keyword.function"] = { link = "TSKeywordFunction" },
            ["@keyword.operator"] = { link = "TSKeywordOperator" },
            ["@keyword.return"] = { link = "TSKeywordReturn" },
            ["@label"] = { link = "TSLabel" },
            ["@math"] = { link = "TSMath" },
            ["@method"] = { link = "TSMethod" },
            ["@method.call"] = { link = "TSMethodCall" },
            ["@namespace"] = { link = "TSNamespace" },
            ["@none"] = { link = "TSNone" },
            ["@number"] = { link = "TSNumber" },
            ["@operator"] = { link = "TSOperator" },
            ["@parameter"] = { link = "TSParameter" },
            ["@parameter.reference"] = { link = "TSParameterReference" },
            ["@preproc"] = { link = "TSPreProc" },
            ["@property"] = { link = "TSProperty" },
            ["@punctuation.bracket"] = { link = "TSPunctBracket" },
            ["@punctuation.delimiter"] = { link = "TSPunctDelimiter" },
            ["@punctuation.special"] = { link = "TSPunctSpecial" },
            ["@repeat"] = { link = "TSRepeat" },
            ["@storageclass"] = { link = "TSStorageClass" },
            ["@storageclass.lifetime"] = { link = "TSStorageClassLifetime" },
            ["@strike"] = { link = "TSStrike" },
            ["@string"] = { link = "TSString" },
            ["@string.escape"] = { link = "TSStringEscape" },
            ["@string.regex"] = { link = "TSStringRegex" },
            ["@string.special"] = { link = "TSStringSpecial" },
            ["@symbol"] = { link = "TSSymbol" },
            ["@tag"] = { link = "TSTag" },
            ["@tag.attribute"] = { link = "TSTagAttribute" },
            ["@tag.delimiter"] = { link = "TSTagDelimiter" },
            ["@text"] = { link = "TSText" },
            ["@text.danger"] = { link = "TSDanger" },
            ["@text.diff.add"] = { link = "diffAdded" },
            ["@text.diff.delete"] = { link = "diffRemoved" },
            ["@text.emphasis"] = { link = "TSEmphasis" },
            ["@text.environment"] = { link = "TSEnvironment" },
            ["@text.environment.name"] = { link = "TSEnvironmentName" },
            ["@text.literal"] = { link = "TSLiteral" },
            ["@text.math"] = { link = "TSMath" },
            ["@text.note"] = { link = "TSNote" },
            ["@text.reference"] = { link = "TSTextReference" },
            ["@text.strike"] = { link = "TSStrike" },
            ["@text.strong"] = { link = "TSStrong" },
            ["@text.title"] = { link = "TSTitle" },
            ["@text.todo"] = { link = "TSTodo" },
            ["@text.todo.checked"] = { link = "Green" },
            ["@text.todo.unchecked"] = { link = "Ignore" },
            ["@text.underline"] = { link = "TSUnderline" },
            ["@text.uri"] = { link = "TSURI" },
            ["@text.warning"] = { link = "TSWarning" },
            ["@todo"] = { link = "TSTodo" },
            ["@type"] = { link = "TSType" },
            ["@type.builtin"] = { link = "TSTypeBuiltin" },
            ["@type.definition"] = { link = "TSTypeDefinition" },
            ["@type.qualifier"] = { link = "TSTypeQualifier" },
            ["@uri"] = { link = "TSURI" },
            ["@variable"] = { link = "TSVariable" },
            ["@variable.builtin"] = { link = "TSVariableBuiltin" },

            ["@lsp.type.class"] = { link = "TSType" },
            ["@lsp.type.comment"] = { link = "TSComment" },
            ["@lsp.type.decorator"] = { link = "TSFunction" },
            ["@lsp.type.enum"] = { link = "TSType" },
            ["@lsp.type.enumMember"] = { link = "TSProperty" },
            ["@lsp.type.events"] = { link = "TSLabel" },
            ["@lsp.type.function"] = { link = "TSFunction" },
            ["@lsp.type.interface"] = { link = "TSType" },
            ["@lsp.type.keyword"] = { link = "TSKeyword" },
            ["@lsp.type.macro"] = { link = "TSConstMacro" },
            ["@lsp.type.method"] = { link = "TSMethod" },
            ["@lsp.type.modifier"] = { link = "TSTypeQualifier" },
            ["@lsp.type.namespace"] = { link = "TSNamespace" },
            ["@lsp.type.number"] = { link = "TSNumber" },
            ["@lsp.type.operator"] = { link = "TSOperator" },
            ["@lsp.type.parameter"] = { link = "TSParameter" },
            ["@lsp.type.property"] = { link = "TSProperty" },
            ["@lsp.type.regexp"] = { link = "TSStringRegex" },
            ["@lsp.type.string"] = { link = "TSString" },
            ["@lsp.type.struct"] = { link = "TSType" },
            ["@lsp.type.type"] = { link = "TSType" },
            ["@lsp.type.typeParameter"] = { link = "TSTypeDefinition" },
            ["@lsp.type.variable"] = { link = "TSVariable" },
          }
        end,
        latte = function(colors)
          return {
            IblIndent = { fg = colors.mantle },
            IblScope = { fg = colors.surface1 },

            LineNr = { fg = colors.surface1 },
          }
        end,
      },
    }

    vim.cmd.colorscheme("catppuccin")
  end
}

M.gruvbox = {
  "ellisonleao/gruvbox.nvim",
  config = function()
    require("gruvbox").setup{
      palette_overrides = {
        -- dark0_hard = "#000000",
        dark0 = "#252525", ---------- background
        -- dark0_soft = "#000000",
        dark1 = "#303030", ---------- barra lateral esquerda onde fica os breakpoints e infos sobre a linha
        dark2 = "#555555", ---------- barra de indentacao
        dark3 = "#3f3f3f", ---------- selecao de linhas
        dark4 = "#777777", ---------- numeracao da linha
        -- light0_hard = "#000000",
        -- light0 = "#000000",
        -- light0_soft = "#000000",
        light1 = "#bfbfbf", --------- palavras principais(nome de variaveis criadas)
        light2 = "#dddddd", --------- cor padrao de icone sem cor especifica
        -- light3 = "#000000",
        light4 = "#aa9989", --------- letras marcadas para chamar atencao nos menus
        -- bright_red = "#ab3fff", ----- palavras reservadas da linguagem(keywords)
        bright_green = "#b4ad4a", --- funcoes
        bright_yellow = "#60b34e", -- Tipos de variaveis(int, float...)
        bright_blue = "#909090", ---- nome de parametro de func e parametro de struct
        bright_purple = "#b8b773", -- numeros e constantes
        bright_aqua = "#b8b773",----- include e defines
        bright_orange = "#33aa33", -- pontuacao
        neutral_red = "#ff1111", ---- erro no terminal
        neutral_green = "#aa5555", -- nome de arquivo .sh no explorer
        neutral_yellow = "#ff0000",-- arquivos com erro mp explorer
        neutral_blue = "#bfbfbf", --- cor da pasta no explorer
        neutral_purple = "#cccccc",-- pasta root do explorer
        neutral_aqua = "#aa5555", --- nome de arquivo (desconhecido eu acho) no explorer
        -- neutral_orange = "#000000",
        -- faded_red = "#000000",
        -- faded_green = "#000000",
        -- faded_yellow = "#000000",
        -- faded_blue = "#000000",
        -- faded_purple = "#000000",
        -- faded_aqua = "#000000",
        -- faded_orange = "#000000",
        gray = "#5d7759", ---------- comentarios
      },
      contrast = "hard",
      transparent_mode = true,
      invert_tabline = true,
      overrides = {
        StorageClass = { fg = "#de8600" }, -- static
        Delimiter = { fg = "#de8600" }, -- brackets
        Include = { fg = "#de8600" }, -- includes
        Operator = { fg = "#de8600" }, -- operators
        -- Identifier = { fg = "#929292" }, -- struct components
        Identifier = { fg = "#928272" }, -- struct components
        String = { fg = "#7b5e47" }, -- strings
        -- Keyword = { fg = "#ab3fff" }, -- if, else, for ...
        Keyword = { fg = "#c073fc" }, -- if, else, for ...
        Comment = { fg = "#3a6030" }, -- comment
        GitSignsAdd = { fg = "#9090ff" }, -- git
        GitSignsAddLn = { fg = "#9090ff" }, -- git
        GitSignsAddPreview = { fg = "#9090ff" }, -- git
        GitSignsChange = { fg = "#cc9910" }, -- git
        GitSignsChangeLn = { fg = "#cc9910" }, -- git
        GitSignsDelete = { fg = "#aa4010" }, -- git
        GitSignsTopdelete = { fg = "#aa4010" }, -- git
        GitSignsDeletePreview = { fg = "#aa4010" }, -- git
        GitSignsDeleteVirtLn = { fg = "#aa4010" }, -- git
        DiffAdd = { fg = "#589967"}, -- diff
        DiffChange = { fg = "#999960" }, -- diff
        DiffDelete = { fg = "#333333", bg = "#505050" }, -- diff
        DiffText = { fg = "#999960" }, -- diff
        FloatShadow = { fg = "#ffffff" }, --
        FloatShadowThrough = { fg = "#ffffff" }, --
      }
    }

    vim.cmd("colorscheme gruvbox")

  end,
}

M.everforest = {
  "sainnhe/everforest",
  config = function()
    vim.g.everforest_background = "hard"
    vim.g.everforest_better_performance = 1
    vim.g.everforest_dim_inactive_windows = 1
    vim.g.everforest_ui_contrast = "high"
    vim.g.everforest_diagnostic_virtual_text = "colored"

    vim.cmd("colorscheme everforest")
    vim.cmd("highlight Normal guibg=#11130d")
  end,
}

M.gruvbox8 = {
  "lifepillar/vim-gruvbox8",
  branch = "neovim",
  config = function()
    vim.cmd("colorscheme gruvbox8_soft")
    vim.cmd("highlight Normal guibg=#11130d")
  end,
}

M.gruvbox_material = {
  "sainnhe/gruvbox-material",
  config = function()
    vim.g.gruvbox_material_background = "soft"
    vim.g.gruvbox_material_better_performance = 1
    vim.g.gruvbox_material_transparent_background = 1
    vim.g.gruvbox_material_foreground = "mix"
    vim.cmd("colorscheme gruvbox-material")
    vim.cmd("highlight Fg guifg=#ddddbb")
  end,
}

return M
