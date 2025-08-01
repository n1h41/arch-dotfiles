# TMUX Configuration Agent Guidelines

## Build/Installation Commands
- Install TPM (Tmux Plugin Manager): `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`
- Install plugins: Press `prefix` + I (capital i) inside tmux
- Reload configuration: `tmux source-file ~/.config/tmux/tmux.conf` or `prefix + r`
- Update plugins: `prefix` + U

## Testing
- Test configuration changes: `tmux -f ~/.config/tmux/tmux.conf`
- Plugin tests: Check individual plugin directories for test scripts

## Code Style Guidelines
- Indentation: Use spaces for indentation in configuration files
- Comments: Precede with `#` and a space
- Line length: Keep under 100 characters
- Key bindings: Group by function with descriptive comments
- Source external files with absolute paths
- Status line styling: Use hex colors (#rrggbb format)

## File Organization
- Main configuration: `tmux.conf` 
- Modular files: `statusline.conf`, `plugins.conf`, `utility.conf`, `macos.conf`
- Platform-specific settings in separate files (e.g., `macos.conf`)
- Plugin configurations in the main file or `plugins.conf`

## Conventions
- Prefix key: C-e (Control+e)
- Key bindings use vim-style keys where possible
- Use descriptive variable names
- Reload config with changes using `tmux source-file ~/.config/tmux/tmux.conf`