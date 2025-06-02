-- Claude Code Integration from GitHub
return {
  "kakapo1933/kaipo-claude-code.nvim",
  config = function()
    require("claude").setup()
  end,
}

-- Commented out local development version
--[[
return {
  dir = "/Users/kaipochen/Desktop/Home/kaipo-claude-code.nvim",
  name = "kaipo-claude-code.nvim",
  config = function()
    require("claude").setup()
  end,
}
--]]