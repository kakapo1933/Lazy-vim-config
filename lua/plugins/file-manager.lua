-- File Manager Configuration: Replace Neo-tree with Yazi
return {
  -- Disable LazyVim's default neo-tree
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
  },
  
  -- Add Yazi integration
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    keys = {
      -- Replace neo-tree keybind
      { "<leader>e", "<cmd>Yazi<cr>", desc = "Open Yazi file manager" },
      -- Additional useful keybinds
      { "<leader>E", "<cmd>Yazi cwd<cr>", desc = "Open Yazi in current working directory" },
      { "<leader>fe", "<cmd>Yazi<cr>", desc = "File Explorer (Yazi)" },
    },
    opts = {
      -- Open Yazi when opening a directory with nvim
      open_for_directories = true,
      -- Keymaps that will be used in the floating yazi window
      keymaps = {
        show_help = '<f1>',
        open_file_in_vertical_split = '<c-v>',
        open_file_in_horizontal_split = '<c-x>',
        open_file_in_tab = '<c-t>',
        grep_in_directory = '<c-s>',
        replace_in_directory = '<c-g>',
        cycle_open_buffers = '<tab>',
        copy_relative_path_to_selected_files = '<c-y>',
        send_to_quickfix_list = '<c-q>',
      },
      -- Floating window configuration
      floating_window_scaling_factor = 0.9,
      yazi_floating_window_winblend = 0,
      yazi_floating_window_border = "rounded",
    },
  },
}
