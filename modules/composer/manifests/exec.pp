# == Type: composer::exec
#
# Either installs from composer.json or updates project or specific packages
#
# === Authors
#
# Thomas Ploch <profiploch@gmail.com>
#
# === Copyright
#
# Copyright 2013 Thomas Ploch
#
define composer::exec (
  $cmd,
  $cwd,
  $packages          = [],
  $prefer_source     = false,
  $prefer_dist       = false,
  $dry_run           = false,
  $no_custom_installers = true,
  $no_scripts           = true,
  $optimize          = false,
  $no_interaction    = true,
  $dev               = false,
  $logoutput         = on_failure, # false,
  $verbose           = false
) {
  require composer
  #require git

  Exec { path => "/bin:/usr/bin/:/sbin:/usr/sbin:${composer::target_dir}" }

  if $cmd != 'install' and $cmd != 'update' {
    fail("Only types 'install' and 'update' are allowed, $type given")
  }

  if $prefer_source and $prefer_dist {
    fail("Only one of \$prefer_source or \$prefer_dist can be true.")
  }

  $command = "php ${composer::target_dir}/${composer::composer_file} ${cmd}"

  exec { "composer_update_${title}":
    command   => template('composer/exec.erb'),
    environment => ['COMPOSER_PROCESS_TIMEOUT=4000','HOME=/tmp;'],
    cwd       => $cwd,
    logoutput => $logoutput,
    timeout   => 0,
  }
}
