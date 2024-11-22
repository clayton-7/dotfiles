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
    priority = 1000,
    config = function()
        vim.cmd.colorscheme("darcula")
    end
}

M.darcula_solid = {
    "briones-gabriel/darcula-solid.nvim",
    dependencies = { "rktjmp/lush.nvim" },

    priority = 1000,
    config = function()
        vim.cmd.colorscheme("darcula-solid")
    end
}

M.catppuccin = {
    "catppuccin/nvim",
    priority = 1000,
    config = function()
        require("catppuccin").setup {
            background = {
                dark = "mocha",
            },
            color_overrides = {
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
            -- transparent_background = true,
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
        }

        vim.cmd.colorscheme("catppuccin")
        vim.cmd("highlight Fg guifg=#ddddbb")
        vim.cmd("highlight Search guifg=#ffffff guibg=#307050")
        vim.cmd("highlight IncSearch gui=underline,bold guifg=#000000 guibg=#ccffaa")
    end
}

M.gruvbox = {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
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
    priority = 1000,
    config = function()
        vim.g.everforest_background = "hard"
        vim.g.everforest_better_performance = 1
        vim.g.everforest_dim_inactive_windows = 1
        vim.g.everforest_ui_contrast = "high"
        vim.g.everforest_diagnostic_virtual_text = "colored"
        -- vim.g.everforest_transparent_background = 1

        vim.cmd("colorscheme everforest")
        -- vim.cmd("highlight Normal guibg=#11130d")
    end,
}

M.gruvbox8 = {
    "lifepillar/vim-gruvbox8",
    branch = "neovim",
    priority = 1000,
    config = function()
        vim.cmd("colorscheme gruvbox8_soft")
        vim.cmd("highlight Normal guibg=#11130d")
    end,
}

M.gruvbox_material = {
    "sainnhe/gruvbox-material",
    priority = 1000,
    config = function()
        vim.g.gruvbox_material_background = "soft"
        vim.g.gruvbox_material_better_performance = 1
        vim.g.gruvbox_material_transparent_background = 1
        vim.g.gruvbox_material_foreground = "mix"
        vim.cmd("colorscheme gruvbox-material")

        vim.cmd("highlight Fg guifg=#ddddbb")
        vim.cmd("highlight Search guifg=#ffffff guibg=#307050")
        vim.cmd("highlight IncSearch gui=underline,bold guifg=#000000 guibg=#ccffaa")
    end,
}

M.gruvbox_baby = {
    "luisiacc/gruvbox-baby",
    lazy = false,
    priority = 1000,
    config = function()
        -- vim.g.gruvbox_baby_transparent_mode = 1
        vim.g.gruvbox_baby_background_color = "dark"
        vim.cmd("colorscheme gruvbox-baby")
    end,
}

M.bamboo = {
    'ribru17/bamboo.nvim',
    priority = 1000,
    config = function()
        local bamboo = require('bamboo')
        bamboo.setup{
            style = 'multiplex',
            -- style = 'vulgaris',
            -- transparent = true,
            colors = {
                -- blue = "#76abae",
                blue = "#cbcd61",
                bg0 = "#2d2f2d",
            },

            highlights = {
                ['@comment'] = { fg = '$grey' },
            }
        }
        bamboo.load()

        -- search cursor highlights
        vim.cmd("highlight Search guifg=#ffffff guibg=#307050")
        vim.cmd("highlight CurSearch guifg=#121212 guibg=#00ff60")
        vim.cmd("highlight Visual guibg=#505050")
    end,
}
M.tokyonight = {
    "folke/tokyonight.nvim",
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
        vim.cmd.colorscheme("tokyonight-night")
        vim.cmd.hi("Comment gui=none")
    end,
}

M.kanagawa = {
    "rebelot/kanagawa.nvim",
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
        vim.cmd.colorscheme("kanagawa")
    end,
}

M.aura_theme = {
    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
    {
        "baliestri/aura-theme",
        lazy = false,
        priority = 1000,
        config = function(plugin)
            vim.opt.rtp:append(plugin.dir .. "/packages/neovim")
            vim.cmd([[colorscheme aura-soft-dark-soft-text]])
        end
    }
}

M.nightfox = {
    "EdenEast/nightfox.nvim",
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
        vim.cmd.colorscheme("nightfox")
    end,
}

M.nordic = {
    'AlexvZyl/nordic.nvim',
    lazy = false,
    priority = 1000,
    config = function()
        require('nordic').load()
    end
}

M.mellow = {
    'mellow-theme/mellow.nvim',
    priority = 1000,
    config = function()
        vim.cmd([[colorscheme mellow]])
    end
}

M.no_clown_fiesta = {
    'aktersnurra/no-clown-fiesta.nvim',
    priority = 1000,
    config = function()
        vim.cmd([[colorscheme no-clown-fiesta]])
    end
}

M.modus = {
    'miikanissi/modus-themes.nvim',
    priority = 1000,
    config = function()
        vim.cmd([[colorscheme modus]])
    end
}

M.sequoia = {
    'Hiroya-W/sequoia-moonlight.nvim',
    priority = 1000,
    config = function()
        vim.cmd([[colorscheme sequoia]])
    end
}

M.citruszest = {
    "zootedb0t/citruszest.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        vim.cmd([[colorscheme citruszest]])
    end
}
M.hybrid = {
    "HoNamDuong/hybrid.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
        vim.cmd([[colorscheme hybrid]])
    end
}

M.aquarium = {
    'frenzyexists/aquarium-vim',
    lazy = false,
    priority = 1000,
    config = function()
        vim.cmd([[colorscheme aquarium]])
    end
}

M.komau = {
    'ntk148v/komau.vim',
    lazy = false,
    priority = 1000,
    config = function()
        vim.cmd([[colorscheme komau]])
    end
}

M.darcula_solid1 = {
    'briones-gabriel/darcula-solid.nvim',
    dependencies = { "rktjmp/lush.nvim" },
    lazy = false,
    priority = 1000,
    config = function()
        vim.cmd([[colorscheme darcula-solid]])
        vim.cmd([[set termguicolors]])
    end
}

M.zenburn = {
    "phha/zenburn.nvim",
    config = function ()
        vim.cmd([[colorscheme zenburn]])
    end
}

M.monotone = {
    "davidosomething/vim-colors-meh", --

    config = function ()
        vim.cmd([[colorscheme meh]]) --
    end
}

M.nord = {
    "gbprod/nord.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        require("nord").setup{}
        vim.cmd.colorscheme("nord")
    end,
}

return M
