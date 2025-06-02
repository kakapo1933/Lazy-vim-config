return {
  {
    "nvim-neorocks/rocks.nvim",
    priority = 1000,
    config = function()
      require("rocks").setup({
        rocks_path = vim.fs.normalize("~/.local/share/nvim/rocks"),
        luarocks_binary = "luarocks",
      })
    end,
    build = function()
      vim.g.rocks_nvim = {
        rocks_path = vim.fs.normalize("~/.local/share/nvim/rocks"),
      }
    end,
  },
}