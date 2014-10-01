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

package { "git"                 : ensure => "installed" }
package { "openssh-server"      : ensure => "installed" }
package { "htop"                : ensure => "installed" }
package { "vim"                 : ensure => "installed" }
package { "elinks"              : ensure => "installed" }
package { "apache2"             : ensure => "installed" }
package { "php5"                : ensure => "installed" }
package { "php5-cli"            : ensure => "installed" }
package { "php5-gd"             : ensure => "installed" }
package { "php5-curl"           : ensure => "installed" }
package { "php5-tidy"           : ensure => "installed" }
package { "libapache2-mod-php5" : ensure => "installed" }
package { "php5-mcrypt"         : ensure => "installed" }
package { "exuberant-ctags"     : ensure => "installed" }
package { "cscope"              : ensure => "installed" }

class mysql-server {
  $password = "password"
  package { "MySQL-client"              : ensure => installed }
  package { "MySQL-server"              : ensure => installed }
  package { "MySQL-shared"              : ensure => installed }
  package { "libapache2-mod-auth-mysql" : ensure => installed }
  package { "php5-mysql"                : ensure => installed }

  exec { "Set MySQL server root password":
    subscribe    => [ Package["MySQL-server"], Package["MySQL-client"], Package["MySQL-shared"] ],
    refreshonly  => true,
    unless       => "mysqladmin -uroot -p$password status",
    path         => "/bin:/usr/bin",
    command      => "mysqladmin -uroot password $password",
  }
}

# Init the Projects folder where dotfiles and other core projects
# will be stored.
file {
  ["/home/purinda/Projects/", "/home/purinda/Projects/dotfiles"]:
    ensure  => "directory",
    owner   => "purinda",
    group   => "purinda",
    mode    => 750,
    force   => true,
    #require => User["purinda"],
}

exec { "puppet module install puppetlabs/vcsrepo":
  path    => "/usr/bin:/usr/sbin:/bin",
  onlyif  => "test `puppet module list | grep puppetlabs-vcsrepo | wc -l` -eq 0"
}

vcsrepo { "/home/purinda/Projects/dotfiles":
  ensure   => present,
  provider => git,
  source   => "https://github.com/purinda/dotfiles.git",
  owner    => "purinda",
  group    => "purinda",
}

exec {
  ["git submodule init", "git submodule update", "git submodule foreach git pull origin master"]:
    cwd     => "/home/purinda/Projects/dotfiles",
    path    => ['/usr/bin','/usr/sbin','/bin','/sbin'],
    user    => "purinda",
    require => Vcsrepo["/home/purinda/Projects/dotfiles"],
}

exec {
  "ssh-keygen -t rsa -f /home/purinda/.ssh/id_rsa -N ''":
    user   => "purinda",
    onlyif => "test ! -f /home/purinda/.ssh/id_rsa",
    path   => ['/usr/bin','/usr/sbin','/bin','/sbin'],
}

file {
  # Symlinks for bash profile
  '/home/purinda/.bashrc':
    ensure => 'link',
    target => '/home/purinda/Projects/dotfiles/bashrc.ubuntu',
    owner  => "purinda",
    group  => "purinda",
    mode   => 750,
    force  => true;

  # Symlinks for VIM config
  '/home/purinda/.vimrc':
    ensure => 'link',
    target => '/home/purinda/Projects/dotfiles/vimrc',
    owner  => "purinda",
    group  => "purinda",
    mode   => 750,
    force  => true;

  '/home/purinda/.vim':
    ensure => 'link',
    target => '/home/purinda/Projects/dotfiles/vim',
    owner  => "purinda",
    group  => "purinda",
    mode   => 750,
    force  => true;
}
