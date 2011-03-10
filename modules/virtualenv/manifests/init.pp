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
}
