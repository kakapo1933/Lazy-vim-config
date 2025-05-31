return {
  {
    "goolord/alpha-nvim",
    enabled = false,
  },
  {
    "echasnovski/mini.starter",
    enabled = false,
  },
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = { enabled = false },
    },
  },
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    enabled = true,
    priority = 1000,
    opts = function()
      local opts = {
        theme = "doom",
        hide = {
          statusline = false,
        },
        config = {
          header = {
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "  ██╗  ██╗ █████╗ ██╗██████╗  ██████╗ ███████╗███████╗███████╗",
            "  ██║ ██╔╝██╔══██╗██║██╔══██╗██╔═══██╗╚══███╔╝╚══███╔╝╚══███╔╝",
            "  █████╔╝ ███████║██║██████╔╝██║   ██║  ███╔╝   ███╔╝   ███╔╝ ",
            "  ██╔═██╗ ██╔══██║██║██╔═══╝ ██║   ██║ ███╔╝   ███╔╝   ███╔╝  ",
            "  ██║  ██╗██║  ██║██║██║     ╚██████╔╝███████╗███████╗███████╗",
            "  ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝      ╚═════╝ ╚══════╝╚══════╝╚══════╝",
            "",
            "      Welcome to Lazyvim!    ",
            "",
            "",
          },
          center = {
            { action = "Telescope find_files", desc = "Find File ", icon = "", key = "f" },
            { action = "ene | startinsert", desc = "New File ", icon = "", key = "n" },
            { action = "Telescope oldfiles", desc = "Recent Files ", icon = "", key = "r" },
            { action = "Telescope live_grep", desc = "Find Text ", icon = "", key = "g" },
            { action = 'lua require("persistence").load()', desc = "Restore Session ", icon = "", key = "s" },
            { action = "e $MYVIMRC", desc = "Config ", icon = "", key = "c" },
            { action = "Lazy", desc = "Lazy ", icon = "󰒲", key = "l" },
            { action = "LazyExtras", desc = "Lazy Extras ", icon = "", key = "x" },
            { action = "qa", desc = "Quit ", icon = "", key = "q" },
          },
          footer = function()
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
          end,
        },
      }
      return opts
    end,
  },
}
