node basenode {
  include baseserver
}

node "web1.uggedal.com" inherits basenode {
}

node "web2.uggedal.com" inherits basenode {
}

node "db1.uggedal.com" inherits basenode {
}
