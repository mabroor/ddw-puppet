class baseserver {
  package { "git-core":
    ensure => present,
  }
}

class webserver {

  file { "/home/web":
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

  include virtualenv
}

class dbserver {
}
