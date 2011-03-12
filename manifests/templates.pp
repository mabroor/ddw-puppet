class baseserver {
  package { "git-core":
    ensure => present,
  }
}

class webserver {

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

}

class dbserver {
}
