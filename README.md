# Dotfiles

Personal configuration files and shell environment optimized for macOS and Linux.

---

## Overview

This repository manages configuration files for **Zsh**, **Alacritty**, **Tmux**, **Git**, and **Neovim**, with a modular architecture that separates concerns and supports cross-platform setups (macOS / Linux).

---

## Repository Structure

```text
.dotfiles/
├── alacritty/               # Alacritty terminal emulator configuration
│   ├── alacritty.toml       # Main configuration (font, window, theme imports)
│   ├── catppuccin-*.toml    # Catppuccin theme flavors (Mocha, Frappe, Latte, Macchiato)
│   └── github_light.toml    # GitHub Light theme
├── git/                     # Git global configurations
│   ├── gitconfig            # Global git settings, rich aliases, diff colors
│   └── gitignore_global     # Global ignore rules
├── tmux/                    # Tmux configuration (based on .tmux)
│   ├── tmux.conf            # Core tmux configuration
│   └── tmux.conf.local      # Local customizations & status bar settings
├── zshrc                    # Main Zsh startup script & Powerlevel10k integration
├── zshrc.d/                 # Modular Zsh scripts
│   ├── alias.sh             # Common aliases (Docker/Podman, git, eza, bat, btop)
│   ├── completions.sh       # Shell completions (ngrok, etc.)
│   ├── fn.sh                # Utility functions (archive extraction, git branch parsing)
│   ├── k8s.sh               # Kubernetes helpers (ssh-k8s)
│   ├── nerdstorm.sh         # Platform deployment toolkit & cicd launcher resolution
│   ├── os.sh                # OS-specific paths (Homebrew, Cargo, Anaconda, Node)
│   └── python-venv.sh       # Python virtual environment management
├── install                  # Automated installation and symlink script
└── README.md                # Documentation
```

---

## Key Features & Modules

### 1. Zsh & Shell Modules (`zshrc`, `zshrc.d/`)
- **Theme & Prompt**: [Powerlevel10k](https://github.com/romkatv/powerlevel10k) prompt with instant-prompt initialization.
- **`alias.sh`**:
  - Modern CLI replacements: `ls` &rarr; `eza`, `cat` &rarr; `bat`, `top` &rarr; `btop`.
  - Container shortcuts: Auto-detects `docker` or `podman` and aliases `c` &rarr; `compose`, `cup` &rarr; `compose up -d`, `cl` &rarr; `logs -f`, `clj` &rarr; JSON log parser.
  - Git and system shortcuts (`g`, `gs`, `gsh`, `gd`, `gp`, `t` for tmux session attach/new).
- **`python-venv.sh`**: Helper functions `venv-setup <path> [python_version]`, `venv-activate <path>`, and `venv-deactivate`.
- **`k8s.sh`**: `ssh-k8s <namespace> <pod> [container]` for fast container shells.
- **`nerdstorm.sh`**: Automatically resolves and exposes the `cicd` launcher from the platform deployment toolkit.
- **`fn.sh`**: `ex <file>` universal archive extractor (tar, zip, bz2, 7z, gz, etc.), `noproxy`, `svndiff`.

### 2. Alacritty (`alacritty/`)
- GPU-accelerated terminal configured with **MesloLGS Nerd Font** (size 13.0).
- Includes **Catppuccin** color schemes (defaulting to Catppuccin Mocha) with live config reloading.

### 3. Tmux (`tmux/`)
- Enhanced tmux setup with dual prefix keys (`Ctrl-b` and `Ctrl-a`).
- Intuitive pane splitting (`-` for horizontal, `_` for vertical), vi-mode copying, and system clipboard integration (`pbcopy`, `xclip`, `wl-copy`).
- Custom status bar and theme configuration in `tmux/tmux.conf.local`.

### 4. Git (`git/`)
- Global `gitconfig` featuring:
  - Pretty log graphs: `git lg`, `git ll`, `git me`, `git wk`.
  - Stage/unstage helpers: `git us`, `git usa`, `git uf`.
  - Colored diffs and diff-highlight support.
  - Neovim as default editor (`editor = nvim`).

---

## Installation

To set up the dotfiles on a new machine:

1. Clone the repository to `~/.dotfiles`:
   ```bash
   git clone git@github.com:purinda/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. Run the installer:
   ```bash
   ./install
   ```

### What the installer does:
- Backs up any existing `~/.zshrc` to `~/.zshrc.orig`.
- Creates symlinks:
  - `~/.zshrc` &rarr; `.dotfiles/zshrc`
  - `~/.zshrc.d` &rarr; `.dotfiles/zshrc.d`
  - `~/.gitconfig` &rarr; `.dotfiles/git/gitconfig`
  - `~/.gitignore` &rarr; `.dotfiles/git/gitignore_global`
  - `~/.config/alacritty` &rarr; `.dotfiles/alacritty`
  - `~/.config/tmux` &rarr; `.dotfiles/tmux`
- Installs dependencies:
  - **Linux (Debian/Ubuntu)**: Installs `eza`, `bat`, `neovim`, and `ngrok`.
  - **macOS**: Installs `neovim`, `eza`, `bat`, and `ngrok` via Homebrew.
- Clones/updates [Powerlevel10k](https://github.com/romkatv/powerlevel10k) in `~/.powerlevel10k`.

3. Restart your terminal session or run:
   ```bash
   source ~/.zshrc
   ```
   If configuring Powerlevel10k for the first time, run `p10k configure`.
