class virtualenv {
  exec { "easy_install virtualenv":
    unless => "which virtualenv",
    require => Package["python-setuptools"],
  }
}

define virtualenv::environment($user="root", $group="root") {

  exec { "virtualenv $name":
    command => "virtualenv ${name}",
    user => $user,
    group => $group,
    creates => $name,
  }

  exec { "update-pip $name":
    command => "$name/bin/pip install -U pip",
    onlyif => "test `$name/bin/pip --version | cut -f 2 -d ' '` = '0.8.1'",
    require => Exec["virtualenv $name"],
  }
}
