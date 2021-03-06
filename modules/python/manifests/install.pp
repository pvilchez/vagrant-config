class python::install {

  $python = $python::version ? {
    'system' => 'python',
    default  => "python${python::version}",
  }

#  $pythondev = $::operatingsystem ? {
#    /(?i:RedHat|CentOS|Fedora)/ => "$python-devel",
#    /(?i:Debian|Ubuntu)/        => "$python-dev"
#  }
#
#  package { $python: ensure => present }
#
#  $dev_ensure = $python::dev ? {
#    true    => present,
#    default => absent,
#  }

  package { [ 'python-dev', 'python-pip' ]: ensure => $dev_ensure }

  $venv_ensure = $python::virtualenv ? {
    true    => present,
    default => absent,
  }

  package { 'python-virtualenv': ensure => $venv_ensure }

  $gunicorn_ensure = $python::gunicorn ? {
    true    => present,
    default => absent,
  }

  package { 'gunicorn': ensure => $gunicorn_ensure }

}
