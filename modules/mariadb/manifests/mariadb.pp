class mariadb::mariadb ( $galara = false ) {
  # This is horribly hacky but it seems to be the only way to
  # avoid circular dependency problems...
  # This is not python related; it's APT related.
  package { "python-software-properties":
    ensure => present,
  }
  
  exec {"/usr/bin/add-apt-repository 'deb http://mirror.jmu.edu/pub/mariadb/repo/5.5/ubuntu precise main' && /usr/bin/apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db && /usr/bin/apt-get update":
    alias   => "mariadb-repo",
    require => Package["python-software-properties"],
  }
 
  if( $galera ) {
    package { "galara":
      require => Exec["mariadb-repo"],
    }
    package { "mariadb-galara-server":
      require => [Exec["mariadb-repo"],Package['galera']],
      alias => "mariadb-server",
    }

  } else { 
    package { "mariadb-server":
      require => Exec["mariadb-repo"],
    }
  }

  exec { 'mariadb-restart':
    command     => "service mysql restart",
    logoutput   => on_failure,
    refreshonly => true,
    path        => '/sbin/:/usr/sbin/:/usr/bin/:/bin/',
  }

  exec { 'mariadb-install':
    command     => "mysql_install_db --user mysql",
    logoutput   => on_failure,
    notify      => Exec['mariadb-restart'],
    returns     => [0,1],
    path        => '/sbin/:/usr/sbin/:/usr/bin/:/bin/',
  }

  file { '/etc/mysql/my.cnf':
    ensure  => present,
    source  => 'puppet:///modules/mariadb/my.cnf',
    require => Package['mariadb-server'],
    notify  => Exec['mariadb-restart'],
    mode    => 644,
  }

  file { '/etc/mysql/conf.d/mariadb.cnf':
    ensure  => present,
    source  => 'puppet:///modules/mariadb/mariadb.cnf',
    require => Package['mariadb-server'],
    notify  => Exec['mariadb-restart'],
    mode    => 644,
  }

  file { "/mnt/mysql":
    ensure => directory,
    owner  => "mysql",
    group  => "mysql",
    mode   => 755,
    require => [File['/etc/mysql/my.cnf'], File['/etc/mysql/my.cnf']],
    notify  => Exec['mariadb-install'],
  }


}
