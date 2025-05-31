-- Claude Neovim Integration Plugin
-- Provides floating terminal windows for real-time Claude AI interactions

local M = {}

-- Store active Claude terminals
local claude_terminals = {}

-- Function to track Claude terminals
local function track_claude_terminal(buf, prompt)
  claude_terminals[buf] = {
    prompt = prompt,
    created_at = os.time()
  }
end

-- Check if Claude CLI is installed
local function check_claude_cli()
  local result = vim.fn.system("which claude")
  if vim.v.shell_error ~= 0 then
    vim.notify("Claude CLI not found. Install with: curl -fsSL https://claude.ai/install.sh | sh", vim.log.levels.ERROR)
    return false
  end
  return true
end

-- Function to create a floating terminal window for Claude processing
function M.create_claude_terminal(command, prompt)
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local buf = vim.api.nvim_create_buf(false, true)
  
  local opts = {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
    title = ' Claude Processing: ' .. prompt .. ' ',
    title_pos = 'center'
  }

  local win = vim.api.nvim_open_win(buf, true, opts)
  
  -- Key mappings for the floating terminal
  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '<cmd>close<cr>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', '<cmd>close<cr>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 't', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })
  
  -- Start terminal in the buffer
  vim.fn.termopen(command, {
    on_exit = function(_, exit_code)
      if exit_code == 0 then
        -- Add instruction at the end
        vim.api.nvim_buf_set_lines(buf, -1, -1, false, {'', '--- Press q or Esc to close ---'})
      end
      -- Remove from tracking when terminal exits
      claude_terminals[buf] = nil
    end
  })
  
  -- Track this terminal
  track_claude_terminal(buf, prompt)
  
  -- Enter insert mode to show live output
  vim.cmd('startinsert')
  
  return win, buf
end

-- Function to send visual selection to Claude using floating terminal
function M.send_to_claude(prompt)
  return function()
    if not check_claude_cli() then return end
    
    -- Get visual selection using vim's built-in function
    vim.cmd('normal! "vy')
    local selection = vim.fn.getreg('v')

    -- Write selection to temporary file
    local temp_file = "/tmp/nvim_claude_selection.txt"
    local file = io.open(temp_file, "w")
    if file then
      file:write(selection)
      file:close()

      -- Create floating terminal with Claude command
      local command = string.format('echo "%s:" | cat - %s | claude', prompt, temp_file)
      M.create_claude_terminal(command, prompt)
    else
      print("Error: Could not create temporary file")
    end
  end
end

-- Setup function to initialize commands and keymaps
function M.setup()
  local keymap = vim.keymap.set

  -- Send selection for explanation
  keymap("v", "<leader>ce", M.send_to_claude("Explain this code"), { desc = "Claude: Explain selection" })

  -- Send selection for review
  keymap("v", "<leader>cr", M.send_to_claude("Review this code for bugs and improvements"), { desc = "Claude: Review selection" })

  -- Send selection for optimization
  keymap("v", "<leader>co", M.send_to_claude("Optimize this code"), { desc = "Claude: Optimize selection" })

  -- Send selection for refactoring
  keymap("v", "<leader>cf", M.send_to_claude("Refactor this code to be more readable"), { desc = "Claude: Refactor selection" })

  -- Send selection for testing
  keymap("v", "<leader>ct", M.send_to_claude("Write unit tests for this code"), { desc = "Claude: Generate tests" })

  -- Send selection for documentation
  keymap("v", "<leader>cd", M.send_to_claude("Add comprehensive comments to this code"), { desc = "Claude: Add documentation" })

  -- Send selection with custom prompt
  keymap("v", "<leader>cp", function()
    local prompt = vim.fn.input("Claude prompt: ")
    if prompt ~= "" then
      M.send_to_claude(prompt)()
    end
  end, { desc = "Claude: Custom prompt" })

  -- Send entire buffer to Claude
  keymap("n", "<leader>cb", function()
    if not check_claude_cli() then return end
    
    local filename = vim.fn.expand("%")
    local command = string.format('echo "Review this entire file:" | cat - %s | claude', filename)
    M.create_claude_terminal(command, "Review this entire file")
  end, { desc = "Claude: Review entire file" })

  -- Quick commands for common tasks
  vim.api.nvim_create_user_command("ClaudeExplain", function()
    if not check_claude_cli() then return end
    
    local selection = vim.fn.getline(".")
    local temp_file = "/tmp/nvim_claude_line.txt"
    local file = io.open(temp_file, "w")
    if file then
      file:write(selection)
      file:close()
      
      local command = string.format('echo "Explain this line of code:" | cat - %s | claude', temp_file)
      M.create_claude_terminal(command, "Explain this line of code")
    end
  end, { desc = "Explain current line with Claude" })

  vim.api.nvim_create_user_command("ClaudeDebug", function()
    if not check_claude_cli() then return end
    
    local filename = vim.fn.expand("%")
    local line_num = vim.fn.line(".")
    local debug_prompt = string.format("Debug this file, focus on line %d", line_num)
    local command = string.format('echo "%s:" | cat - %s | claude', debug_prompt, filename)
    
    M.create_claude_terminal(command, debug_prompt)
  end, { desc = "Debug current file with Claude" })

  -- Function to get Claude help for error messages
  keymap("n", "<leader>ch", function()
    if not check_claude_cli() then return end
    
    local error_msg = vim.fn.input("Paste error message: ")
    if error_msg ~= "" then
      local temp_file = "/tmp/nvim_claude_error.txt"
      local file = io.open(temp_file, "w")
      if file then
        file:write(error_msg)
        file:close()
        
        local command = string.format('echo "Help me fix this error:" | cat - %s | claude', temp_file)
        M.create_claude_terminal(command, "Help me fix this error")
      end
    end
  end, { desc = "Claude: Help with error" })

  -- Command to list active Claude terminals
  vim.api.nvim_create_user_command("ClaudeList", function()
    local active_terminals = {}
    
    -- Debug: Show total tracked terminals
    local total_tracked = 0
    for _ in pairs(claude_terminals) do
      total_tracked = total_tracked + 1
    end
    print(string.format("Debug: %d terminals tracked", total_tracked))
    
    for buf, info in pairs(claude_terminals) do
      print(string.format("Debug: Buffer %d, valid: %s, prompt: %s", buf, tostring(vim.api.nvim_buf_is_valid(buf)), info.prompt))
      if vim.api.nvim_buf_is_valid(buf) then
        table.insert(active_terminals, {
          buf = buf,
          prompt = info.prompt,
          age = os.time() - info.created_at
        })
      else
        claude_terminals[buf] = nil  -- Clean up invalid buffers
      end
    end
    
    if #active_terminals == 0 then
      print("No active Claude terminals found")
      return
    end
    
    print("Active Claude terminals:")
    for i, term in ipairs(active_terminals) do
      local age_str = string.format("%dm%ds", math.floor(term.age / 60), term.age % 60)
      print(string.format("%d. %s (running for %s)", i, term.prompt, age_str))
    end
    
    local choice = vim.fn.input("Enter number to reconnect (or press Enter to cancel): ")
    if choice ~= "" and tonumber(choice) then
      local selected = active_terminals[tonumber(choice)]
      if selected then
        -- Create new floating window for existing terminal
        local width = math.floor(vim.o.columns * 0.8)
        local height = math.floor(vim.o.lines * 0.8)
        local row = math.floor((vim.o.lines - height) / 2)
        local col = math.floor((vim.o.columns - width) / 2)

        local opts = {
          relative = 'editor',
          width = width,
          height = height,
          row = row,
          col = col,
          style = 'minimal',
          border = 'rounded',
          title = ' Claude Processing: ' .. selected.prompt .. ' ',
          title_pos = 'center'
        }

        local win = vim.api.nvim_open_win(selected.buf, true, opts)
        
        -- Set up keymaps for the reconnected window
        vim.api.nvim_buf_set_keymap(selected.buf, 'n', 'q', '<cmd>close<cr>', { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(selected.buf, 'n', '<Esc>', '<cmd>close<cr>', { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(selected.buf, 't', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })
      end
    end
  end, { desc = "List and reconnect to Claude terminals" })

  -- Command to kill all Claude terminals
  vim.api.nvim_create_user_command("ClaudeKillAll", function()
    local count = 0
    for buf, _ in pairs(claude_terminals) do
      if vim.api.nvim_buf_is_valid(buf) then
        vim.api.nvim_buf_delete(buf, { force = true })
        count = count + 1
      end
      claude_terminals[buf] = nil
    end
    print(string.format("Killed %d Claude terminal(s)", count))
  end, { desc = "Kill all Claude terminals" })

  -- Add keymapping for quick access
  keymap("v", "<leader>cl", "<cmd>ClaudeList<cr>", { desc = "Claude: List terminals" })
end

return M