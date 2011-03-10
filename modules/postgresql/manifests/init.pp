define postgresql($listen_address="127.0.0.1", $allowed_ips=[]) {

  package { "postgresql":
    ensure => present,
  }

  File {
    owner => "postgres",
    group => "postgres",
    mode => 640,
  }

  $pgsql_root = "/etc/postgresql/8.4/main"
  file { "$pgsql_root/postgresql.conf":
    content => template("postgresql/postgresql.conf.erb"),
    require => Package["postgresql"],
  }

  file { "$pgsql_root/pg_hba.conf":
    content => template("postgresql/pg_hba.conf.erb"),
    require => Package["postgresql"],
  }

  service { "postgresql-8.4":
    ensure => running,
    enable => true,
    hasstatus => true,
    hasrestart => true,
    subscribe => [Package["postgresql"], File["$pgsql_root/postgresql.conf"], File["$pgsql_root/pg_hba.conf"]],
  }
}
