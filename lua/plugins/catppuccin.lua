return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "macchiato", -- latte, frappe, macchiato, mocha
      background = { -- :h background
        light = "latte",
        dark = "macchiato",
      },
      transparent_background = true,
      show_end_of_buffer = false,
      term_colors = true,
      dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.15,
      },
      no_italic = false,
      no_bold = false,
      no_underline = false,
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
      },
      integrations = {
        cmp = true,
        gitsigns = true,
        neotree = true,
        treesitter = true,
        notify = true,
        mini = {
          enabled = true,
          indentscope_color = "",
        },
        telescope = {
          enabled = true,
        },
        which_key = true,
        indent_blankline = {
          enabled = true,
          scope_color = "",
          colored_indent_levels = false,
        },
        dashboard = true,
        neogit = true,
        vim_sneak = false,
        fern = false,
        barbar = false,
        markdown = true,
        noice = true,
        hop = false,
        illuminate = {
          enabled = true,
          lsp = false,
        },
        lsp_saga = false,
        gitgutter = false,
        leap = false,
        mason = true,
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
          },
          inlay_hints = {
            background = true,
          },
        },
      },
      custom_highlights = function(colors)
        return {
          -- Customize neo-tree colors
          NeoTreeRootName = { fg = colors.mauve, style = { "bold" } },
          NeoTreeDirectoryName = { fg = colors.lavender },
          NeoTreeFileName = { fg = colors.lavender },
          -- NeoTreeFileIcon = { fg = colors.blue },
          -- NeoTreeTitleBar = { fg = colors.crust, bg = colors.blue },
          -- Window separators
          NeoTreeWinSeparator = { fg = colors.teal },
          -- NeoTreeVertSplit = { fg = colors.surface0, bg = colors.base },
          -- The path/statusline at the bottom
        }
      end,
    },
  },

  -- Configure LazyVim to use catppuccin
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
