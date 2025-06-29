-- LazyVim default lualine configuration
return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      -- set an empty statusline till lualine loads
      vim.o.statusline = " "
    else
      -- hide the statusline on the starter page
      vim.o.laststatus = 0
    end
  end,
  opts = function()
    -- PERF: we don't need this lualine require madness 🤷
    local lualine_require = require("lualine_require")
    lualine_require.require = require

    local icons = require("lazyvim.config").icons

    vim.o.laststatus = vim.g.lualine_laststatus

    return {
      options = {
        theme = "catppuccin",
        globalstatus = true,
        disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
        section_separators = { left = "\u{e0b4}", right = "\u{e0b6}" },
        component_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = {
          {
            "mode",
            color = function()
              local mode_colors = {
                n = { fg = "#1e1e2e", bg = "#b4befe", gui = "bold" }, -- Normal
                i = { fg = "#1e1e2e", bg = "#a6e3a1", gui = "bold" }, -- Insert
                v = { fg = "#1e1e2e", bg = "#f5c2e7", gui = "bold" }, -- Visual
                V = { fg = "#1e1e2e", bg = "#cba6f7", gui = "bold" }, -- Visual Line
                c = { fg = "#1e1e2e", bg = "#f9e2af", gui = "bold" }, -- Command
                R = { fg = "#1e1e2e", bg = "#f38ba8", gui = "bold" }, -- Replace
              }
              return mode_colors[vim.fn.mode()] or mode_colors.n
            end,
            separator = { left = "\u{e0b6}", right = "\u{e0b4}" }, -- Rounded pill separators
            padding = { left = 2, right = 2 },
          },
        },
        lualine_b = {
          {
            function()
              local branch = vim.fn.system("git branch --show-current 2>/dev/null"):gsub("\n", "")
              if vim.v.shell_error ~= 0 or branch == "" then
                return "󰘬"
              else
                return "󰘬 " .. branch
              end
            end,
            color = function()
              local mode_colors = {
                n = { fg = "#b4befe", bg = "#313244" }, -- Normal
                i = { fg = "#a6e3a1", bg = "#313244" }, -- Insert
                v = { fg = "#f5c2e7", bg = "#313244" }, -- Visual
                V = { fg = "#cba6f7", bg = "#313244" }, -- Visual Line
                c = { fg = "#f9e2af", bg = "#313244" }, -- Command
                R = { fg = "#f38ba8", bg = "#313244" }, -- Replace
              }
              return mode_colors[vim.fn.mode()] or mode_colors.n
            end,
            padding = { left = 2, right = 2 },
            separator = { left = "", right = "" },
          },
        },
        lualine_c = {
          {
            "diagnostics",
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
            },
            color = { bg = "#24273a" },
            padding = { left = 2, right = 0 },
            separator = { left = "\u{e0b6}", right = "" },
          },
          {
            function()
              return "󰈙"
            end,
            color = { fg = "#bac2de", bg = "#24273a" },
            separator = { left = "\u{e0b6}", right = "\u{e0b4}" }, -- Rounded pill separators
            padding = { left = 2, right = 0 },
          },

          {
            "filename",
            path = 1,
            symbols = { modified = "  ", readonly = "", unnamed = "" },
            color = { fg = "#b4befe", bg = "#24273a" },
            separator = { left = "\u{e0b6}", right = "\u{e0b4}" }, -- Rounded pill separators
            padding = { left = 1, right = 2 },
          },
        },
        lualine_x = {
          {
            function()
              return "[" .. require("noice").api.status.command.get() .. "]"
            end,
            cond = function()
              return package.loaded["noice"] and require("noice").api.status.command.has()
            end,
            color = function()
              return { fg = "#fab387", bg = "#24273a", gui = "bold" }
            end,
            separator = { left = "\u{e0b6}", right = "\u{e0b4}" }, -- Rounded pill separators
            padding = { left = 2, right = 0 },
          },
          {
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
            color = function()
              return { fg = "#f5c2e7", bg = "#24273a" }
            end,
            separator = { left = "\u{e0b6}", right = "\u{e0b4}" }, -- Rounded pill separator
            padding = { left = 2, right = 0 },
          },
          {
            "diff",
            symbols = {
              added = icons.git.added,
              modified = icons.git.modified,
              removed = icons.git.removed,
            },
            color = function()
              return { bg = "#24273a" }
            end,
            separator = { left = "\u{e0b6}", right = "\u{e0b4}" }, -- Rounded pill separator
            padding = { left = 2, right = 0 },
          },
          -- File encoding
          {
            "encoding",
            color = function()
              return { fg = "#b4befe", bg = "#24273a" }
            end,
            separator = { left = "\u{e0b6}", right = "\u{e0b4}" },
            padding = { left = 2, right = 0 },
          },
          -- Current language
          {
            "filetype",
            icon_only = true,
            padding = { left = 2, right = 0 },
            color = { fg = "#b4befe", bg = "#24273a" },
            separator = { left = "\u{e0b6}", right = "\u{e0b4}" }, -- Rounded pill separators
          },
          {
            function()
              local ft = vim.bo.filetype
              if ft == "" then
                return "plaintext"
              end
              return ft
            end,
            color = function()
              return { fg = "#b4befe", bg = "#24273a" }
            end,
            separator = { left = "\u{e0b6}", right = "\u{e0b4}" },
            padding = { left = 0, right = 2 },
          },
        },
        lualine_y = {
          {
            function()
              return ""
            end,
            color = function()
              local mode_colors = {
                n = { fg = "#b4befe", bg = "#313244" }, -- Normal
                i = { fg = "#a6e3a1", bg = "#313244" }, -- Insert
                v = { fg = "#f5c2e7", bg = "#313244" }, -- Visual
                V = { fg = "#cba6f7", bg = "#313244" }, -- Visual Line
                c = { fg = "#f9e2af", bg = "#313244" }, -- Command
                R = { fg = "#f38ba8", bg = "#313244" }, -- Replace
              }
              return mode_colors[vim.fn.mode()] or mode_colors.n
            end,
            padding = { left = 2, right = 1 },
          },
          {
            "progress",
            padding = { left = 0, right = 0 },
            color = function()
              local mode_colors = {
                n = { fg = "#b4befe", bg = "#313244" }, -- Normal
                i = { fg = "#a6e3a1", bg = "#313244" }, -- Insert
                v = { fg = "#f5c2e7", bg = "#313244" }, -- Visual
                V = { fg = "#cba6f7", bg = "#313244" }, -- Visual Line
                c = { fg = "#f9e2af", bg = "#313244" }, -- Command
                R = { fg = "#f38ba8", bg = "#313244" }, -- Replace
              }
              return mode_colors[vim.fn.mode()] or mode_colors.n
            end,
            separator = { left = "\u{e0b6}", right = "" },
          },
          {
            "location",
            color = function()
              local mode_colors = {
                n = { fg = "#b4befe", bg = "#313244" }, -- Normal
                i = { fg = "#a6e3a1", bg = "#313244" }, -- Insert
                v = { fg = "#f5c2e7", bg = "#313244" }, -- Visual
                V = { fg = "#cba6f7", bg = "#313244" }, -- Visual Line
                c = { fg = "#f9e2af", bg = "#313244" }, -- Command
                R = { fg = "#f38ba8", bg = "#313244" }, -- Replace
              }
              return mode_colors[vim.fn.mode()] or mode_colors.n
            end,
            padding = { left = 1, right = 2 },
          },
        },
        lualine_z = {
          {
            function()
              return "󰥔 " .. os.date("%H:%M:%S")
            end,
            color = function()
              local mode_colors = {
                n = { fg = "#1e1e2e", bg = "#b4befe", gui = "bold" }, -- Normal
                i = { fg = "#1e1e2e", bg = "#a6e3a1", gui = "bold" }, -- Insert
                v = { fg = "#1e1e2e", bg = "#f5c2e7", gui = "bold" }, -- Visual
                V = { fg = "#1e1e2e", bg = "#cba6f7", gui = "bold" }, -- Visual Line
                c = { fg = "#1e1e2e", bg = "#f9e2af", gui = "bold" }, -- Command
                R = { fg = "#1e1e2e", bg = "#f38ba8", gui = "bold" }, -- Replace
              }
              return mode_colors[vim.fn.mode()] or mode_colors.n
            end,
            separator = { left = "\u{e0b6}", right = "\u{e0b4}" }, -- Rounded pill separators
            padding = { left = 2, right = 2 },
          },
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
    }
  end,
}
