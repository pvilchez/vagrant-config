define supervisord::job(
    $command,
    $procs = 1,
    $log_file = "/var/log/supervisor/${title}.log",
    $error_log_file = "/var/log/supervisor/${title}_error.log",
    $ensure = 'present',
    $directory = false
){
    file{
        "/etc/supervisor/conf.d/${title}.conf":
            mode => 644,
            owner => "root",
            group => "root",
            path => "/etc/supervisor/conf.d/${title}.conf",
            ensure => $ensure,
            notify => Exec["/usr/bin/supervisorctl update ${title}"],
            content => template('supervisord/job.erb');
    }

    exec { "/usr/bin/supervisorctl update ${title}":
        command => "/usr/bin/supervisorctl update",
        require => File["/etc/supervisor/conf.d/${title}.conf"],
    } 
}

