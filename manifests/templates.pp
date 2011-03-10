class baseserver {
  package { "git-core":
    ensure => present,
  }
}

class webserver {

  file { "/home/web":
    ensure => directory,
  }
}

class dbserver {
}
