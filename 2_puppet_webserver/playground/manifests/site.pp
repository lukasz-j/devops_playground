class simple_app {
    file { '/var/www/html/info.php':
     ensure  => file,
     content => '<?php phpinfo();',
     mode    => '0644',
   }
}

node 'puppet-node1' {
    include lemp
    include simple_app
}

node 'puppet-node2' {
    include lemp
}