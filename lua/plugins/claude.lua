-- Claude Code Integration (Local Development)
return {
  "kakapo1933/kaipo-claude-code.nvim",
  -- dev = true,
  config = function()
    require("claude").setup()
  end,
}

