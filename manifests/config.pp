class mysql::config {

 $root_password = $mysql::mysql_root_password
 $old_root_password = $mysql::mysql_old_root_password

 if $root_password != undef {
   case $old_root_password {
     undef   : { $old_pwd = '' }
     default : { $old_pwd = "-p'${old_root_password}'" }
   }
 }

 exec { 'set_root_pwd':
	command   => "mysqladmin -u root ${old_pwd} password '${root_password}'",
        logoutput => true,
        unless    => "mysqladmin -u root -p'${root_password}' status > /dev/null",
        path      => '/usr/local/sbin:/usr/bin:/usr/local/bin',
 }
 
 file { '/root/.my.cnf':
     ensure  => present,
     content => template("mysql/rootmy.cnf.erb"),

 }
}
