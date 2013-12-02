# Global Virtualenv ===========================================================

define sandbox::virtualenv(
  $path = $title

) {

  # Build a virtualenv. 
  python::virtualenv { "${path}":
    ensure  => present,
    version => 'system',
  }

  # Python packages with system level prerequisits.
  package{ 'libmysqlclient-dev':
    ensure  => installed,
  }
  python::pip{ 'mysql-python':
    virtualenv => $path,
    require    => Package['libmysqlclient-dev'],
  }

  package{ 'libcurl4-gnutls-dev':
    ensure  => installed,
  }
  python::pip{ 'pycurl':
    virtualenv => $path,
    require    => Package['libcurl4-gnutls-dev'],
  }

  # PIL and it's dependencies 
  package{ 'libjpeg-dev' :
    ensure  => installed,
  }
  package{ 'libfreetype6-dev' :
    ensure  => installed,
  }
  package{ 'zlib1g-dev' :
    ensure  => installed,
  }
  package{ 'libpng12-dev' :
    ensure  => installed,
  }

  python::pip{ 'pillow' : #Formerly PIL
    virtualenv => $path,
    require    => [
      Package['libjpeg-dev'],
      Package['libfreetype6-dev'],
      Package['zlib1g-dev'],
      Package['libpng12-dev'],
    ],
  }

  # Everything else.
  python::pip{ 'django'           : virtualenv => $path, version => "1.5.5" }
  python::pip{ 'pika'             : virtualenv => $path, }
  python::pip{ 'simplejson'       : virtualenv => $path, }
  python::pip{ 'graypy'           : virtualenv => $path, }
  python::pip{ 'jsonpickle'       : virtualenv => $path, }
  python::pip{ 'pytz'             : virtualenv => $path, version => "2013b" }
  python::pip{ 'django-reversion' : virtualenv => $path, }
  python::pip{ 'iso8601'          : virtualenv => $path, }
  python::pip{ 'South'            : virtualenv => $path, }
  python::pip{ 'diff-match-patch' : virtualenv => $path, }
  python::pip{ 'django-mptt'      : virtualenv => $path, }
  python::pip{ 'pyyaml'           : virtualenv => $path, }
  python::pip{ 'voluptuous'       : virtualenv => $path, }
  python::pip{ 'dateutils'        : virtualenv => $path, }
  python::pip{ 'python-dateutil'  : virtualenv => $path, }
  python::pip{ 'psutil'           : virtualenv => $path, }
}
