class sandbox::users {

  define add_user ( $name, $uid, $shell, $groups, $sshkeytype, $sshkey) {
  # Via http://blog.zweck.net/2011/05/using-puppet-to-manage-users-groups-and.html
    $username = $title
   
    $homedir = $kernel ? {
      'SunOS' => "/export/home/$username",
      default => "/home/$username"
    }
   
    user { $username:
      comment => "$name",
      home => "$homedir",
      shell => "$shell",
      uid => $uid,
      gid => $uid,
      managehome => 'true',
      groups => $groups,
      ensure => present,
    }

    group { $username:
      gid => "$uid"
    }

    file { "$homedir":
      ensure => directory,
      mode => 700,
      owner => "$username",
      group => "$username",
    } 
  
    ssh_authorized_key{ $username: 
      user => "$username",
      ensure => present, 
      type => "$sshkeytype", 
      key => "$sshkey", 
      name => "$username",
      require => [File["$homedir"],User["$username"]]
    } 
  }

  file { '/etc/sudoers.d/80-sandbox':
    ensure => present,
    source => 'puppet:///modules/sandbox-base/80-sandbox',
    mode => 0440,
  }

  # Users go here.

  add_user { pvilchez:
    name => "Paul Vilchez",
    uid => "2008",
    shell => "/bin/bash",
    groups => ['admin','pvilchez'],
    sshkeytype => "ssh-rsa",
    sshkey => "AAAAB3NzaC1yc2EAAAADAQABAAABAQCu4yXu5nREGE0YgY+Zd41yhLUYWm7CdSlVU7ZVk8rrc+kvXysjSH/axSDsGQ//H4AYfqxrumZziAUQPO4i4MX9yRowVfOP67hC20I9OKb8gJ0KLHgGtES5vbugr6Ea6J/9SGzIi+2Q1tAXy61dAn2R6ob2xb8qjxAw3KQneVUP0E6zxT+gKlH87jdbyAkqeukNv8zWkjEAvFmjpnZYIm8sra4KqJlfd6HfJhDNH+jUeBYjUP4zOBxrZkeGwwtPT3sD/rnyKTd6XVPME6TlXC+FgivigA0gMqBex3NVWeQPM5f2lubI+IjB21OAvLXwVqLVP6i0IPwFNUvs1Mv6IHz3",
  }

  # Banned users go here.

  # Default user.
  # Disabling this user also means that the instantiation key (AWS key used to start an instance) will no longer work for this VM.
  user { 'ubuntu':
    ensure => absent,
  }

}

