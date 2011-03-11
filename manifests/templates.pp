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
    "apache2",
    "libapache2-mod-wsgi",
  ]

  package { $webpackages:
    ensure => present,
  }

}

class dbserver {
}
