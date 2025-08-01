# Personal Neovim Configuration

A LazyVim-based Neovim configuration with custom Claude AI integration.

## Features

### 🤖 Claude AI Integration
- Remote plugin: [kaipo-claude-code.nvim](https://github.com/kakapo1933/kaipo-claude-code.nvim)
- Real-time Claude AI interactions through floating terminal windows
- Visual mode commands for code explanation, review, optimization, and refactoring
- Support for error debugging and documentation generation
- Terminal session management and reconnection

### 📦 Plugin Management
- Based on [LazyVim](https://github.com/LazyVim/LazyVim)
- Lazy loading for optimal performance
- Custom plugin configurations

### 🌲 Git Worktree Management
- [git-worktree.nvim](https://github.com/ThePrimeagen/git-worktree.nvim) integration
- Quick switching between git worktrees with `<leader>gw`
- Create new worktrees with `<leader>gW`
- Telescope integration for seamless workflow

### 🚫 Git Ignore Configuration
- Comprehensive .gitignore file for Neovim development
- Excludes common temporary files, OS-generated files, and build artifacts
- Includes Node.js dependencies (node_modules) exclusion


## Installation

1. **Backup existing configuration:**
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   ```

2. **Clone this configuration:**
   ```bash
   git clone <your-repo-url> ~/.config/nvim
   ```

3. **Install Claude CLI (required for AI features):**
   ```bash
   curl -fsSL https://claude.ai/install.sh | sh
   ```

4. **Start Neovim:**
   ```bash
   nvim
   ```
   LazyVim will automatically install all plugins on first run.

## Claude AI Commands

> **Note:** This configuration uses the remote plugin [kaipo-claude-code.nvim](https://github.com/kakapo1933/kaipo-claude-code.nvim). 
> For the latest commands and documentation, refer to the plugin repository.


## Key Features

### 🔄 Terminal Session Management
- Track multiple Claude sessions simultaneously
- Reconnect to closed terminal windows
- Real-time processing visualization
- Automatic cleanup of finished sessions

### 🎨 UI/UX
- Floating terminal windows with rounded borders
- Dynamic titles showing current prompt
- Markdown syntax highlighting for responses
- Easy navigation with `q` or `Esc` to close

### ⚡ Performance
- Lazy loading of all components
- Efficient terminal management
- Non-blocking command execution

## File Structure

```
~/.config/nvim/
├── init.lua                 # Main configuration entry point
├── lua/
│   ├── config/
│   │   ├── autocmds.lua    # Auto commands
│   │   ├── keymaps.lua     # Key mappings
│   │   ├── lazy.lua        # Plugin manager setup + Claude integration
│   │   └── options.lua     # Neovim options
│   └── plugins/
│       ├── claude.lua      # Claude AI integration plugin
│       ├── dashboard.lua   # Dashboard configuration
│       ├── example.lua     # Example plugin configuration
│       ├── git-worktree.lua # Git worktree management
│       └── tailwind.lua    # Tailwind CSS support
├── stylua.toml             # Lua formatter configuration
├── lazyvim.json            # LazyVim configuration
└── README.md               # This file
```

## Requirements

- Neovim >= 0.9.0
- Git
- Claude CLI
- A Nerd Font (for icons)

## Customization

### Plugin Configuration
The Claude integration is configured in `lua/plugins/claude.lua`:

```lua
return {
  "kakapo1933/kaipo-claude-code.nvim",
  config = function()
    require("claude").setup()
  end,
}
```

### Customization
For customization options, refer to the [plugin documentation](https://github.com/kakapo1933/kaipo-claude-code.nvim).

## Troubleshooting

### Claude CLI Not Found
Ensure Claude CLI is installed and in your PATH:
```bash
which claude
```

### Plugin Loading Issues
Check for syntax errors:
```bash
nvim --headless -c "checkhealth" -c "qa!"
```

### Plugin Issues
Check the plugin status and documentation:
- Plugin repository: [kaipo-claude-code.nvim](https://github.com/kakapo1933/kaipo-claude-code.nvim)
- Use `:Lazy` to check plugin installation status

## Contributing

Feel free to submit issues and pull requests to improve this configuration.

## Recent Updates

- **2025-01-12**: Switched from nvim-tree to neo-tree for improved file explorer functionality
- **2025-01-12**: Enhanced lualine statusline with custom mode colors, git branch icons, and time display
- **2025-01-12**: Updated LazyVim deprecation warnings for better compatibility
- **2025-01-06**: Added node_modules to .gitignore for better Node.js project support
- **2025-01-06**: Updated claude.lua plugin comment for clarity
- **2025-01-05**: Added git-worktree.nvim plugin for enhanced Git workflow management

## License

This configuration is provided as-is for personal use under the Apache License 2.0.
