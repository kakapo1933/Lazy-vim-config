-- Claude AI Integration Plugin for LazyVim
return {
  name = "claude-integration",
  dev = true,
  config = function()
    require("claude").setup()
  end,
  keys = {
    { "<leader>ce", mode = "v", desc = "Claude: Explain selection" },
    { "<leader>cr", mode = "v", desc = "Claude: Review selection" },
    { "<leader>co", mode = "v", desc = "Claude: Optimize selection" },
    { "<leader>cf", mode = "v", desc = "Claude: Refactor selection" },
    { "<leader>ct", mode = "v", desc = "Claude: Generate tests" },
    { "<leader>cd", mode = "v", desc = "Claude: Add documentation" },
    { "<leader>cp", mode = "v", desc = "Claude: Custom prompt" },
    { "<leader>cl", mode = "v", desc = "Claude: List terminals" },
    { "<leader>cb", mode = "n", desc = "Claude: Review entire file" },
    { "<leader>ch", mode = "n", desc = "Claude: Help with error" },
  },
  cmd = {
    "ClaudeExplain",
    "ClaudeDebug", 
    "ClaudeList",
    "ClaudeShow",
    "ClaudeKillAll",
    "ClaudeDebugState",
  },
}