class haproxy::proxy(
  $mysql = ['127.0.0.1'],
  $rabbitmq = ['127.0.0.1'],
) {
  package{ 'haproxy': }

  exec { 'haproxy-restart':
    command     => "service haproxy restart",
    logoutput   => on_failure,
    refreshonly => true,
    path        => '/sbin/:/usr/sbin/:/usr/bin/:/bin/',
  }

  file { '/etc/default/haproxy':
    ensure  => present,
    source  => 'puppet:///modules/haproxy/haproxy',
    require => Package['haproxy'],
    notify  => Exec['haproxy-restart'],
    mode    => 644,
  }
 
  file { '/etc/haproxy/haproxy.cfg':
    ensure  => present,
    content => template("haproxy/haproxy.cfg.erb"),
    require => Package['haproxy'],
    notify  => Exec['haproxy-restart'],
    mode    => 644,
  }

}
