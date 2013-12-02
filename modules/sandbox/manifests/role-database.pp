  # Database ====================================================================
  #
  # This role installs mysql and creates databases and database users.
  # It does not run migrations or load fixtures; the individual services are
  # responsible for that.

class sandbox::role-database {

  include mysql
  include mysql::server

  # database-name ---------------------------------------------------------------
  #
  # mysql::db { 'database-name':
  #   user     => 'user',
  #   password => 'password',
  #   host     => '127.0.0.1',
  #   grant    => ['all'],
  # }

}
