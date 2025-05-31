-- Claude Neovim Integration Plugin
-- Provides floating terminal windows for real-time Claude AI interactions

local M = {}

-- Store active Claude terminals globally to persist across function calls
if not _G.claude_terminals then
  _G.claude_terminals = {}
end
local claude_terminals = _G.claude_terminals

-- Function to track Claude terminals
local function track_claude_terminal(buf, prompt)
  claude_terminals[buf] = {
    prompt = prompt,
    created_at = os.time(),
    pid = vim.api.nvim_buf_get_var(buf, "terminal_job_pid") or "unknown"
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
  local job_id = vim.fn.termopen(command, {
    on_exit = function(_, exit_code)
      if exit_code == 0 then
        -- Add instruction at the end (check if buffer is still modifiable)
        pcall(function()
          vim.api.nvim_buf_set_option(buf, 'modifiable', true)
          vim.api.nvim_buf_set_lines(buf, -1, -1, false, {'', '--- Press q or Esc to close ---'})
          vim.api.nvim_buf_set_option(buf, 'modifiable', false)
        end)
      end
      -- Remove from tracking when terminal exits
      claude_terminals[buf] = nil
    end
  })
  
  -- Track this terminal with job ID
  claude_terminals[buf] = {
    prompt = prompt,
    created_at = os.time(),
    job_id = job_id,
    pid = vim.fn.jobpid(job_id)
  }
  
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

    -- Create unique temporary file for this session
    local session_id = os.time() .. "_" .. math.random(1000, 9999)
    local temp_file = string.format("/tmp/nvim_claude_%s.txt", session_id)
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
    local session_id = os.time() .. "_" .. math.random(1000, 9999)
    local temp_file = string.format("/tmp/nvim_claude_line_%s.txt", session_id)
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
      local session_id = os.time() .. "_" .. math.random(1000, 9999)
      local temp_file = string.format("/tmp/nvim_claude_error_%s.txt", session_id)
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
    
    for buf, info in pairs(claude_terminals) do
      local is_valid = vim.api.nvim_buf_is_valid(buf)
      local job_running = info.job_id and vim.fn.jobwait({info.job_id}, 0)[1] == -1
      
      if is_valid and job_running then
        table.insert(active_terminals, {
          buf = buf,
          prompt = info.prompt,
          age = os.time() - info.created_at,
          pid = info.pid,
          job_id = info.job_id
        })
      else
        claude_terminals[buf] = nil  -- Clean up invalid or finished terminals
      end
    end
    
    if #active_terminals == 0 then
      vim.notify("No active Claude terminals found", vim.log.levels.INFO)
      return
    end
    
    -- Create a floating window to display the list
    local buf = vim.api.nvim_create_buf(false, true)
    
    -- Build content for the buffer
    local content = {}
    table.insert(content, "Active Claude Terminals (" .. #active_terminals .. ")")
    table.insert(content, string.rep("=", 50))
    table.insert(content, "")
    
    for i, term in ipairs(active_terminals) do
      local age_str = string.format("%dm%ds", math.floor(term.age / 60), term.age % 60)
      table.insert(content, string.format("%d. %s (running for %s)", i, term.prompt, age_str))
    end
    
    table.insert(content, "")
    table.insert(content, "Press number to select, or Esc to cancel")
    
    -- Set buffer content
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
    vim.api.nvim_buf_set_option(buf, 'modifiable', false)
    
    -- Create floating window
    local width = math.floor(vim.o.columns * 0.6)
    local height = #content + 2
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
      title = ' Claude Terminals ',
      title_pos = 'center'
    }
    
    local win = vim.api.nvim_open_win(buf, true, opts)
    
    -- Set up key mappings for selection
    local function close_and_select(choice_num)
      vim.api.nvim_win_close(win, true)
      if choice_num and active_terminals[choice_num] then
        local selected = active_terminals[choice_num]
        -- Create new floating window for existing terminal
        local term_width = math.floor(vim.o.columns * 0.8)
        local term_height = math.floor(vim.o.lines * 0.8)
        local term_row = math.floor((vim.o.lines - term_height) / 2)
        local term_col = math.floor((vim.o.columns - term_width) / 2)

        local term_opts = {
          relative = 'editor',
          width = term_width,
          height = term_height,
          row = term_row,
          col = term_col,
          style = 'minimal',
          border = 'rounded',
          title = ' Claude Processing: ' .. selected.prompt .. ' ',
          title_pos = 'center'
        }

        local term_win = vim.api.nvim_open_win(selected.buf, true, term_opts)
        
        -- Set up keymaps for the reconnected window
        vim.api.nvim_buf_set_keymap(selected.buf, 'n', 'q', '<cmd>close<cr>', { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(selected.buf, 'n', '<Esc>', '<cmd>close<cr>', { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(selected.buf, 't', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })
      end
    end
    
    -- Set up key mappings
    for i = 1, #active_terminals do
      vim.api.nvim_buf_set_keymap(buf, 'n', tostring(i), '', {
        noremap = true,
        silent = true,
        callback = function() close_and_select(i) end
      })
    end
    
    vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', '', {
      noremap = true,
      silent = true,
      callback = function() vim.api.nvim_win_close(win, true) end
    })
    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '', {
      noremap = true,
      silent = true,
      callback = function() vim.api.nvim_win_close(win, true) end
    })
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

  -- Command to show terminals without reconnection prompt
  vim.api.nvim_create_user_command("ClaudeShow", function()
    local active_terminals = {}
    
    for buf, info in pairs(claude_terminals) do
      local is_valid = vim.api.nvim_buf_is_valid(buf)
      local job_running = info.job_id and vim.fn.jobwait({info.job_id}, 0)[1] == -1
      
      if is_valid and job_running then
        table.insert(active_terminals, {
          buf = buf,
          prompt = info.prompt,
          age = os.time() - info.created_at,
          pid = info.pid,
          job_id = info.job_id
        })
      else
        claude_terminals[buf] = nil
      end
    end
    
    if #active_terminals == 0 then
      print("No active Claude terminals found")
      return
    end
    
    print(string.format("\n=== Active Claude Terminals (%d) ===", #active_terminals))
    for i, term in ipairs(active_terminals) do
      local age_str = string.format("%dm%ds", math.floor(term.age / 60), term.age % 60)
      print(string.format("%d. %s (running for %s)", i, term.prompt, age_str))
    end
    print("======================================")
  end, { desc = "Show active Claude terminals" })

  -- Debug command to check global state
  vim.api.nvim_create_user_command("ClaudeDebugState", function()
    print("DEBUG: Global claude_terminals state:")
    local count = 0
    for buf, info in pairs(_G.claude_terminals) do
      count = count + 1
      print(string.format("  buf=%d: prompt='%s', pid=%s, created=%s", 
        buf, info.prompt, tostring(info.pid), os.date("%H:%M:%S", info.created_at)))
    end
    print(string.format("Total: %d terminals in global state", count))
  end, { desc = "Debug Claude terminal global state" })
end

return M