return {
  {
    "nvim-neorocks/rocks.nvim",
    priority = 1000,
    config = true,
    opts = {
      rocks_path = vim.fs.normalize("~/.local/share/nvim/rocks"),
      luarocks_binary = "luarocks",
    },
  },
}