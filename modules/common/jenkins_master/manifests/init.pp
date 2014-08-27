class jenkins_master {
#------------------------------install resin------------------------------
file { 'resin package':
  name    => '/data/tools/resin-4.0.27.tar.gz',
  ensure  => file,
  owner   => rdm,
  group   => rdm,
  require => Exec['mkdir apps sub dir'],
  source  => 'puppet:///modules/webbank_jenkins/resin/resin-4.0.27.tar.gz';
}

exec { 'resin deploy':
  command  => 'tar -zxf /data/tools/resin-4.0.27.tar.gz;chown -R rdm:rdm /data/resin-4.0.27',
  cwd      => '/data',
  creates  => '/data/resin-4.0.27',
  require  => File['resin package'],
  path     => ['/usr/bin','/usr/sbin','/bin'];
}

file { 'resin config':
  path     => '/data/resin-4.0.27/conf/resin.properties',
  ensure   => file,
  owner    => rdm,
  group    => rdm,
  require  => Exec['resin deploy'],
  content  => template("webbank_jenkins/resin.properties.erb");
}

file { 'resin.sh':
  name     => '/data/resin-4.0.27/bin/resin.sh',
  ensure   => file,
  owner    => rdm,
  mode     => 755,
  group    => rdm,
  require  => File['resin config'],
  source   => 'puppet:///modules/webbank_jenkins/resin/resin.sh';
}

exec { 'start resin':
  command  => 'rm -rf /data/resin_log /data/resin_logs -r;chown -R rdm:rdm /data/resin-4.0.27;mkdir /data/resin_log /data/resin_logs;chown -R rdm:rdm /data/resin_log*;./start.sh',
  cwd      => '/data/resin-4.0.27/bin',
  creates  => '/data/resin_log',
  require  => File['jenkins plugins'],
  path     => ['/usr/bin','/usr/sbin','/bin'];
}


#------------------------------sync jenkins app package------------------------------
file { 'jenkins package':
  name    => '/data/tools/jenkins.tar.gz',
  ensure  => file,
  owner   => rdm,
  group   => rdm,
  require => File['/usr/local/jdk'],
  source  => 'puppet:///modules/webbank_jenkins/jenkins/jenkins.tar.gz';
}

exec { 'jenkins deploy':
  command  => 'tar -zxf /data/tools/jenkins.tar.gz;chown -R rdm:rdm jenkins',
  cwd      => '/data/resin-4.0.27/webapps',
  creates  => '/data/resin-4.0.27/webapps/jenkins',
  require  => File['jenkins package'],
  path     => ['/usr/bin','/usr/sbin','/bin'];
}


#------------------------------sync hudson_jobs_conf------------------------------
exec { 'jenkins config':
  command  => 'wget "http://10.12.198.89:8080/glu/repository/tgzs/hudson_backup/hudson_init.tar.gz";tar xzfv hudson_init.tar.gz;chown rdm:rdm /data/hudson -R;rm -r /data/hudson/plugins/*',
  cwd      => '/data/',
  creates  => '/data/hudson/jobs',
  require  => Exec['jenkins deploy'],
  path     => ['/usr/bin','/usr/sbin','/bin'];
}

file { 'jenkins plugins':
  name    => '/data/hudson/plugins',
  ensure  => directory,
  owner   => mqq,
  group   => mqq,
  require => Exec['jenkins config'],
  recurse => true,
  source  => 'puppet:///modules/webbank_jenkins/plugins';
}

}
