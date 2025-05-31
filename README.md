# Personal Neovim Configuration

A LazyVim-based Neovim configuration with custom Claude AI integration.

## Features

### 🤖 Claude AI Integration
- Real-time Claude AI interactions through floating terminal windows
- Visual mode commands for code explanation, review, optimization, and refactoring
- Support for error debugging and documentation generation
- Terminal session management and reconnection

### 📦 Plugin Management
- Based on [LazyVim](https://github.com/LazyVim/LazyVim)
- Lazy loading for optimal performance
- Custom plugin configurations

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

### Visual Mode Commands
- `<leader>ce` - Explain selected code
- `<leader>cr` - Review code for bugs and improvements
- `<leader>co` - Optimize selected code
- `<leader>cf` - Refactor code for readability
- `<leader>ct` - Generate unit tests
- `<leader>cd` - Add documentation/comments
- `<leader>cp` - Custom prompt
- `<leader>cl` - List active Claude terminals

### Normal Mode Commands
- `<leader>cb` - Review entire file
- `<leader>ch` - Help with error messages

### Ex Commands
- `:ClaudeExplain` - Explain current line
- `:ClaudeDebug` - Debug current file
- `:ClaudeList` - List and reconnect to active terminals
- `:ClaudeKillAll` - Kill all Claude terminals

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
│       ├── claude-nvim.lua # Claude AI integration plugin
│       ├── example.lua     # Example plugin configuration
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

### Adding New Claude Prompts
Edit `lua/plugins/claude-nvim.lua` and add new keymaps in the `setup()` function:

```lua
keymap("v", "<leader>cx", M.send_to_claude("Your custom prompt"), { desc = "Claude: Custom action" })
```

### Modifying UI
Adjust the floating window settings in the `create_claude_terminal()` function:

```lua
local width = math.floor(vim.o.columns * 0.8)  -- 80% of screen width
local height = math.floor(vim.o.lines * 0.8)   -- 80% of screen height
```

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

### Terminal Connection Problems
List active terminals for debugging:
```vim
:ClaudeList
```

## Contributing

Feel free to submit issues and pull requests to improve this configuration.

## License

This configuration is provided as-is for personal use.
