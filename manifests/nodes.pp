node basenode {
  include baseserver
}

node "web1.uggedal.com" inherits basenode {
  include webserver
}

node "web2.uggedal.com" inherits basenode {
  include webserver
}

node "db1.uggedal.com" inherits basenode {
  include dbserver
}
