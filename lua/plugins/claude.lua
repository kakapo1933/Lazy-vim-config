-- Claude AI Integration - Load directly without LazyVim plugin spec
-- This runs the setup immediately since it's a local configuration

local function setup_claude()
  -- Only setup if not already done
  if not _G.claude_setup_done then
    require("claude").setup()
    _G.claude_setup_done = true
  end
end

-- Setup Claude integration
setup_claude()

-- Return empty table to satisfy LazyVim's plugin loading
return {}