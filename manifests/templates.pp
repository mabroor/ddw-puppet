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

  include virtualenv

  $blog_venv = "$root/myblog"
  virtualenv::environment { $blog_venv: }

  $mingus_root = "$root/myblog/django-mingus"
  exec { "mingus-src":
    command => "git clone git://github.com/montylounge/django-mingus.git $mingus_root",
    creates => $mingus_root,
    require => [File[$root], Virtualenv::Environment[$blog_venv]],
  }

  exec { "update-pip":
    command => "$blog_venv/bin/pip install -U pip",
    onlyif => "test `$blog_venv/bin/pip --version | cut -f 2 -d ' '` = '0.8.1'",
  }

  exec { "mingus-requirements":
    command => "$blog_venv/bin/pip install -r $mingus_root/mingus/stable-requirements.txt && touch $blog_venv/MINGUS_REQUIREMENTS_INSTALLED",
    unless => "/bin/sh -c '[ -f $blog_venv/MINGUS_REQUIREMENTS_INSTALLED ]'",
    require => [Exec["mingus-src"], Exec["update-pip"]],
  }
}

class dbserver {
}
