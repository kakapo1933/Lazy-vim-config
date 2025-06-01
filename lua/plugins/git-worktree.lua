return {
  "nvim-telescope/telescope.nvim", -- We still use telescope for git_branches
  event = "VeryLazy",
  config = function()
    vim.schedule(function()
      local wk = require("which-key")
      wk.register({
        ["<leader>gB"] = { name = "+Branch" },
        ["<leader>gw"] = { name = "+Worktree" }
      })
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
        local result = handle:read("*a")
        handle:close()
        
        local branches = {}
        local current_branch = nil
        
        for line in result:gmatch("[^\r\n]+") do
          if line:match("^%s*%*") then
            -- Current branch (skip it)
            current_branch = line:match("^%s*%*%s*(.+)$")
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
                local handle = io.popen(cmd .. " 2>&1")
                local result = handle:read("*a")
                handle:close()
                
                -- Check if the result contains error messages
                if result:match("error:") or result:match("Cannot delete") or result:match("not fully merged") then
                  vim.notify("Failed to delete branch: " .. result:gsub("\n$", ""), vim.log.levels.ERROR)
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
                    local handle = io.popen(cmd .. " 2>&1")
                    local result = handle:read("*a")
                    handle:close()
                    
                    if result:match("error:") or result:match("fatal:") then
                      vim.notify("Failed to create branch: " .. result:gsub("\n$", ""), vim.log.levels.ERROR)
                    else
                      vim.notify("Created and switched to branch: " .. branch_name, vim.log.levels.INFO)
                    end
                  end
                end)
                return
              end
              
              if cmd then
                local handle = io.popen(cmd .. " 2>&1")
                local result = handle:read("*a")
                handle:close()
                
                if result:match("error:") or result:match("fatal:") then
                  vim.notify("Failed to create branch: " .. result:gsub("\n$", ""), vim.log.levels.ERROR)
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
  },
}