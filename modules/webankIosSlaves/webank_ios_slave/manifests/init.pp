class webank_ios_slave {
 Exec {
  path => ['/usr/bin','/usr/sbin','/bin', '/usr/local/bin', '/usr/local/share/bin']
 }

 File {
    owner => rdm,
    group => rdm
 }

 group { "rdm":
    ensure => "present",
}

 user { "rdm":
  ensure => "present",
  home => "/home/rdm",
  name => "rdm",
  shell => "/bin/bash",
  groups => 'rdm',
  require => Group['rdm']
 }

  # todo: install brew and install wget
  exec { 'apps path':
    cwd    => '/data',
	creates  => '/data/rdm/apps',
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'mkdir -p /data/rdm/apps /data/rdm/slaves /data/rdm/repository /data/rdm/slaves_home /data/rdm/projects;chown -R rdm:rdm /data/rdm';
  }
  
  exec { 'mkdir apps sub dir':
    cwd      => '/data/rdm/apps',
	creates  => '/data/rdm/apps/python',
	require  => Exec['apps path'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'mkdir {python,maven,ant,jdk,git,svn,xcode};chown -R rdm:rdm *';
  }

  
  exec { 'Python 2.7.5 package':
    cwd      => '/data/rdm/apps/python',
	creates  => '/data/rdm/apps/python/python-2.7.5-macosx10.6.dmg',
	command  => 'wget "http://10.12.198.89:8080/glu/repository/tgzs/mac/python-2.7.5-macosx10.6.dmg"';
  } 
  
  exec { 'Python-2.7.5':
    cwd      => '/Library/Frameworks/',
	creates  => '/Library/Frameworks/Python.framework/Versions/2.7/bin',
	require  => Exec['Python 2.7.5 package'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'hdiutil attach /data/rdm/apps/python/python-2.7.5-macosx10.6.dmg; sudo installer -pkg /Volumes/Python\ 2.7.5/Python.mpkg -target /';
  }
  
  file { '/usr/bin/python':
    ensure  => 'link',
    owner   => root,
    mode    => 755,
    target  => '/usr/local/bin/python',
    require => Exec['Python-2.7.5'];
  } 
  
  file { 'maven 3.2.1 package':
    name    => '/data/rdm/apps/maven/apache-maven-3.2.1-bin.tar.gz',
    ensure  => file,
	require => Exec['mkdir apps sub dir'],
    source  => 'puppet:///modules/rdm_mac_slave/maven/apache-maven-3.2.1-bin.tar.gz';
    #source  => '/tmp/slave/apache-maven-3.2.1-bin.tar.gz';
  }
  
  exec { 'maven-3.2.1':
    cwd      => '/data/rdm/apps/maven',
	creates  => '/data/rdm/apps/maven/apache-maven-3.2.1',
	require  => File['maven 3.2.1 package'],
	command  => 'tar -zxf apache-maven-3.2.1-bin.tar.gz;chown -R rdm:rdm  /data/rdm/apps/maven/apache-maven-3.2.1';
  }
  
  file { '/usr/local/bin/mvn':
    ensure  => 'link',
	target  => '/data/rdm/apps/maven/apache-maven-3.2.1/bin/mvn',
	require => Exec['maven-3.2.1'];
  }
  
  file { '/usr/bin/mvn':
    ensure  => 'link',
	target  => '/data/rdm/apps/maven/apache-maven-3.2.1/bin/mvn',
	require => Exec['maven-3.2.1'];
  }
  
  file { 'ant 1.9.3 package':
    name    => '/data/rdm/apps/ant/apache-ant-1.9.3.tar.gz',
    ensure  => file,
	require => Exec['mkdir apps sub dir'],
    source  => 'puppet:///modules/rdm_mac_slave/ant/apache-ant-1.9.3.tar.gz';
    #source  => '/tmp/slave/apache-ant-1.9.3.tar.gz';
  }

  
  exec { 'ant 1.9.3':
    cwd      => '/data/rdm/apps/ant',
	creates  => '/data/rdm/apps/ant/apache-ant-1.9.3',
	require  => File['ant 1.9.3 package'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'tar -zxf apache-ant-1.9.3.tar.gz;chown -R rdm:rdm /data/rdm/apps/ant/apache-ant-1.9.3';
  }
  
  file { '/usr/local/bin/ant':
    ensure  => 'link',
	target  => '/data/rdm/apps/ant/apache-ant-1.9.3/bin/ant',
	require => Exec['ant 1.9.3'];
  }
    
  file { '/usr/bin/ant':
    ensure  => 'link',
	target  => '/data/rdm/apps/ant/apache-ant-1.9.3/bin/ant',
	require => Exec['ant 1.9.3'];
  }
	
  file { 'git 1.9.2 package':
    name    => '/data/rdm/apps/git/git-1.9.2.tar.gz',
    ensure  => file,
	require => Exec['mkdir apps sub dir'],
    source  => 'puppet:///modules/rdm_mac_slave/git/git-1.9.2.tar.gz';
    #source => '/tmp/slave/git-1.9.2.tar.gz';
  }
  
  exec { 'git 1.9.2':
    cwd      => '/data/rdm/apps/git',
	creates  => '/data/rdm/apps/git/git-1.9.2',
	require  => File['git 1.9.2 package'],
	command  => 'tar xzfv git-1.9.2.tar.gz;cd git-1.9.2;./configure;make;make install;chown -R rdm:rdm /data/rdm/apps/git/git-1.9.2';
  }
  
  file { '/usr/local/bin/git':
    ensure  => 'link',
	target  => '/data/rdm/apps/git/git-1.9.2/git',
	require => Exec['git 1.9.2'];
  }
    
  file { '/usr/bin/git':
    ensure  => 'link',
	target  => '/data/rdm/apps/git/git-1.9.2/git',
	require => Exec['git 1.9.2'];
  }
  
  exec { 'jdk 1.7.0.60 package':
    cwd      => '/data/rdm/apps/jdk',
	creates  => '/data/rdm/apps/jdk/jdk-7u60-macosx-x64.dmg',
	require  => Exec['mkdir apps sub dir'],
	command  => 'wget "http://10.12.198.89:8080/glu/repository/tgzs/mac/jdk-7u60-macosx-x64.dmg"';
  }
  
  exec { 'jdk 1.7.0.60':
    cwd      => '/Library/Java/JavaVirtualMachines',
	creates  => '/Library/Java/JavaVirtualMachines/jdk1.7.0_60.jdk',
	require  => Exec['jdk 1.7.0.60 package'],
	command  => 'hdiutil attach /data/rdm/apps/jdk/jdk-7u60-macosx-x64.dmg;sudo installer -pkg /Volumes/JDK\ 7\ Update\ 60/JDK\ 7\ Update\ 60.pkg -target /';
  }
  
  file { '/data/rdm/apps/jdk/jdk1.7':
    ensure  => 'link',
	target  => '/Library/Java/JavaVirtualMachines/jdk1.7.0_60.jdk',
	require => Exec['jdk 1.7.0.60'];
  }

 file { '/usr/bin/java':
    ensure  => 'link',
  target  => '/Library/Java/JavaVirtualMachines/jdk1.7.0_60.jdk/Contents/Home/bin/java',
  require => Exec['jdk 1.7.0.60'];
  }
  
  file { 'ssh path':
    name    => '/Users/rdm/.ssh',
    ensure  => directory,
	   mode    => 700
  }
  
  file { 'ssl file':
    name    => '/Users/rdm/.ssh/authorized_keys',
    ensure  => file,
	require => File['ssh path'],
	mode    => 600,
    source  => 'puppet:///modules/rdm_mac_slave/ssl_cert/RDM_jenkins_ssl_cert.pub';
    #source  => '/tmp/slave/RDM_jenkins_ssl_cert.pub';
  }

  file { 'workflow script':
    name    => '/data/rdm/workflow',
    ensure  => directory,
  require => Exec['apps path'],
  ignore  => '.svn',
  recurse => true,
    source  => 'puppet:///modules/rdm_mac_slave/workflow';
    #source  => '/tmp/slave/workflow';
  }
  
  exec { 'xcode_5.1.1 package':
    cwd      => '/data/rdm/apps/xcode',
	creates  => '/data/rdm/apps/xcode/xcode_5.1.1.dmg',
	require  => Exec['mkdir apps sub dir'],
	command  => 'wget "http://10.12.198.89:8080/glu/repository/tgzs/mac/xcode_5.1.1.dmg";chown rdm:rdm xcode_5.1.1.dmg';
  }
  
  exec { 'xcode_5.1.1':
    cwd      => '/data/rdm/apps/xcode',
	require  => Exec['xcode_5.1.1 package'],
	command  => 'hdiutil attach /data/rdm/apps/xcode/xcode_5.1.1.dmg -nomount;';
  }
}
