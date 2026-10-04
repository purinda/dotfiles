#!/usr/bin/env bash
set -euo pipefail
REPO=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)
source "$REPO/install"
test_root=$(mktemp -d)
trap 'rm -rf -- "$test_root"' EXIT

fail() { printf 'FAIL: %s\n' "$*" >&2; exit 1; }
assert_platform() {
    printf '%s\n' "$2" > "$test_root/os-release"
    [[ "$(linux_platform "$test_root/os-release")" == "$1" ]] || fail "$1 detection"
}
assert_platform bluefin $'ID=bluefin-dakota\nNAME="Bluefin"\nID_LIKE=org.gnome.os'
assert_platform bluefin $'ID=fedora\nNAME="Bluefin"\nID_LIKE=fedora'
assert_platform ubuntu $'ID=ubuntu\nNAME=Ubuntu\nID_LIKE=debian'
assert_platform ubuntu $'ID=linuxmint\nNAME="Linux Mint"\nID_LIKE="ubuntu debian"'
printf 'ID=arch\nNAME="Arch Linux"\n' > "$test_root/os-release"
if linux_platform "$test_root/os-release"; then fail 'unsupported distro accepted'; fi

# Platform package branches: stub execution so no packages or system files change.
(
    DRY_RUN=1
    find_brew() { printf 'brew\n'; }
    brew() { [[ "$1" == shellenv ]]; }
    PLATFORM=bluefin
    install_packages > "$test_root/bluefin-commands"
    grep -q 'brew install zsh' "$test_root/bluefin-commands" || fail 'Bluefin missing Homebrew'
    if grep -Eq 'apt|rpm-ostree|dnf|snap' "$test_root/bluefin-commands"; then fail 'Bluefin system mutation'; fi
    PLATFORM=macos
    WITH_NGROK=1
    install_packages > "$test_root/macos-commands"
    grep -q 'brew install --cask ngrok' "$test_root/macos-commands" || fail 'macOS ngrok'
    PLATFORM=ubuntu
    install_packages > "$test_root/ubuntu-commands"
    grep -q 'apt-get install -y zsh' "$test_root/ubuntu-commands" || fail 'Ubuntu apt'
    grep -q 'sudo snap install ngrok' "$test_root/ubuntu-commands" || fail 'Ubuntu ngrok'
    uname() { printf 'Darwin\n'; }
    main --dry-run --skip-packages > "$test_root/macos-plan"
    grep -q 'Setting up dotfiles for macos' "$test_root/macos-plan" || fail 'Darwin detection'
)

# Existing directories and broken links must be backed up, never nested into.
BACKUP_DIR="$test_root/backups"
mkdir -p "$test_root/source" "$test_root/destination"
printf 'original\n' > "$test_root/destination/keep"
link_file "$test_root/source" "$test_root/destination"
[[ -L "$test_root/destination" ]] || fail 'directory not replaced by a link'
[[ -f "$BACKUP_DIR/$test_root/destination/keep" ]] || fail 'existing directory lost'
backup_count=$(find "$BACKUP_DIR" -type f | wc -l)
link_file "$test_root/source" "$test_root/destination"
[[ "$(find "$BACKUP_DIR" -type f | wc -l)" == "$backup_count" ]] || fail 'repeat link created backup'
ln -s "$test_root/missing" "$test_root/broken"
link_file "$test_root/source" "$test_root/broken"
[[ -L "$BACKUP_DIR/$test_root/broken" ]] || fail 'broken link not backed up'
printf 'old\n' > "$test_root/generated"
write_config "$test_root/generated" 'new'
[[ "$(cat "$BACKUP_DIR/$test_root/generated")" == old ]] || fail 'generated config not backed up'
write_config "$test_root/generated" 'new'
[[ "$(cat "$BACKUP_DIR/$test_root/generated")" == old ]] || fail 'repeat config overwrote backup'

# A dry run must leave every existing file/link intact.
DRY_RUN=1
link_file "$test_root/other-source" "$test_root/destination" >/dev/null
write_config "$test_root/generated" 'different' >/dev/null
[[ "$(readlink "$test_root/destination")" == "$test_root/source" ]] || fail 'dry run changed link'
[[ "$(cat "$test_root/generated")" == new ]] || fail 'dry run changed file'
printf 'Installer regression checks passed.\n'
