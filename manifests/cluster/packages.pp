class mysql::cluster::packages {

  if  $mysql::mysql_distro == "mariadb" {
        $packs = [ "MariaDB-Galera-server", rsync ]
        $mysql_bin = "mysql"
        $require = Yumrepo['mysql-repo'] 
  } elsif  $mysql::mysql_distro == "percona" {
        $packs = [ "Percona-XtraDB-Cluster-server-${mysql::mysql_ver}", "Percona-XtraDB-Cluster-client-${mysql::mysql_ver}", "rsync", "qpress" ]
        $packs_galera = [ "Percona-XtraDB-Cluster-galera-${mysql::galera_version}", "Percona-Server-shared-compat" ]
        $mysql_bin = "mysql"
        $require = [ Package[$packs_galera], Yumrepo['epel'] ]
        package {
            $packs_galera:
                    require => Yumrepo['mysql-repo'],
                    ensure  => "installed";
        }
  }
  
  info("Distro is $mysql::mysql_distro")

  package {
        $packs:
                    require => $require,
                    ensure  => "installed";
  }

}
