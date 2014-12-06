#Prerequisites 
# - vcsrepo (puppet module install puppetlabs-vcsrepo)

#user {
#  "purinda":
#    ensure     => "present",
#    password   => sha1("password"),
#    shell      => "/bin/bash",
#    managehome => true,
#    groups     => ["adm", "cdrom", "sudo", "dip", "plugdev", "lpadmin", "sambashare"],
#}

package { "htop"                : ensure => "installed" }
package { "exuberant-ctags"     : ensure => "installed" }
package { "cscope"              : ensure => "installed" }

# Init the Projects folder where dotfiles and other core projects
# will be stored.
file {
  ["/Users/purinda/Projects/", "/Users/purinda/Projects/dotfiles"]:
    ensure  => "directory",
    owner   => "purinda",
    group   => "staff",
    mode    => 750,
    force   => true,
}

# Install puppet module for checkout repositories from remote source control
# servers.
exec { "puppet module install puppetlabs/vcsrepo":
  path    => "/usr/bin:/usr/sbin:/bin",
  onlyif  => "test `puppet module list | grep puppetlabs-vcsrepo | wc -l` -eq 0"
}

vcsrepo { "/Users/purinda/Projects/dotfiles":
  ensure   => present,
  provider => git,
  source   => "https://github.com/purinda/dotfiles.git",
  owner    => "purinda",
  group    => "staff",
}

exec {
  ["git submodule init", "git submodule update", "git submodule foreach git pull origin master"]:
    cwd     => "/Users/purinda/Projects/dotfiles",
    path    => ['/usr/bin','/usr/sbin','/bin','/sbin'],
    user    => "purinda",
    require => Vcsrepo["/Users/purinda/Projects/dotfiles"],
}

file {
  # Symlinks for bash profile
  '/Users/purinda/.bashrc':
    ensure => 'link',
    target => '/Users/purinda/Projects/dotfiles/bashrc.osx',
    owner  => "purinda",
    group  => "staff",
    mode   => 750,
    force  => true;

  # Symlinks for VIM config
  '/Users/purinda/.vimrc':
    ensure => 'link',
    target => '/Users/purinda/Projects/dotfiles/vimrc',
    owner  => "purinda",
    group  => "staff",
    mode   => 750,
    force  => true;

  '/Users/purinda/.vim':
    ensure => 'link',
    target => '/Users/purinda/Projects/dotfiles/vim',
    owner  => "purinda",
    group  => "staff",
    mode   => 750,
    force  => true;
}
