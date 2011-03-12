node basenode {
  include baseserver
}

node "web1.uggedal.com" inherits basenode {
  include webserver

  $database_host = "74.207.233.129"
  include mingus

  nginx { "mingus":
    backends => ["74.207.233.12:8000 weight=2", "74.207.233.124:8000 weight=3"],
  }
}

node "web2.uggedal.com" inherits basenode {
  include webserver

  $database_host = "74.207.233.129"
  include mingus
}

node "db1.uggedal.com" inherits basenode {
  include dbserver

  postgresql { "standard":
    listen_address => "74.207.233.129",
    allowed_ips => ["74.207.233.12", "74.207.233.124"],
  }

  postgresql::database { "mingus":
    owner => "mingus",
  }
}
