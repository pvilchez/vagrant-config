# Configuration Roles =========================================================

# This may change.
# In the short term, use these options to turn of large swaths of this
# configuration file to speed up testing and development.

$aptupdate = true

# System Level Services =======================================================

package { "vim":
  ensure => present
}

package { 'screen':
  ensure => present
}

package { 'git':
  ensure => present
}

package { 'supervisor':
  ensure => present
}

# MySQL -----------------------------------------------------------------------

class{ "sandbox::role-database": }

# Apache -----------------------------------------------------------------------

class{ "sandbox::role-apache": }

# APT -------------------------------------------------------------------------

if( $aptupdate ) {
  class { 'apt':
    always_apt_update => true,
  }

  # Force an update prior to any other package installs.
  Exec["apt_update"] -> Package <| |>
}
