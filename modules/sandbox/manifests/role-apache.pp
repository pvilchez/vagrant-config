# Apache ======================================================================
#
# This role provides Apache2, PHP, and a few other libraries and utilities.


class sandbox::role-apache {

  # Apache2 -------------------------------------------------------------------

  class { 'apache':
    listen_ports => [8080,8081,8082],
  }

  exec { "/usr/sbin/a2enmod rewrite":
    command =>  "/usr/sbin/a2enmod rewrite",
    require => Package['apache'],
  }

  # MySQL ---------------------------------------------------------------------

  include mysql

  # PHP -----------------------------------------------------------------------

  include composer

  # This is horribly hacky but it seems to be the only way to
  # avoid circular dependency problems...
  # This is not python related; it's APT related.
  package { "python-software-properties":
    ensure => present,
  }

  exec {"/usr/bin/add-apt-repository ppa:ondrej/php5-oldstable && /usr/bin/apt-get update":
    alias   => "php-ppa",
    require => Package["python-software-properties"],
    creates => '/etc/apt/sources.list.d/ondrej-php5-oldstable-precise.list'
  }

  # Needed to fix symfony log and cache permissions.
  package{ 'acl':
    ensure => present
  }

  class { 'php':
    notify => Service['apache'],
    require => [Package['apache'], Package['acl'], Exec["php-ppa"]],
  }

  php::module { 'curl': }
  php::module { 'mcrypt': }
  php::module { 'intl': }
  php::module { 'mysql': }
  php::module { 'apc':
    module_prefix => 'php-',
  }

  class { 'php::devel':
    require => Class['php'],
  }

  class { 'php::pear':
    require => Class['php'],
  }

}
