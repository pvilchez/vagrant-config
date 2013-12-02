class supervisord {

  package {'supervisor':
    ensure => installed,
  }

  file { '/etc/supervisor/conf.d':
    ensure => directory,
    require => Package['supervisor'],
  }

  service { 'supervisor':
    ensure => true,
    enable => true,
    hasrestart => true,
    hasstatus => true,
    require => [Package['supervisor'],File['/etc/supervisor/conf.d']],
  }
}
