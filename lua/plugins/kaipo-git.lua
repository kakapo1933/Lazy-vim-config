return {
  "nvim-telescope/telescope.nvim", -- We still use telescope for git_branches
  event = "VeryLazy",
  config = function()
    vim.schedule(function()
      if pcall(require, "which-key") then
        local wk = require("which-key")
        wk.add({
          { "<leader>gB", group = "Branch" },
          { "<leader>gw", group = "Worktree" },
          { "<leader>gl", group = "Log" }
        })
      end
    end)
  end,
  keys = {
    {
      "<leader>gBb",
      ":Telescope git_branches<CR>",
      desc = "Browse branches",
    },
    {
      "<leader>gww",
      function()
        local handle = io.popen("git worktree list")
        if not handle then
          vim.notify("Failed to execute git worktree list", vim.log.levels.ERROR)
          return
        end
        local result = handle:read("*a")
        handle:close()

        local worktrees = {}
        for line in result:gmatch("[^\r\n]+") do
          local path = line:match("^(%S+)")
          if path then
            table.insert(worktrees, path)
          end
        end

        if #worktrees <= 1 then
          vim.notify("Only one worktree exists. Create more with <leader>gwc", vim.log.levels.INFO)
          return
        end

        vim.ui.select(worktrees, {
          prompt = "Switch to worktree:",
        }, function(choice)
          if choice then
            vim.cmd("cd " .. vim.fn.fnameescape(choice))
            vim.cmd("edit .")
            vim.notify("Switched to: " .. choice, vim.log.levels.INFO)
          end
        end)
      end,
      desc = "Switch worktree",
    },
    {
      "<leader>gwc",
      function()
        vim.ui.input({ prompt = "Branch name: " }, function(branch)
          if not branch or branch == "" then return end

          vim.ui.input({ prompt = "Worktree path: " }, function(path)
            if not path or path == "" then return end

            local cmd = string.format("git worktree add %s -b %s",
              vim.fn.shellescape(path), vim.fn.shellescape(branch))
            vim.cmd("!" .. cmd)
            vim.notify("Created worktree: " .. path .. " [" .. branch .. "]", vim.log.levels.INFO)
          end)
        end)
      end,
      desc = "Create worktree",
    },
    {
      "<leader>gwd",
      function()
        local handle = io.popen("git worktree list")
        if not handle then
          vim.notify("Failed to execute git worktree list", vim.log.levels.ERROR)
          return
        end
        local result = handle:read("*a")
        handle:close()

        local worktrees = {}
        local current_dir = vim.fn.getcwd()

        for line in result:gmatch("[^\r\n]+") do
          local path = line:match("^(%S+)")
          local branch = line:match("%[(.-)%]")
          if path and path ~= current_dir then
            table.insert(worktrees, {
              path = path,
              display = path .. (branch and " [" .. branch .. "]" or "")
            })
          end
        end

        if #worktrees == 0 then
          vim.notify("No other worktrees to delete", vim.log.levels.INFO)
          return
        end

        local display_items = {}
        for _, wt in ipairs(worktrees) do
          table.insert(display_items, wt.display)
        end

        vim.ui.select(display_items, {
          prompt = "Select worktree to delete:",
        }, function(choice)
          if choice then
            local selected_path
            for _, wt in ipairs(worktrees) do
              if wt.display == choice then
                selected_path = wt.path
                break
              end
            end

            if selected_path then
              vim.ui.input({
                prompt = "Delete '" .. selected_path .. "'? (y/N): "
              }, function(confirm)
                if confirm and confirm:lower() == "y" then
                  vim.cmd("!git worktree remove " .. vim.fn.shellescape(selected_path))
                  vim.notify("Deleted worktree: " .. selected_path, vim.log.levels.INFO)
                end
              end)
            end
          end
        end)
      end,
      desc = "Delete worktree",
    },
    {
      "<leader>gBd",
      function()
        local handle = io.popen("git branch")
        if not handle then
          vim.notify("Failed to execute git branch", vim.log.levels.ERROR)
          return
        end
        local result = handle:read("*a")
        handle:close()

        local branches = {}

        for line in result:gmatch("[^\r\n]+") do
          if line:match("^%s*%*") then
            -- Current branch (skip it)
          elseif not line:match("^%s*$") and not line:match("origin/") then
            -- Local branch (not current, not empty, not remote)
            local branch = line:match("^%s*(.+)$")
            if branch and branch ~= "" then
              table.insert(branches, branch)
            end
          end
        end

        if #branches == 0 then
          vim.notify("No other branches to delete", vim.log.levels.INFO)
          return
        end

        vim.ui.select(branches, {
          prompt = "Select branch to delete:",
        }, function(choice)
          if choice then
            vim.ui.input({
              prompt = "Delete branch '" .. choice .. "'? (y/N): "
            }, function(confirm)
              if confirm and confirm:lower() == "y" then
                local cmd = "git branch -d " .. vim.fn.shellescape(choice)
                local delete_handle = io.popen(cmd .. " 2>&1")
                if not delete_handle then
                  vim.notify("Failed to execute git branch delete command", vim.log.levels.ERROR)
                  return
                end
                local delete_result = delete_handle:read("*a")
                delete_handle:close()

                -- Check if the result contains error messages
                if delete_result:match("error:") or delete_result:match("Cannot delete") or delete_result:match("not fully merged") then
                  vim.notify("Failed to delete branch: " .. delete_result:gsub("\n$", ""), vim.log.levels.ERROR)
                else
                  vim.notify("Deleted branch: " .. choice, vim.log.levels.INFO)
                end
              end
            end)
          end
        end)
      end,
      desc = "Delete branch",
    },
    {
      "<leader>gBc",
      function()
        vim.ui.input({ prompt = "New branch name: " }, function(branch_name)
          if not branch_name or branch_name == "" then return end

          vim.ui.select(
            { "Create from current branch", "Create from master", "Create from other branch" },
            { prompt = "Create branch from:" },
            function(choice)
              if not choice then return end

              local cmd
              if choice == "Create from current branch" then
                cmd = "git checkout -b " .. vim.fn.shellescape(branch_name)
              elseif choice == "Create from master" then
                cmd = "git checkout -b " .. vim.fn.shellescape(branch_name) .. " master"
              else
                vim.ui.input({ prompt = "Base branch name: " }, function(base_branch)
                  if base_branch and base_branch ~= "" then
                    cmd = "git checkout -b " .. vim.fn.shellescape(branch_name) .. " " .. vim.fn.shellescape(base_branch)
                    local create_handle = io.popen(cmd .. " 2>&1")
                    if not create_handle then
                      vim.notify("Failed to execute git checkout command", vim.log.levels.ERROR)
                      return
                    end
                    local create_result = create_handle:read("*a")
                    create_handle:close()

                    if create_result:match("error:") or create_result:match("fatal:") then
                      vim.notify("Failed to create branch: " .. create_result:gsub("\n$", ""), vim.log.levels.ERROR)
                    else
                      vim.notify("Created and switched to branch: " .. branch_name, vim.log.levels.INFO)
                    end
                  end
                end)
                return
              end

              if cmd then
                local final_handle = io.popen(cmd .. " 2>&1")
                if not final_handle then
                  vim.notify("Failed to execute git checkout command", vim.log.levels.ERROR)
                  return
                end
                local final_result = final_handle:read("*a")
                final_handle:close()

                if final_result:match("error:") or final_result:match("fatal:") then
                  vim.notify("Failed to create branch: " .. final_result:gsub("\n$", ""), vim.log.levels.ERROR)
                else
                  vim.notify("Created and switched to branch: " .. branch_name, vim.log.levels.INFO)
                end
              end
            end
          )
        end)
      end,
      desc = "Create branch",
    },
    {
      "<leader>glo",
      function()
        -- Git log oneline in floating terminal
        local width = math.floor(vim.o.columns * 0.9)
        local height = math.floor(vim.o.lines * 0.8)
        local row = math.floor((vim.o.lines - height) / 2)
        local col = math.floor((vim.o.columns - width) / 2)

        local buf = vim.api.nvim_create_buf(false, true)
        
        local win = vim.api.nvim_open_win(buf, true, {
          relative = "editor",
          width = width,
          height = height,
          row = row,
          col = col,
          style = "minimal",
          border = "rounded",
          title = " Git Log Oneline ",
          title_pos = "center",
        })

        vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
        vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
        vim.api.nvim_buf_set_option(buf, "swapfile", false)
        vim.api.nvim_buf_set_option(buf, "modifiable", false)
        vim.api.nvim_buf_set_option(buf, "filetype", "git")

        -- Get clean git log output for syntax highlighting
        local cmd = "git log --oneline --decorate --graph"
        local handle = io.popen(cmd)
        if handle then
          local lines = {}
          for line in handle:lines() do
            table.insert(lines, line)
          end
          handle:close()
          
          vim.api.nvim_buf_set_option(buf, "modifiable", true)
          vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
          vim.api.nvim_buf_set_option(buf, "modifiable", false)
          
          -- Add comprehensive git highlighting
          vim.cmd([[
            highlight GitGraphRed ctermfg=1 guifg=#ff6b6b
            highlight GitGraphGreen ctermfg=2 guifg=#51cf66
            highlight GitGraphYellow ctermfg=3 guifg=#ffd43b
            highlight GitGraphBlue ctermfg=4 guifg=#74c0fc
            highlight GitGraphMagenta ctermfg=5 guifg=#d0bfff
            highlight GitGraphCyan ctermfg=6 guifg=#66d9ef
            highlight GitCommitHash ctermfg=11 guifg=#ffd43b gui=bold
            highlight GitBranch ctermfg=10 guifg=#51cf66 gui=bold
            highlight GitRemote ctermfg=9 guifg=#ff8787 gui=bold
            highlight GitTag ctermfg=13 guifg=#d0bfff gui=bold
          ]])
          
          local ns = vim.api.nvim_create_namespace('git_enhanced_colors')
          local graph_colors = {'GitGraphRed', 'GitGraphGreen', 'GitGraphYellow', 'GitGraphBlue', 'GitGraphMagenta', 'GitGraphCyan'}
          
          for i, line in ipairs(lines) do
            -- Color git graph characters
            local col = 0
            for char in line:gmatch('.') do
              if char:match('[|\\\\/*]') then
                local color_idx = (math.floor(col / 2) % #graph_colors) + 1
                vim.api.nvim_buf_add_highlight(buf, ns, graph_colors[color_idx], i-1, col, col+1)
              end
              col = col + 1
            end
            
            -- Color commit hashes (7-8 character hex at start after graph)
            local hash_start, hash_end = line:find('[a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9]?')
            if hash_start then
              vim.api.nvim_buf_add_highlight(buf, ns, 'GitCommitHash', i-1, hash_start-1, hash_end)
            end
            
            -- Color branch/tag references in parentheses
            local start_paren = line:find('%(')
            if start_paren then
              local end_paren = line:find('%)', start_paren)
              if end_paren then
                local content = line:sub(start_paren + 1, end_paren - 1)
                if content:match('origin/') then
                  vim.api.nvim_buf_add_highlight(buf, ns, 'GitRemote', i-1, start_paren-1, end_paren)
                elseif content:match('tag:') then
                  vim.api.nvim_buf_add_highlight(buf, ns, 'GitTag', i-1, start_paren-1, end_paren)
                elseif content ~= '' then
                  vim.api.nvim_buf_add_highlight(buf, ns, 'GitBranch', i-1, start_paren-1, end_paren)
                end
              end
            end
          end
        end

        local opts = { buffer = buf, noremap = true, silent = true }
        vim.keymap.set('n', 'q', function()
          if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
          end
        end, opts)
        vim.keymap.set('n', '<Esc>', function()
          if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
          end
        end, opts)
      end,
      desc = "Git log oneline",
    },
    {
      "<leader>gls",
      function()
        -- Git log with stats in floating window
        local width = math.floor(vim.o.columns * 0.9)
        local height = math.floor(vim.o.lines * 0.8)
        local row = math.floor((vim.o.lines - height) / 2)
        local col = math.floor((vim.o.columns - width) / 2)

        local buf = vim.api.nvim_create_buf(false, true)
        
        local win = vim.api.nvim_open_win(buf, true, {
          relative = "editor",
          width = width,
          height = height,
          row = row,
          col = col,
          style = "minimal",
          border = "rounded",
          title = " Git Log with Stats ",
          title_pos = "center",
        })

        -- Set buffer options for scrollable buffer
        vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
        vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
        vim.api.nvim_buf_set_option(buf, "swapfile", false)
        vim.api.nvim_buf_set_option(buf, "modifiable", false)
        vim.api.nvim_buf_set_option(buf, "filetype", "git")

        -- Get clean git log output for syntax highlighting
        local cmd = "git log --stat --pretty=format:'%h - (%cr) %s <%an>%d'"
        local handle = io.popen(cmd)
        if handle then
          local lines = {}
          for line in handle:lines() do
            table.insert(lines, line)
          end
          handle:close()
          
          vim.api.nvim_buf_set_option(buf, "modifiable", true)
          vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
          vim.api.nvim_buf_set_option(buf, "modifiable", false)
          
          -- Add basic git highlighting
          vim.cmd([[
            highlight GitCommitHash ctermfg=11 guifg=#ffd43b gui=bold
            highlight GitBranch ctermfg=10 guifg=#51cf66 gui=bold
            highlight GitRemote ctermfg=9 guifg=#ff8787 gui=bold
            highlight GitTag ctermfg=13 guifg=#d0bfff gui=bold
          ]])
          
          local ns = vim.api.nvim_create_namespace('git_stats_colors')
          
          for i, line in ipairs(lines) do
            -- Color commit hashes
            local hash_start, hash_end = line:find('[a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9]?')
            if hash_start then
              vim.api.nvim_buf_add_highlight(buf, ns, 'GitCommitHash', i-1, hash_start-1, hash_end)
            end
            
            -- Color branch/tag references
            local start_paren = line:find('%(')
            if start_paren then
              local end_paren = line:find('%)', start_paren)
              if end_paren then
                local content = line:sub(start_paren + 1, end_paren - 1)
                if content:match('origin/') then
                  vim.api.nvim_buf_add_highlight(buf, ns, 'GitRemote', i-1, start_paren-1, end_paren)
                elseif content:match('tag:') then
                  vim.api.nvim_buf_add_highlight(buf, ns, 'GitTag', i-1, start_paren-1, end_paren)
                elseif content ~= '' then
                  vim.api.nvim_buf_add_highlight(buf, ns, 'GitBranch', i-1, start_paren-1, end_paren)
                end
              end
            end
          end
        end

        local opts = { buffer = buf, noremap = true, silent = true }
        vim.keymap.set('n', 'q', function()
          if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
          end
        end, opts)
        vim.keymap.set('n', '<Esc>', function()
          if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
          end
        end, opts)
      end,
      desc = "Git log with stats",
    },
  },
}