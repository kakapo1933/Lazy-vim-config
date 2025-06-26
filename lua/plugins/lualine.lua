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
        theme = "auto",
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
                n = { fg = "#363a4f", bg = "#89b4fa", gui = "bold" }, -- Normal
                i = { fg = "#363a4f", bg = "#a6e3a1", gui = "bold" }, -- Insert
                v = { fg = "#363a4f", bg = "#f5bde6", gui = "bold" }, -- Visual
                V = { fg = "#363a4f", bg = "#c6a0f6", gui = "bold" }, -- Visual Line
                c = { fg = "#363a4f", bg = "#eed49f", gui = "bold" }, -- Command
                R = { fg = "#363a4f", bg = "#ed8796", gui = "bold" }, -- Replace
              }
              return mode_colors[vim.fn.mode()] or mode_colors.n
            end,
            separator = { left = "\u{e0b6}", right = "\u{e0b4}" }, -- Rounded pill separators
          },
        },
        lualine_b = {
          {
            "branch",
            icon = "󰘬",
            color = function()
              local mode_colors = {
                n = { fg = "#89b4fa", bg = "#363a4f" }, -- Normal
                i = { fg = "#a6e3a1", bg = "#363a4f" }, -- Insert
                v = { fg = "#f5bde6", bg = "#363a4f" }, -- Visual
                V = { fg = "#c6a0f6", bg = "#363a4f" }, -- Visual Line
                c = { fg = "#eed49f", bg = "#363a4f" }, -- Command
                R = { fg = "#ed8796", bg = "#363a4f" }, -- Replace
              }
              return mode_colors[vim.fn.mode()] or mode_colors.n
            end,
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
          },
          {
            "filetype",
            icon_only = true,
            padding = { left = 1, right = 0 },
            separator = "",
            color = { bg = "#24273a" },
          },
          {
            "filename",
            path = 1,
            symbols = { modified = "  ", readonly = "", unnamed = "" },
            color = { fg = "", bg = "#24273a", gui = "bold" },
            separator = { left = "", right = "\u{e0b4}" }, -- Rounded pill separators
          },
        },
        lualine_x = {
          {
            function()
              return require("noice").api.status.command.get()
            end,
            cond = function()
              return package.loaded["noice"] and require("noice").api.status.command.has()
            end,
            color = function()
              return { fg = "#f5a97f", bg = "#24273a" }
            end,
            separator = { left = "\u{e0b6}", right = "" }, -- Rounded pill separators
          },
          {
            function()
              return require("noice").api.status.mode.get()
            end,
            cond = function()
              return package.loaded["noice"] and require("noice").api.status.mode.has()
            end,
            color = function()
              return { fg = "#ed8796" }
            end,
            separator = { left = "\u{e0b6}", right = "" }, -- Rounded pill separator
          },
          {
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
            color = function()
              return { fg = "#f5bde6", bg = "#24273a" }
            end,
            separator = { left = "\u{e0b6}", right = "" }, -- Rounded pill separator
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
            separator = { left = "\u{e0b6}", right = "" }, -- Rounded pill separator
          },
        },
        lualine_y = {
          {
            "progress",
            padding = { left = 1, right = 0 },
            color = function()
              local mode_colors = {
                n = { fg = "#89b4fa", bg = "#363a4f" }, -- Normal
                i = { fg = "#a6e3a1", bg = "#363a4f" }, -- Insert
                v = { fg = "#f5bde6", bg = "#363a4f" }, -- Visual
                V = { fg = "#c6a0f6", bg = "#363a4f" }, -- Visual Line
                c = { fg = "#eed49f", bg = "#363a4f" }, -- Command
                R = { fg = "#ed8796", bg = "#363a4f" }, -- Replace
              }
              return mode_colors[vim.fn.mode()] or mode_colors.n
            end,
          },
          {
            "location",
            padding = { left = 1, right = 1 },
            color = function()
              local mode_colors = {
                n = { fg = "#89b4fa", bg = "#363a4f" }, -- Normal
                i = { fg = "#a6e3a1", bg = "#363a4f" }, -- Insert
                v = { fg = "#f5bde6", bg = "#363a4f" }, -- Visual
                V = { fg = "#c6a0f6", bg = "#363a4f" }, -- Visual Line
                c = { fg = "#eed49f", bg = "#363a4f" }, -- Command
                R = { fg = "#ed8796", bg = "#363a4f" }, -- Replace
              }
              return mode_colors[vim.fn.mode()] or mode_colors.n
            end,
          },
        },
        lualine_z = {
          {
            function()
              return "󰥔 " .. os.date("%R")
            end,
            color = function()
              local mode_colors = {
                n = { fg = "#363a4f", bg = "#89b4fa", gui = "bold" }, -- Normal
                i = { fg = "#363a4f", bg = "#a6e3a1", gui = "bold" }, -- Insert
                v = { fg = "#363a4f", bg = "#f5bde6", gui = "bold" }, -- Visual
                V = { fg = "#363a4f", bg = "#c6a0f6", gui = "bold" }, -- Visual Line
                c = { fg = "#363a4f", bg = "#eed49f", gui = "bold" }, -- Command
                R = { fg = "#363a4f", bg = "#ed8796", gui = "bold" }, -- Replace
              }
              return mode_colors[vim.fn.mode()] or mode_colors.n
            end,
            separator = { left = "\u{e0b6}", right = "\u{e0b4}" }, -- Rounded pill separators
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
