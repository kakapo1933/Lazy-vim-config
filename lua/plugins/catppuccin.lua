return {
  "catppuccin/nvim",
  lazy = true,
  name = "catppuccin",
  priority = 1000,
  opts = {
    compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
    flavour = "mocha", -- latte, frappe, macchiato, mocha
    background = {
      light = "latte",
      dark = "mocha",
    },
    transparent_background = true,
    integrations = {
      aerial = true,
      alpha = true,
      cmp = true,
      dashboard = true,
      dim_inactive = {
        enabled = false, -- dims the background color of inactive window
        shade = "dark",
        percentage = 0.15, -- percentage of the shade to apply to the inactive window
      },
      flash = true,
      fzf = true,
      grug_far = true,
      gitsigns = true,
      headlines = true,
      illuminate = true,
      indent_blankline = { enabled = true },
      leap = true,
      lsp_trouble = true,
      mason = true,
      markdown = true,
      mini = true,
      native_lsp = {
        enabled = true,
        underlines = {
          errors = { "undercurl" },
          hints = { "undercurl" },
          warnings = { "undercurl" },
          information = { "undercurl" },
        },
      },
      navic = { enabled = true, custom_bg = "lualine" },
      neotest = true,
      neotree = true,
      noice = true,
      no_italic = false,
      notify = true,
      semantic_tokens = true,
      snacks = {
        enabled = true,
        indent_scope_color = "lavender",
      },
      telescope = true,
      treesitter = true,
      treesitter_context = true,
      which_key = true,
    },
    custom_highlights = function(colors)
      return {
        -- General Float Border
        FloatBorder = { fg = colors.lavender },
        NormalFloat = { fg = colors.lavender, bg = colors.base },
        -- NeoTree highlights
        NeoTreeWinSeparator = { fg = colors.lavender },
        -- Neo-tree window title
        NeoTreeNormal = { fg = colors.pink, bg = colors.base },
        NeoTreeNormalNC = { fg = colors.pink, bg = colors.base },
        -- Customize neo-tree colors
        NeoTreeRootName = { fg = colors.lavender, style = { "bold", "italic" } },
        NeoTreeDirectoryName = { fg = colors.lavender },
        NeoTreeFileName = { fg = colors.lavender },
        NeoTreeDirectoryIcon = { fg = colors.lavender },
        NeoTreeFileIcon = { fg = colors.lavender },
        -- Tree structure
        NeoTreeIndentMarker = { fg = colors.lavender },
        NeoTreeExpander = { fg = colors.subtext0 },
        -- Interface elements
        NeoTreeFloatBorder = { fg = colors.lavender, bg = colors.base },
        NeoTreeTitleBar = { fg = colors.lavender, bg = colors.mantle },
        NeoTreeDimText = { fg = colors.overlay0 },
        NeoTreeModified = { fg = colors.peach, style = { "bold" } },
        -- Git status colors
        NeoTreeGitAdded = { fg = colors.green },
        NeoTreeGitModified = { fg = colors.yellow, style = { "bold" } },
        NeoTreeGitDeleted = { fg = colors.red },
        NeoTreeGitUntracked = { fg = colors.flamingo },
        NeoTreeGitIgnored = { fg = colors.overlay0 },
        NeoTreeGitConflict = { fg = colors.red, style = { "bold" } },
        NeoTreeGitStaged = { fg = colors.green },
        NeoTreeGitUnstaged = { fg = colors.peach },
        -- Bufferline Neo-tree text
        BufferLineOffsetSeparator = { fg = colors.mauve, bg = colors.base, style = { "bold" } },
        -- Which-key floating window
        WhichKey = { fg = colors.mauve },
        WhichKeyGroup = { fg = colors.mauve },
        WhichKeySeparator = { fg = colors.overlay0 },
        WhichKeyDesc = { fg = colors.pink },
        WhichKeyFloat = { bg = colors.base },
        WhichKeyBorder = { fg = colors.lavender, bg = colors.base },
        WhichKeyValue = { fg = colors.overlay0 },
        -- Dashboard highlights
        DashboardHeader = { fg = colors.pink },
        DashboardCenter = { fg = colors.lavender },
        DashboardFooter = { fg = colors.overlay0 },
        DashboardKey = { fg = colors.pink },
        DashboardDesc = { fg = colors.lavender },
        DashboardIcon = { fg = colors.mauve },
        DashboardShortCut = { fg = colors.mauve },
        SnacksDashboardHeader = { fg = colors.pink },
        SnacksDashboardKey = { fg = colors.pink },
        SnacksDashboardDesc = { fg = colors.lavender },
        SnacksDashboardIcon = { fg = colors.mauve },
        SnacksDashboardFooter = { fg = colors.overlay0 },
      }
    end,
  },
  specs = {
    {
      "akinsho/bufferline.nvim",
      optional = true,
      opts = function(_, opts)
        if (vim.g.colors_name or ""):find("catppuccin") then
          opts.highlights = require("catppuccin.groups.integrations.bufferline").get()
        end
      end,
    },
  },
}
