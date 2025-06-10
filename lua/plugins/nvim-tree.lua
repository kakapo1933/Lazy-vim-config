return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    -- disable netrw at the very start of your init.lua
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    -- set termguicolors to enable highlight groups
    vim.opt.termguicolors = true

    -- custom on_attach function
    local function my_on_attach(bufnr)
      local api = require("nvim-tree.api")

      local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      -- default mappings
      api.config.mappings.default_on_attach(bufnr)

      -- custom mappings
      vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
      vim.keymap.set("n", "<Right>", api.node.open.edit, opts("Open"))
      vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
      vim.keymap.set("n", "<Left>", api.node.navigate.parent_close, opts("Close Directory"))
    end

    -- setup with options
    require("nvim-tree").setup({
      on_attach = my_on_attach,
      sort = {
        sorter = "case_sensitive",
      },
      view = {
        width = 30,
      },
      auto_reload_on_write = true,
      reload_on_bufenter = true,
      renderer = {
        group_empty = true,
        highlight_git = "name",
        icons = {
          webdev_colors = true,
          git_placement = "after",
          padding = " ",
          symlink_arrow = " ➛ ",
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
          },
          glyphs = {
            git = {
              unstaged = "M",
              staged = "A",
              unmerged = "!",
              renamed = "R",
              untracked = "??",
              deleted = "✖",
              ignored = "◌",
            },
          },
        },
      },
      filters = {
        dotfiles = true,
      },
      git = {
        enable = true,
        ignore = false,
      },
    })

    -- Define custom colors for git states
    -- Use Catppuccin Macchiato colors
    -- Icon-specific colors (these are what actually color the git icons!)
    vim.api.nvim_set_hl(0, "NvimTreeGitDirtyIcon", { fg = "#f5a97f" }) -- M icon
    vim.api.nvim_set_hl(0, "NvimTreeGitStagedIcon", { fg = "#a6da95" }) -- A icon
    vim.api.nvim_set_hl(0, "NvimTreeGitNewIcon", { fg = "#8bd5ca" }) -- ?? icon
    vim.api.nvim_set_hl(0, "NvimTreeGitRenamedIcon", { fg = "#eed49f" })
    vim.api.nvim_set_hl(0, "NvimTreeGitDeletedIcon", { fg = "#ed8796" })
    vim.api.nvim_set_hl(0, "NvimTreeGitMergeIcon", { fg = "#fab387" })
    vim.api.nvim_set_hl(0, "NvimTreeGitIgnoredIcon", { fg = "#6c7086" })

    -- Also set the file name colors
    vim.api.nvim_set_hl(0, "NvimTreeGitFileDirtyHL", { fg = "#f5a97f" }) -- Modified
    vim.api.nvim_set_hl(0, "NvimTreeGitFileStagedHL", { fg = "#a6da95" }) -- Added
    vim.api.nvim_set_hl(0, "NvimTreeGitFileAddedHL", { fg = "#a6da95" }) -- Added files
    vim.api.nvim_set_hl(0, "NvimTreeGitFileNewHL", { fg = "#8bd5ca" })
    vim.api.nvim_set_hl(0, "NvimTreeGitFileRenamedHL", { fg = "#eed49f" })
    vim.api.nvim_set_hl(0, "NvimTreeGitFileDeletedHL", { fg = "#ed8796" })

    -- Auto-refresh git status
    local function refresh_git_status()
      local api = require("nvim-tree.api")
      if api.tree.is_visible() then
        api.tree.reload()
      end
    end
    
    -- Refresh on various events
    vim.api.nvim_create_autocmd({"BufWritePost", "BufEnter", "FocusGained"}, {
      callback = function()
        vim.defer_fn(refresh_git_status, 100)
      end,
    })
    
    -- Refresh after shell commands (git operations)
    vim.api.nvim_create_autocmd("TermClose", {
      callback = function()
        vim.defer_fn(refresh_git_status, 500)
      end,
    })
    
    -- Add manual refresh keybinding
    vim.keymap.set("n", "<leader>gr", refresh_git_status, { desc = "Refresh git status in tree" })
  end,
  keys = {
    { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file explorer" },
    { "<leader>fe", "<cmd>NvimTreeFindFileToggle<cr>", desc = "Find file in explorer" },
  },
}
