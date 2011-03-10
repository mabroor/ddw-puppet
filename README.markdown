The configuration of [Jacob Kaplan-Moss][jkm]'s [Django Deployment Workshop][ddw] at PyCon 2011
in Puppet.

Take a look a Jacob's [django-deployment-workshop][ore] for more detail.

Instructions
============

Bootstrapping Puppet
--------------------

While this can be automated, for now this will be done manually.

I'll create 3 512M Linode VMs with Ubuntu 10.4 LTS on them:

* web1.uggedal.com
* web2.uggedal.com
* db1.uggedal.com

Firstly we'll have to update the hostnames of these servers:

    FQDN=host.uggedal.com
    PUBLIC_IP_ADDRESS=`ifconfig eth0 | awk -F':' '/inet addr/{split($2,_," ");print _[1]}'`
    echo $FQDN > /etc/hostname && hostname -F /etc/hostname
    echo $PUBLIC_IP_ADDRESS `hostname` `hostname -s` >> /etc/hosts

We'll need a Puppet master that these three machines can contact to
receive configuration catalogs appropriate for them. In a larger
deployment we would use a seperate server for this, but to keep
things simple we'll setup *web1.uggedal.com* as our Puppet master:

    apt-get install -qq rdoc puppet puppetmaster

We then setup the Puppet client on the remaining servers:

    apt-get install -qq rdoc puppet

We'll have to tell all the servers where the Puppet master is (including the
client on the Puppet master *web1.uggedal.com*):

    echo "74.207.233.12 web1.uggedal.com web1" >> /etc/hosts
    echo "server=web1.uggedal.com" >> /etc/puppet/puppet.conf

Then we can try a test run of the Puppet clients. We'll provide an option to
wait for certificate signing on the Puppet master:

    puppetd --test --waitforcert 180

On the Puppet master we'll look at certificate request from the clients:

    root@web1:~# puppetca --list
    web2.uggedal.com
    db1.uggedal.com


And sign them:

    puppetca --sign web2.uggedal.com
    puppetca --sign db1.uggedal.com

We don't have to sign *web1.uggedal.com* since Puppet automatically signs
requests from the same machine. If we have completed a Puppet client test run
on all hosts we can check that all have been signed correctly (denoted by a
plus sign):

    root@web1:~# puppetca --list --all
    + db1.uggedal.com
    + web1.uggedal.com
    + web2.uggedal.com

After we've signed all the clients you'll notice that the
`puppetd --test --waitforcert 180` runs failed with some error output. Don't
worry, we'll fix this by adding our Puppet configuration to the Puppet master:

    rm -r /etc/puppet
    apt-get install git-core
    git clone git://github.com/uggedal/ddw-puppet.git /etc/puppet
    invoke-rc.d puppetmaster restart


Configuring our servers with Puppet
-----------------------------------

The Puppet configuration cloned at the end of the bootstrap is specific
to my setup on Linode and you'll have to change the hostsnames and
ip addresses to ones matching your environment.

On Ubuntu the Puppet client daemons don't get started by default. This is
perfectly fine for this exercise so we'll just run them manually on all
three servers:

    puppetd --test

If all goes well you should have two web hosts and one database host running.

**At this time the configuration is incomplete.** The current configuration
is just what I managed to write during the tutorial. The following items
remains to be implemented (watch this space):

* Postgresql users and database for Mingus.
* Configuring Mingus to use our Postgresql database.
* Apache with mod_wsgi.
* Load balancing with Nginx.



[jkm]: http://jacobian.org/
[ddw]: http://us.pycon.org/2011/schedule/presentations/173/
[ore]: https://github.com/jacobian/django-deployment-workshop/
