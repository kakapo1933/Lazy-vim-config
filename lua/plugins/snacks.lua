-- Extend LazyVim's built-in Snacks.nvim configuration
return {
  "folke/snacks.nvim",
  opts = {
    -- Customize lazygit window
    dashboard = {
      enabled = true,
      preset = {
        header = [[
  ██╗  ██╗ █████╗ ██╗██████╗  ██████╗ ██╗  ██╗███████╗███╗   ███╗ ██████╗ ███╗   ██╗
  ██║ ██╔╝██╔══██╗██║██╔══██╗██╔═══██╗██║ ██╔╝██╔════╝████╗ ████║██╔═══██╗████╗  ██║
  █████╔╝ ███████║██║██████╔╝██║   ██║█████╔╝ █████╗  ██╔████╔██║██║   ██║██╔██╗ ██║
  ██╔═██╗ ██╔══██║██║██╔═══╝ ██║   ██║██╔═██╗ ██╔══╝  ██║╚██╔╝██║██║   ██║██║╚██╗██║
  ██║  ██╗██║  ██║██║██║     ╚██████╔╝██║  ██╗███████╗██║ ╚═╝ ██║╚██████╔╝██║ ╚████║
  ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝      ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝
        ]],
      },
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        { section = "startup" },
        {
          section = "terminal",
          cmd = "printf '\\n\\n\\n\\n\\n\\n\\n'; pokemon-colorscripts -r --no-title 2>/dev/null",
          pane = 2,
          height = 30,
          indent = 4,
          random = 900,
        },
      },
    },
    lazygit = {
      win = {
        border = "rounded",
        width = 0.9,
        height = 0.9,
      },
    },
    -- Enable indent guides
    indent = {
      enabled = true,
      char = "│",
      highlight = "IblIndent",
    },
    -- Enable image display
    image = {
      enabled = true,
      doc = {
        enabled = true,
        inline = true,
        max_width = 80,
        max_height = 40,
      },
      formats = {
        "png",
        "jpg",
        "jpeg",
        "gif",
        "bmp",
        "webp",
        "tiff",
        "heic",
        "avif",
        "mp4",
        "mov",
        "avi",
        "mkv",
        "webm",
        "pdf",
      },
    },
  },
  keys = {
    -- Additional lazygit keymaps
    {
      "<leader>glf",
      function()
        require("snacks").lazygit.log_file()
      end,
      desc = "Lazygit log (file)",
    },
    {
      "<leader>gll",
      function()
        require("snacks").lazygit.log()
      end,
      desc = "Lazygit log (git root)",
    },
  },
}
