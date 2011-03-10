class virtualenv {
  exec { "easy_install virtualenv":
    unless => "which virtualenv",
    require => Package["python-setuptools"],
  }
}
