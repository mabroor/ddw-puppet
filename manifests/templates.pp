class baseserver {
  package { "git-core":
    ensure => present,
  }
}

class webserver {
}

class dbserver {
}
