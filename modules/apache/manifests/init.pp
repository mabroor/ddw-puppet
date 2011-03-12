define apache($listen_port="80", $wsgi_script_aliases=[]) {

  package { ["apache2", "libapache2-mod-wsgi"]:
    ensure => present,
  }

  file { "/etc/apache2/apache2.conf":
    content => template("apache/apache2.conf.erb"),
    require => Package["apache2"],
  }

  file { "/home/web/static":
    ensure => directory,
  }

  service { "apache2":
    ensure => running,
    enable => true,
    hasstatus => true,
    hasrestart => true,
    subscribe => [Package["apache2"], File["/etc/apache2/apache2.conf"]],
    require => File["/home/web/static"],
  }
}
