class webbank_jenkins {
 
 #------------------------------sync build env checking script------------------------------
  file { 'CI_jenkins_env_autoTest':
    name    => '/data/rdm/apps/CI_jenkins_env_autoTest.sh',
    ensure  => file,
    require => Exec['apps path'],
    owner   => mqq,
    group   => mqq,
    mode    => 755,
    source  => 'puppet:///modules/webbank_jenkins/common/CI_jenkins_env_autoTest.sh';
  }
  
  file { 'CI_build_env_strategy_check':
    name    => '/data/rdm/apps/CI_build_env_strategy_check.sh',
    ensure  => file,
	require => Exec['apps path'],
    owner   => mqq,
    group   => mqq,
    mode    => 755,
    source  => 'puppet:///modules/webbank_jenkins/common/CI_build_env_strategy_check.sh';
  }
  
  file { 'CI_build_env_autoTestFunction':
    name    => '/data/rdm/apps/CI_build_env_autoTestFunction.sh',
    ensure  => file,
	require => Exec['apps path'],
    owner   => mqq,
    group   => mqq,
    mode    => 755,
    source  => 'puppet:///modules/webbank_jenkins/common/CI_build_env_autoTestFunction.sh';
  }
  
  
  #------------------------------mkdir /data/rdm/apps------------------------------ 
  exec { 'apps path':
    cwd    => '/data',
	creates  => '/data/rdm/apps',
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'chown mqq:mqq /data -R; mkdir /data/rdm/apps -p;chown rdm:rdm /data/rdm -R';
  }

  
  #------------------------------mkdir sub software path------------------------------   
  exec { 'mkdir apps sub dir':
    cwd      => '/data/rdm/apps',
	creates  => '/data/rdm/apps/python',
	require  => Exec['apps path'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'mkdir {python,7zip,ant,jdk,git,svn};chown rdm:rdm * -R';
  }
  
  
  #------------------------------install python------------------------------ 
  file { 'Python 2.7.5 package':
    name    => '/data/rdm/apps/python/Python-2.7.5.tgz',
    ensure  => present,
	require => Exec['mkdir apps sub dir'],
    owner   => rdm,
    group   => rdm,
    source  => 'puppet:///modules/webbank_jenkins/python/Python-2.7.5.tgz';
  }
  
  exec { 'Python-2.7.5':
    cwd      => '/data/rdm/apps/python',
	creates  => '/data/rdm/apps/python/Python-2.7.5',
	require  => File['Python 2.7.5 package'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'tar xzfv Python-2.7.5.tgz;cd Python-2.7.5;./configure;make;make install;chown rdm:rdm /data/rdm/apps/python/Python-2.7.5 -R';
  }
  
  file { '/usr/bin/python':
    ensure  => 'link',
    owner   => root,
    group   => root,
    mode    => 755,
    target  => '/usr/local/bin/python',
    require => Exec['Python-2.7.5'];
  } 
  
  
  #------------------------------install 7zip------------------------------ 
  file { '7zip 9.20 package':
    name    => '/data/rdm/apps/7zip/p7zip_9.20.1_x86_linux_bin.zip',
    ensure  => file,
	require => Exec['mkdir apps sub dir'],
    owner   => rdm,
    group   => rdm,
    source  => 'puppet:///modules/webbank_jenkins/7zip/p7zip_9.20.1_x86_linux_bin.zip';
  }
  
  exec { '7zip':
    cwd      => '/data/rdm/apps/7zip',
	creates  => '/data/rdm/apps/7zip/p7zip_9.20.1_bk',
	require  => File['7zip 9.20 package'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'unzip p7zip_9.20.1_x86_linux_bin.zip;cd p7zip_9.20.1_bk;./install.sh;chown rdm:rdm /data/rdm/apps/7zip/p7zip_9.20.1_bk -R';
  }
  
  file { '/usr/local/bin/7z':
    ensure  => 'link',
	target  => '/data/rdm/apps/7zip/p7zip_9.20.1_bk/bin/7z',
	require => Exec['7zip'];
  }
  
  
  #------------------------------install ant------------------------------ 
  file { 'ant 1.9.3 package':
    name    => '/data/rdm/apps/ant/apache-ant-1.9.3.tar.gz',
    ensure  => file,
	require => Exec['mkdir apps sub dir'],
    owner   => rdm,
    group   => rdm,
    source  => 'puppet:///modules/webbank_jenkins/ant/apache-ant-1.9.3.tar.gz';
  }
  
  exec { 'ant 1.9.3':
    cwd      => '/data/rdm/apps/ant',
	creates  => '/data/rdm/apps/ant/apache-ant-1.9.3',
	require  => File['ant 1.9.3 package'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'tar -zxf apache-ant-1.9.3.tar.gz;chown rdm:rdm /data/rdm/apps/ant/apache-ant-1.9.3 -R';
  }
  
  file { '/usr/local/bin/ant':
    ensure  => 'link',
	target  => '/data/rdm/apps/ant/apache-ant-1.9.3/bin/ant',
	require => Exec['ant 1.9.3'];
  }
  
  
  
  #------------------------------install git------------------------------ 
  file { 'git 1.9.2 package':
    name    => '/data/rdm/apps/git/git-1.9.2.tar.gz',
    ensure  => file,
	require => Exec['mkdir apps sub dir'],
    owner   => rdm,
    group   => rdm,
    source  => 'puppet:///modules/webbank_jenkins/git/git-1.9.2.tar.gz';
  }
  
  exec { 'git 1.9.2':
    cwd      => '/data/rdm/apps/git',
	creates  => '/data/rdm/apps/git/git-1.9.2',
	require  => File['git 1.9.2 package'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'tar xzfv git-1.9.2.tar.gz;cd git-1.9.2;./configure;make;make install;chown rdm:rdm /data/rdm/apps/git/git-1.9.2 -R';
  }
  
  
  #------------------------------install jdk------------------------------ 
  exec { 'jdk 1.6.0.45 package':
    cwd      => '/data/rdm/apps/jdk',
	creates  => '/data/rdm/apps/jdk/jdk-6u45-linux-i586.bin',
	require  => Exec['mkdir apps sub dir'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'wget "http://10.12.198.89:8080/glu/repository/tgzs/JDK/jdk-6u45-linux-i586.bin"';
  }
  
  exec { 'jdk 1.6.0.45':
    cwd      => '/data/rdm/apps/jdk',
	creates  => '/data/rdm/apps/jdk/jdk1.6.0_45',
	require  => File['resin.sh'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'chmod +x jdk-6u45-linux-i586.bin;./jdk-6u45-linux-i586.bin;chown rdm:rdm jdk1.6.0_45 -R';
  }
  
  exec { 'jdk 1.7.0.60 package':
    cwd      => '/data/rdm/apps/jdk',
	creates  => '/data/rdm/apps/jdk/jdk-7u60-ea-bin-b15-linux-x64-16_apr_2014.tar.gz',
	require  => File['resin.sh'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'wget "http://10.12.198.89:8080/glu/repository/tgzs/JDK/jdk-7u60-ea-bin-b15-linux-x64-16_apr_2014.tar.gz"';
  }
  
  exec { 'jdk 1.7.0.60':
    cwd      => '/data/rdm/apps/jdk',
	creates  => '/data/rdm/apps/jdk/jdk1.7.0_60',
	require  => Exec['jdk 1.7.0.60 package'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'tar xzfv jdk-7u60-ea-bin-b15-linux-x64-16_apr_2014.tar.gz;chown rdm:rdm jdk1.7.0_60 -R';
  }
  
  exec { 'jdk 1.8.0.5 package':
    cwd      => '/data/rdm/apps/jdk',
	creates  => '/data/rdm/apps/jdk/jdk-8u5-linux-x64.tar.gz',
	require  => File['resin.sh'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'wget "http://10.12.198.89:8080/glu/repository/tgzs/JDK/jdk-8u5-linux-x64.tar.gz"';
  }
  
  exec { 'jdk 1.8.0.5':
    cwd      => '/data/rdm/apps/jdk',
	creates  => '/data/rdm/apps/jdk/jdk1.8.0_05',
	require  => Exec['jdk 1.8.0.5 package'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'tar xzfv jdk-8u5-linux-x64.tar.gz;chown rdm:rdm jdk1.8.0_05 -R';
  }
  
  file { '/usr/local/jdk1.6.0_45':
    ensure  => 'link',
	target  => '/data/rdm/apps/jdk/jdk1.6.0_45',
	require => Exec['jdk 1.6.0.45'];
  }
  
  file { '/usr/local/jdk1.7.0_60':
    ensure  => 'link',
	target  => '/data/rdm/apps/jdk/jdk1.7.0_60',
	require => Exec['jdk 1.7.0.60'];
  }
  
  file { '/usr/local/jdk1.8.0_05':
    ensure  => 'link',
	target  => '/data/rdm/apps/jdk/jdk1.8.0_05',
	require => Exec['jdk 1.8.0.5'];
  }
   
  file { '/usr/bin/java':
    ensure  => 'link',
	target  => '/data/rdm/apps/jdk/jdk1.6.0_45/bin/java',
	require => Exec['jdk 1.6.0.45'];
  }
    
  file { '/usr/local/jdk':
    ensure  => 'link',
	target  => '/data/rdm/apps/jdk/jdk1.6.0_45',
	require => Exec['jdk 1.6.0.45'];
  }
  
  
  file { 'jdk profile':
    name    => '/etc/profile.d/jdk.sh',
    ensure  => file,
    owner   => root,
    group   => root,
    source  => 'puppet:///modules/webbank_jenkins/common/jdk.sh';
  }
  
  
  #------------------------------install svn------------------------------ 
  file { 'svn 1.7.9 package':
    name    => '/data/rdm/apps/svn/CollabNetSubversion-client-1.7.9-1.x86_64.rpm',
    ensure  => file,
	require => Exec['mkdir apps sub dir'],
    owner   => rdm,
    group   => rdm,
    source  => 'puppet:///modules/webbank_jenkins/svn/CollabNetSubversion-client-1.7.9-1.x86_64.rpm';
  }

  exec { 'svn 1.7.9':
    cwd      => '/data/rdm/apps/svn/',
    creates  => '/opt/CollabNet_Subversion',
    require  => File['svn 1.7.9 package'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
    command  => 'rpm -iv /data/rdm/apps/svn/CollabNetSubversion-client-1.7.9-1.x86_64.rpm';
  }
  
  file { 'svn config':
    name    => '/home/rdm/.subversion/config',
    ensure  => present,
	require => Exec['svn 1.7.9'],
    owner   => rdm,
    group   => rdm,
    source  => 'puppet:///modules/webbank_jenkins/svn/svn_config';
  }
  
  file { '/usr/bin/svn':
    ensure  => 'link',
	target  => '/opt/CollabNet_Subversion/bin/svn',
	require => Exec['svn 1.7.9'];
  }

  
 #------------------------------install zlib------------------------------
  exec { 'zlib-1.2.7':
	cwd      => '/data',
	creates  => '/data/rdm/apps/zlib/zlib-1.2.7.tar.gz',
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'mkdir -p /data/rdm/apps/zlib; chown rdm:rdm /data/rdm -R; cd /data/rdm/apps/zlib; wget "http://10.12.198.89:8080/glu/repository/tgzs/zlib-1.2.7.tar.gz";tar xzfv zlib-1.2.7.tar.gz;cd zlib-1.2.7;export CFLAGS=-m32;./configure && make && make install';
  }
  
  file { '/lib/libz.so.1':
    ensure  => 'link',
	target  => '/data/rdm/apps/zlib/zlib-1.2.7/libz.so.1.2.7',
    require => Exec['zlib-1.2.7'];
  }
}
