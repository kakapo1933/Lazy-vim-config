return {
  "rest-nvim/rest.nvim",
  dependencies = { 
    "nvim-lua/plenary.nvim",
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function()
        require("nvim-treesitter.configs").setup({
          ensure_installed = { "http", "json" },
          auto_install = true,
        })
      end,
    },
  },
  ft = "http",
  config = function()
    require("rest-nvim").setup({
      result_split_in_place = false,
      result_split_horizontal = false,
      skip_ssl_verification = false,
      encode_url = true,
      highlight = {
        enabled = true,
        timeout = 150,
      },
      result = {
        show_url = true,
        show_curl_command = false,
        show_http_info = true,
        show_headers = true,
        show_statistics = false,
        formatters = {
          json = "jq",
          html = function(body)
            return vim.fn.system({ "tidy", "-i", "-q", "-" }, body)
          end
        },
      },
      jump_to_request = false,
      env_file = '.env',
      custom_dynamic_variables = {},
      yank_dry_run = true,
    })
  end
}