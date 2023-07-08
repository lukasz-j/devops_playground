class lemp {

    Package { ensure => 'installed' }
    $lemppackages = [ 'nginx', 'mariadb-server', 'php-fpm' ]
    package { $lemppackages: }

    Service { ensure => 'running', enable => 'true'}
    $lempsvc = [ 'nginx', 'mariadb', 'php7.4-fpm' ]
    service { $lempsvc: }

    file { '/etc/nginx/sites-available/default':
     ensure  => file,
     content => epp('lemp/nginx-default-site.epp'),
     mode    => '0644',
     notify => Service['nginx']
   }

    file { '/var/www/html/index.html':
     ensure  => file,
     content => epp('lemp/index.html.epp'),
     mode    => '0644',
   }

}