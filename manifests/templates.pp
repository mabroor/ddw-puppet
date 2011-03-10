class baseserver {
  package { "git-core":
    ensure => present,
  }
}

class webserver {

  $root = "/home/web"

  file { $root:
    ensure => directory,
  }

  $webpackages = [
    "python-dev",
    "python-setuptools",
    "postgresql-client",
    "build-essential",
    "libpq-dev",
    "subversion",
    "mercurial",
  ]

  package { $webpackages:
    ensure => present,
  }

  include mingus
}

class dbserver {
}
