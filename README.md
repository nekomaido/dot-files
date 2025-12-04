# Dotfiles

Personal configuration files managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Structure

```
dotfiles/
├── config/         # All XDG apps (~/.config/*)
│   └── ghostty, git, kitty, nvim, tmux, yazi
├── shell/          # Zsh configs (.zshrc, .zshenv, .zprofile)
└── vim/            # Vim configuration (~/.vim)
```

## Installation

### Prerequisites

```bash
# Install GNU Stow (if not already installed)
brew install stow
```

### Fresh Install (New Machine)

```bash
# Clone this repository
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles

# Stow all configs
stow config shell vim

# Or stow individual packages
stow config  # All XDG apps
stow shell   # Zsh configs
stow vim     # Vim config
```

### Migrating Existing Configs

If you have existing configs, **back them up first**, then remove them:

```bash
# Backup existing configs
mkdir -p ~/config-backup
cp ~/.zshrc ~/.zshenv ~/.zprofile ~/config-backup/
cp -r ~/.config/{ghostty,git,kitty,nvim,tmux,yazi} ~/config-backup/
cp -r ~/.vim ~/config-backup/

# Remove originals (required for stow to create symlinks)
rm ~/.zshrc ~/.zshenv ~/.zprofile
rm -rf ~/.config/{ghostty,git,kitty,nvim,tmux,yazi}
rm -rf ~/.vim

# Now stow your dotfiles
cd ~/dotfiles
stow config shell vim
```

## Usage

### Add new configs
```bash
# Add to appropriate package, then restow
stow -R shell  # Restow to update symlinks
```

### Remove configs
```bash
# Unstow package (removes symlinks)
stow -D shell
```

### Update configs
```bash
# After editing files in ~/dotfiles, changes are immediately reflected
# No action needed - symlinks point to dotfiles repo!

# To commit changes
cd ~/dotfiles
git add -u
git commit -m "Update shell config"
git push
```

## Verification

Check that configs are symlinked:

```bash
ls -la ~ | grep -E '\.zshrc|\.gitconfig'
ls -la ~/.config/ | grep -E 'ghostty|git|kitty|nvim|tmux|yazi'
```

You should see arrows (→) pointing to `~/dotfiles/...`

## Notes

- **DO NOT** commit sensitive files (.ssh keys, tokens, OAuth credentials)
- Excluded from git: `.zsh_history`, `.zcompdump*`, `.viminfo`, cache files
- Tmux plugins are included - run `Ctrl-b I` to install on new machine

## Troubleshooting

**Conflict warnings?**
- You have existing files that aren't symlinks
- Back them up and remove them, then restow

**Symlinks not working?**
- Check you're in `~/dotfiles` directory when running stow
- Use `-v` flag for verbose output: `stow -v shell`
- Use `-n` flag for dry-run: `stow -n shell`
