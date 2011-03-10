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
  postgresql { "standard":
    listen_address => "74.207.233.129",
    allowed_ips => ["74.207.233.12", "74.207.233.124"],
  }
}
