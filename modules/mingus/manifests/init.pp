class mingus {

  $root = "/home/web"

  file { $root:
    ensure => directory,
  }

  include virtualenv

  $blog_venv = "$root/myblog"
  virtualenv::environment { $blog_venv:
    require => File[$root],
  }

  $mingus_root = "$root/myblog/django-mingus"
  exec { "mingus-src":
    command => "git clone git://github.com/montylounge/django-mingus.git $mingus_root",
    creates => $mingus_root,
    require => Virtualenv::Environment[$blog_venv],
  }

  $mingus_requirements = "$mingus_root/mingus/stable-requirements.txt"
  file { $mingus_requirements:
    source => "puppet:///modules/mingus/working_mingus_requirements.txt",
    require => Exec["mingus-src"],
  }

  exec { "mingus-requirements":
    command => "$blog_venv/bin/pip install -r $mingus_requirements && touch $blog_venv/MINGUS_REQUIREMENTS_INSTALLED",
    unless => "/bin/sh -c '[ -f $blog_venv/MINGUS_REQUIREMENTS_INSTALLED ]'",
    require => File[$mingus_requirements],
  }

  file { "$mingus_root/mingus/local_settings.py":
    content => template("mingus/local_settings.py.erb"),
    require => Exec["mingus-src"],
  }
}
