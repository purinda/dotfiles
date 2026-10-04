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

Works on **Bluefin** (including Dakota), **Ubuntu/Debian**, and **macOS**.
The installer uses Bash, so Zsh does not need to be installed beforehand.
Clone anywhere; paths are resolved from the installer, not the current directory:

```bash
mkdir -p ~/src
git clone https://github.com/purinda/dotfiles.git ~/src/dotfiles
cd ~/src/dotfiles
./install
```

| Platform | Package manager | Prerequisites |
| --- | --- | --- |
| Bluefin / Bluefin Dakota | Homebrew | Bluefin's included Homebrew; no changes to the immutable system image |
| Ubuntu / Debian | apt | sudo access for packages; upstream eza repository added only on older releases without eza |
| macOS | Homebrew | Install Homebrew from https://brew.sh first |

The installer installs Zsh, Neovim, eza, bat, btop, tmux, jq, and Git LFS;
clones or updates Powerlevel10k with a fast-forward-only pull; and installs the
Regular, Bold, Italic, and Bold Italic variants of **MesloLGS Nerd Font** and
**MesloLGS Nerd Font Mono**. Meslo is pinned to Nerd Fonts v3.5.1; override with
`NERD_FONTS_VERSION=vX.Y.Z ./install` to select another release.

Existing files, directories, and conflicting symlinks are moved into a unique
`~/.dotfiles-backup-<timestamp>-<random>/` directory before replacement.
Rerunning keeps matching links and generated configuration in place, skips
already installed font releases, and never appends duplicate prompt lines or
modifies files in this repository.

Installed configuration:

- `~/.zshrc` and `~/.zshrc.d` link to this repository.
- `~/.gitconfig` links to `git/gitconfig`; HTTPS certificate verification stays enabled.
- `~/.gitignore` and `~/.gitignore_global` link to `git/gitignore_global`.
- `~/.config/tmux` links to `tmux`.
- `~/.config/alacritty/alacritty.toml` imports the repository configuration and
  sets the installed Zsh executable, including Homebrew's path on Bluefin.
  Theme files are linked individually.
- `~/bin` is linked only when this repository contains a `bin/` directory.

Useful options:

```bash
./install --dry-run        # Preview without installing packages or changing files
./install --skip-packages  # Configure using dependencies already installed
./install --with-ngrok     # Optional ngrok: Homebrew cask on macOS, snap on Ubuntu
```

On Bluefin, `--with-ngrok` prints the Linux download link instead of attempting
an unsupported Homebrew cask. Docker installation is separate; the shell aliases
prefer an existing Docker installation and fall back to Podman. User-local
binaries stay on PATH, including rootless Docker.

Start the configured shell with `exec zsh`, then run `p10k configure`.
Select **MesloLGS Nerd Font Mono** in your terminal preferences. Alacritty already
selects Meslo in the imported configuration. The installer does not change your
account's login shell or terminal preferences. To make Zsh the login shell, use
`chsh -s "$(command -v zsh)"` where the shell is listed in `/etc/shells`; Homebrew
shells may need administrator setup on Bluefin or macOS.

Run the installer regression checks with:

```bash
bash tests/install.sh
```
