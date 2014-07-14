#base module 
#
#######
mkdir -p /etc/puppet/modules/base/{files,manifests,templates,lib,tests,spec}
mkdir -p /etc/puppet/modules/base/files/test
cat >> /etc/puppet/modules/base/manifests/touch.pp <<EOF
#touch.pp for puppet
class base::touch {
    file { "/usr/local/src/passwd":
        backup => ".bak_$uptime_seconds",
        ensure => present,
        group => nobody,
        owner => nobody,
        mode => 600,
        content => "hello world!!",
    }
}
EOF

cat >> /etc/puppet/modules/base/manifests/user.pp <<EOF
class base::user {
       group { "web":
        		ensure => "present",
        		gid => 1000,
         	name => "web";
        }
      user { "web":
        		ensure => "present",
        		gid => 1000,
		uid => 1000,		
		home  => "/home/web",
		managehome => true,
		password => '123456',   #需要从/etc/shadow拷贝或者生成
        		allowdupe => true;
        }
}
EOF


cat >> /etc/puppet/modules/base/manifests/file.pp <<EOF
class base::file {
	package{ setup:
	                ensure => present,
	        }
	 file{ "/etc/motd":
	                owner => "web",
	                group => "web",
	                mode => 0700,
	                source => "puppet:///modules/base/test/ puppet://$puppetserver/modules/base/files/etc/motd",
	                require => Package["setup"],
	  }
}
EOF




mkdir  /etc/puppet/manifests/nodes
cat >> /etc/puppet/manifests/nodes/agent.domain.com.pp<<EOF
#base nodes db1.pp for puppet
node 'agent.domain.com' {
    include base
}
EOF


cat >> /etc/puppet/manifests/modules.pp <<EOF
import "base"
EOF

cat >> /etc/puppet/manifests/site.pp <<EOF
import "modules.pp"
import "nodes/*.pp"
EOF

cat >> /etc/puppet/modules/base/manifests/sync.pp <<EOF
class base::sync {
    file { "/usr/local/src/test":
        ensure  => directory,
        source  => "puppet:///modules/base/test/",
        ignore  => '*log*',
        recurse => true,
#purge   => true,
#force   => true,
    }
}
EOF


cat >> /etc/puppet/modules/base/manifests/init.pp<<EOF
#base module init.pp for puppet
class base {
    include base::touch,base::sync,base::user,base::file
}
EOF

######