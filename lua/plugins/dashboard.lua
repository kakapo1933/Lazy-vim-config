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
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    enabled = false,
    opts = function()
      -- Generate header with pokemon
      local function generate_header()
        local header_lines = {
          "",
          "",
          "██╗  ██╗ █████╗ ██╗██████╗  ██████╗ ██╗  ██╗███████╗███╗   ███╗ ██████╗ ███╗   ██╗",
          "██║ ██╔╝██╔══██╗██║██╔══██╗██╔═══██╗██║ ██╔╝██╔════╝████╗ ████║██╔═══██╗████╗  ██║",
          "█████╔╝ ███████║██║██████╔╝██║   ██║█████╔╝ █████╗  ██╔████╔██║██║   ██║██╔██╗ ██║",
          "██╔═██╗ ██╔══██║██║██╔═══╝ ██║   ██║██╔═██╗ ██╔══╝  ██║╚██╔╝██║██║   ██║██║╚██╗██║",
          "██║  ██╗██║  ██║██║██║     ╚██████╔╝██║  ██╗███████╗██║ ╚═╝ ██║╚██████╔╝██║ ╚████║",
          "╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝      ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝",
          "",
          "                        🔥 Gotta Code 'Em All! 🔥",
          "",
        }
        
        -- Add placeholder for terminal Pokemon
        table.insert(header_lines, "        [Random Pokemon will appear here]")
        table.insert(header_lines, "")
        
        table.insert(header_lines, "")
        return header_lines
      end

      local opts = {
        theme = "doom",
        hide = {
          statusline = false,
        },
        config = {
          header = generate_header(),
          center = {
            { action = "Telescope find_files", desc = "Find File", icon = " ", key = "f" },
            { action = "ene | startinsert", desc = "New File", icon = " ", key = "n" },
            { action = "Telescope oldfiles", desc = "Recent Files", icon = " ", key = "r" },
            { action = "Telescope live_grep", desc = "Find Text", icon = " ", key = "g" },
            { action = 'lua require("persistence").load()', desc = "Restore Session", icon = " ", key = "s" },
            { action = "e $MYVIMRC", desc = "Config", icon = " ", key = "c" },
            { action = "Lazy", desc = "Lazy", icon = "󰒲 ", key = "l" },
            { action = "LazyExtras", desc = "Lazy Extras", icon = " ", key = "x" },
            { action = "qa", desc = "Quit", icon = " ", key = "q" },
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
    config = function(_, opts)
      require("dashboard").setup(opts)
      
      -- Display Pokemon in terminal after dashboard loads
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "dashboard",
        callback = function()
          vim.defer_fn(function()
            vim.cmd("terminal pokemon-colorscripts -r --no-title")
            vim.cmd("startinsert!")
          end, 100)
        end,
      })
    end,
  },
}