class webbank_linux_android_slave {
  #------------------------------mkdir common path------------------------------
  exec { 'apps path':
    cwd    => '/data',
	creates  => '/data/rdm/apps',
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'chown mqq:mqq /data -R; mkdir /data/rdm/apps -p;chown rdm:rdm /data/rdm -R';
  }
  
  exec { '/data/rdm/slaves':
    cwd    => '/data',
	creates  => '/data/rdm/slaves',
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'mkdir /data/rdm/slaves -p;chown rdm:rdm /data/rdm/slaves -R';
  }
  
  exec { '/data/rdm/slaves_home':
    cwd    => '/data',
	creates  => '/data/rdm/slaves_home',
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'mkdir /data/rdm/slaves_home -p;chown rdm:rdm /data/rdm/slaves_home -R';
  }
  
  exec { '/data/rdm/projects':
    cwd    => '/data',
	creates  => '/data/rdm/projects',
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'mkdir /data/rdm/projects -p;chown rdm:rdm /data/rdm/projects -R';
  }
  
  exec { 'mkdir apps sub dir':
    cwd      => '/data/rdm/apps',
	creates  => '/data/rdm/apps/python',
	require  => Exec['apps path'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'mkdir {python,7zip,maven,ant,jdk,sdk,ndk,proguard,git,svn,sdk/platforms};chown rdm:rdm * -R';
  }
  
  
  #------------------------------install Python------------------------------
  file { 'Python 2.7.5 package':
    name    => '/data/rdm/apps/python/Python-2.7.5.tgz',
    ensure  => present,
	require => Exec['mkdir apps sub dir'],
    owner   => rdm,
    group   => rdm,
    source  => 'puppet:///modules/webbank_linux_android_slave/python/Python-2.7.5.tgz';
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
    source  => 'puppet:///modules/webbank_linux_android_slave/7zip/p7zip_9.20.1_x86_linux_bin.zip';
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
  
  
  #------------------------------install maven------------------------------
  file { 'maven 3.2.1 package':
    name    => '/data/rdm/apps/maven/apache-maven-3.2.1-bin.tar.gz',
    ensure  => file,
	require => Exec['mkdir apps sub dir'],
    owner   => rdm,
    group   => rdm,
    source  => 'puppet:///modules/webbank_linux_android_slave/maven/apache-maven-3.2.1-bin.tar.gz';
  }
  
  exec { 'maven-3.2.1':
    cwd      => '/data/rdm/apps/maven',
	creates  => '/data/rdm/apps/maven/apache-maven-3.2.1',
	require  => File['maven 3.2.1 package'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'tar -zxf apache-maven-3.2.1-bin.tar.gz;chown rdm:rdm /data/rdm/apps/maven/apache-maven-3.2.1 -R';
  }
  
  file { '/usr/local/bin/mvn':
    ensure  => 'link',
	target  => '/data/rdm/apps/maven/apache-maven-3.2.1/bin/mvn',
	require => Exec['maven-3.2.1'];
  }
  
  
  #------------------------------install ant------------------------------
  file { 'ant 1.9.3 package':
    name    => '/data/rdm/apps/ant/apache-ant-1.9.3.tar.gz',
    ensure  => file,
	require => Exec['mkdir apps sub dir'],
    owner   => rdm,
    group   => rdm,
    source  => 'puppet:///modules/webbank_linux_android_slave/ant/apache-ant-1.9.3.tar.gz';
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
  
  
  #------------------------------install proguard------------------------------
  file { 'proguard 4.11 package':
    name    => '/data/rdm/apps/proguard/proguard4.11.tar.gz',
    ensure  => file,
	require => Exec['mkdir apps sub dir'],
    owner   => rdm,
    group   => rdm,
    source  => 'puppet:///modules/webbank_linux_android_slave/proguard/proguard4.11.tar.gz';
  }
  
  exec { 'proguard 4.11':
    cwd      => '/data/rdm/apps/proguard',
	creates  => '/data/rdm/apps/proguard/proguard4.11',
	require  => File['proguard 4.11 package'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'tar xzfv proguard4.11.tar.gz;chown rdm:rdm /data/rdm/apps/proguard/proguard4.11 -R';
  }
  
  file { '/data/rdm/apps/PROGUARD_LINUX_4.11':
    ensure  => 'link',
	owner   => rdm,
    group   => rdm,
	target  => '/data/rdm/apps/proguard/proguard4.11',
	require => Exec['proguard 4.11'];
  }
  
  file { 'proguard4.8 package':
    name    => '/data/rdm/apps/proguard/proguard4.8.zip',
    ensure  => file,
	require => Exec['mkdir apps sub dir'],
    owner   => rdm,
    group   => rdm,
    source  => 'puppet:///modules/webbank_linux_android_slave/proguard/proguard4.8.zip';
  }
  
  exec { 'proguard 4.8':
    cwd      => '/data/rdm/apps/proguard',
	creates  => '/data/rdm/apps/proguard/proguard4.8',
	require  => File['proguard4.8 package'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'unzip proguard4.8.zip;chown rdm:rdm /data/rdm/apps/proguard/proguard4.8 -R';
  }
  
  file { '/data/rdm/apps/PROGUARD_LINUX_4.8':
    ensure  => 'link',
	owner   => rdm,
    group   => rdm,
	target  => '/data/rdm/apps/proguard/proguard4.8',
	require => Exec['proguard 4.8'];
  }
  
  
  #------------------------------install git------------------------------
  file { 'git 1.9.2 package':
    name    => '/data/rdm/apps/git/git-1.9.2.tar.gz',
    ensure  => file,
	require => Exec['mkdir apps sub dir'],
    owner   => rdm,
    group   => rdm,
    source  => 'puppet:///modules/webbank_linux_android_slave/git/git-1.9.2.tar.gz';
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
	require  => Exec['jdk 1.6.0.45 package'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'chmod +x jdk-6u45-linux-i586.bin;./jdk-6u45-linux-i586.bin;chown rdm:rdm jdk1.6.0_45 -R';
  }
  
  exec { 'jdk 1.7.0.60 package':
    cwd      => '/data/rdm/apps/jdk',
	creates  => '/data/rdm/apps/jdk/jdk-7u60-ea-bin-b15-linux-x64-16_apr_2014.tar.gz',
	require  => Exec['mkdir apps sub dir'],
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
	require  => Exec['mkdir apps sub dir'],
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
  
  file { '/data/rdm/apps/jdk/1.6':
    ensure  => 'link',
	target  => '/data/rdm/apps/jdk/jdk1.6.0_45',
	require => Exec['jdk 1.6.0.45'];
  }
  
  file { '/data/rdm/apps/jdk/1.7':
    ensure  => 'link',
	target  => '/data/rdm/apps/jdk/jdk1.7.0_60',
	require => Exec['jdk 1.7.0.60'];
  }
  
  file { '/data/rdm/apps/jdk/1.8':
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
    source  => 'puppet:///modules/webbank_linux_android_slave/common/jdk.sh';
  }
  
  
  #------------------------------install sdk------------------------------
  exec { 'sdk platforms 7 package':
	cwd      => '/data/rdm/apps/sdk/platforms',
	creates  => '/data/rdm/apps/sdk/platforms/android-7',
	require  => Exec['mkdir apps sub dir'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'wget "http://10.12.198.89:8080/glu/repository/tgzs/Android_SDK/platforms/7.zip";unzip 7.zip;chown rdm:rdm android-7 -R';
  }
  
   exec { 'sdk platforms 8 package':
	cwd      => '/data/rdm/apps/sdk/platforms',
	creates  => '/data/rdm/apps/sdk/platforms/android-8',
	require  => Exec['mkdir apps sub dir'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'wget "http://10.12.198.89:8080/glu/repository/tgzs/Android_SDK/platforms/8.zip";unzip 8.zip;chown rdm:rdm android-8 -R';
  }
  
   exec { 'sdk platforms 9 package':
	cwd      => '/data/rdm/apps/sdk/platforms',
	creates  => '/data/rdm/apps/sdk/platforms/android-9',
	require  => Exec['mkdir apps sub dir'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'wget "http://10.12.198.89:8080/glu/repository/tgzs/Android_SDK/platforms/9.zip";unzip 9.zip;chown rdm:rdm android-9 -R';
  }
  
   exec { 'sdk platforms 10 package':
	cwd      => '/data/rdm/apps/sdk/platforms',
	creates  => '/data/rdm/apps/sdk/platforms/android-10',
	require  => Exec['mkdir apps sub dir'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'wget "http://10.12.198.89:8080/glu/repository/tgzs/Android_SDK/platforms/10.zip";unzip 10.zip;chown rdm:rdm android-10 -R';
  }
  
   exec { 'sdk platforms 11 package':
	cwd      => '/data/rdm/apps/sdk/platforms',
	creates  => '/data/rdm/apps/sdk/platforms/android-11',
	require  => Exec['mkdir apps sub dir'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'wget "http://10.12.198.89:8080/glu/repository/tgzs/Android_SDK/platforms/11.zip";unzip 11.zip;chown rdm:rdm android-11 -R';
  }
  
   exec { 'sdk platforms 12 package':
	cwd      => '/data/rdm/apps/sdk/platforms',
	creates  => '/data/rdm/apps/sdk/platforms/android-12',
	require  => Exec['mkdir apps sub dir'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'wget "http://10.12.198.89:8080/glu/repository/tgzs/Android_SDK/platforms/12.zip";unzip 12.zip;chown rdm:rdm android-12 -R';
  }
  
   exec { 'sdk platforms 13 package':
	cwd      => '/data/rdm/apps/sdk/platforms',
	creates  => '/data/rdm/apps/sdk/platforms/android-13',
	require  => Exec['mkdir apps sub dir'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'wget "http://10.12.198.89:8080/glu/repository/tgzs/Android_SDK/platforms/13.zip";unzip 13.zip;chown rdm:rdm android-13 -R';
  }
  
   exec { 'sdk platforms 14 package':
	cwd      => '/data/rdm/apps/sdk/platforms',
	creates  => '/data/rdm/apps/sdk/platforms/android-14',
	require  => Exec['mkdir apps sub dir'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'wget "http://10.12.198.89:8080/glu/repository/tgzs/Android_SDK/platforms/14.zip";unzip 14.zip;chown rdm:rdm android-14 -R';
  }
  
   exec { 'sdk platforms 15 package':
	cwd      => '/data/rdm/apps/sdk/platforms',
	creates  => '/data/rdm/apps/sdk/platforms/android-15',
	require  => Exec['mkdir apps sub dir'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'wget "http://10.12.198.89:8080/glu/repository/tgzs/Android_SDK/platforms/15.zip";unzip 15.zip;chown rdm:rdm android-15 -R';
  }
  
   exec { 'sdk platforms 16 package':
	cwd      => '/data/rdm/apps/sdk/platforms',
	creates  => '/data/rdm/apps/sdk/platforms/android-16',
	require  => Exec['mkdir apps sub dir'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'wget "http://10.12.198.89:8080/glu/repository/tgzs/Android_SDK/platforms/16.zip";unzip 16.zip;chown rdm:rdm android-16 -R';
  }
  
   exec { 'sdk platforms 17 package':
	cwd      => '/data/rdm/apps/sdk/platforms',
	creates  => '/data/rdm/apps/sdk/platforms/android-17',
	require  => Exec['mkdir apps sub dir'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'wget "http://10.12.198.89:8080/glu/repository/tgzs/Android_SDK/platforms/17.zip";unzip 17.zip;chown rdm:rdm android-17 -R';
  }
  
   exec { 'sdk platforms 18 package':
	cwd      => '/data/rdm/apps/sdk/platforms',
	creates  => '/data/rdm/apps/sdk/platforms/android-18',
	require  => Exec['mkdir apps sub dir'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'wget "http://10.12.198.89:8080/glu/repository/tgzs/Android_SDK/platforms/18.zip";unzip 18.zip;chown rdm:rdm android-18 -R';
  }
  
  exec { 'sdk platforms 19 package':
	cwd      => '/data/rdm/apps/sdk/platforms',
	creates  => '/data/rdm/apps/sdk/platforms/android-19',
	require  => Exec['mkdir apps sub dir'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'wget "http://10.12.198.89:8080/glu/repository/tgzs/Android_SDK/platforms/19.zip";unzip 19.zip;chown rdm:rdm android-19 -R';
  }
  
  exec { 'sdk build-tools package':
	cwd      => '/data/rdm/apps/sdk',
	creates  => '/data/rdm/apps/sdk/build-tools',
	require  => Exec['mkdir apps sub dir'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'wget "http://10.12.198.89:8080/glu/repository/tgzs/Android_SDK/build-tools.tar.gz";tar xzfv build-tools.tar.gz;chown rdm:rdm build-tools -R';
  }
  
  exec { 'sdk platform-tools package':
	cwd      => '/data/rdm/apps/sdk',
	creates  => '/data/rdm/apps/sdk/platform-tools',
	require  => Exec['mkdir apps sub dir'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'wget "http://10.12.198.89:8080/glu/repository/tgzs/Android_SDK/platform-tools.tar.gz";tar xzfv platform-tools.tar.gz;chown rdm:rdm platform-tools -R';
  }
  
  exec { 'sdk tools package':
	cwd      => '/data/rdm/apps/sdk',
	creates  => '/data/rdm/apps/sdk/tools',
	require  => Exec['mkdir apps sub dir'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'wget "http://10.12.198.89:8080/glu/repository/tgzs/Android_SDK/tools.tar.gz";tar xzfv tools.tar.gz;chown rdm:rdm tools -R';
  }
  
  exec { 'sdk link package':
    cwd    => '/data/rdm/apps',
	creates  => '/data/rdm/apps/ANDROIDSDK_LINUX_R19',
    path     => ['/usr/bin','/usr/sbin','/bin'],
	require  => Exec['apps path'],
	command  => 'mkdir ANDROIDSDK_LINUX_R19 ANDROIDSDK_LINUX_R18 ANDROIDSDK_LINUX_R17 ANDROIDSDK_LINUX_R16 ANDROIDSDK_LINUX_R15 ANDROIDSDK_LINUX_R14 ANDROIDSDK_LINUX_R13 ANDROIDSDK_LINUX_R12 ANDROIDSDK_LINUX_R11 ANDROIDSDK_LINUX_R10 ANDROIDSDK_LINUX_R9 ANDROIDSDK_LINUX_R8 ANDROIDSDK_LINUX_R7;chown rdm:rdm /data/rdm/apps -R';
  }
  
  exec { 'ANDROIDSDK_LINUX_R19 platforms link':
    cwd      => '/data/rdm/apps',
	creates  => '/data/rdm/apps/ANDROIDSDK_LINUX_R19/platforms',
	require  => Exec['sdk link package'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'ln -s /data/rdm/apps/sdk/platforms /data/rdm/apps/ANDROIDSDK_LINUX_R19/platforms';
  }
  
  exec { 'ANDROIDSDK_LINUX_R19 platform_tools link':
    cwd      => '/data/rdm/apps',
	creates  => '/data/rdm/apps/ANDROIDSDK_LINUX_R19/platform-tools',
	require  => Exec['sdk link package'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'ln -s /data/rdm/apps/sdk/platform-tools/platform-tools_r19 /data/rdm/apps/ANDROIDSDK_LINUX_R19/platform-tools';
  }
  
  exec { 'ANDROIDSDK_LINUX_R19 tools link':
    cwd      => '/data/rdm/apps',
	creates  => '/data/rdm/apps/ANDROIDSDK_LINUX_R19/tools',
	require  => Exec['sdk link package'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'ln -s /data/rdm/apps/sdk/tools/tools_r22.3 /data/rdm/apps/ANDROIDSDK_LINUX_R19/tools';
  }
  
  file { 'ANDROIDSDK_LINUX_R19 build_tools':
    name    => '/data/rdm/apps/ANDROIDSDK_LINUX_R19/build-tools/',
    ensure  => directory,
	require => Exec['sdk link package'],
    owner   => rdm,
    group   => rdm;
  }
  
  exec { 'ANDROIDSDK_LINUX_R19 build_tools link':
    cwd      => '/data/rdm/apps',
	creates  => '/data/rdm/apps/ANDROIDSDK_LINUX_R19/build-tools/android-4.4.2',
	require  => File['ANDROIDSDK_LINUX_R19 build_tools'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'ln -s /data/rdm/apps/sdk/build-tools/android-4.4.2 /data/rdm/apps/ANDROIDSDK_LINUX_R19/build-tools/android-4.4.2';
  }
  
  exec { 'ANDROIDSDK_LINUX_R19 build_tools cp':
    cwd      => '/data/rdm/apps',
	creates  => '/data/rdm/apps/ANDROIDSDK_LINUX_R19/build-tools/renderscript',
	require  => File['ANDROIDSDK_LINUX_R19 build_tools'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'cp -r /data/rdm/apps/sdk/build-tools/android-4.4.2/* /data/rdm/apps/ANDROIDSDK_LINUX_R19/build-tools/; chown rdm:rdm /data/rdm/apps/ANDROIDSDK_LINUX_R19/build-tools/ -R';
  }
  
  exec { 'ANDROIDSDK_LINUX_R18 platforms link':
    cwd      => '/data/rdm/apps',
	creates  => '/data/rdm/apps/ANDROIDSDK_LINUX_R18/platforms',
	require  => Exec['sdk link package'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'ln -s /data/rdm/apps/sdk/platforms /data/rdm/apps/ANDROIDSDK_LINUX_R18/platforms';
  }
  
  exec { 'ANDROIDSDK_LINUX_R18 platform_tools link':
    cwd      => '/data/rdm/apps',
	creates  => '/data/rdm/apps/ANDROIDSDK_LINUX_R18/platform-tools',
	require  => Exec['sdk link package'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'ln -s /data/rdm/apps/sdk/platform-tools/platform-tools_r18 /data/rdm/apps/ANDROIDSDK_LINUX_R18/platform-tools';
  }
  
  exec { 'ANDROIDSDK_LINUX_R18 tools link':
    cwd      => '/data/rdm/apps',
	creates  => '/data/rdm/apps/ANDROIDSDK_LINUX_R18/tools',
	require  => Exec['sdk link package'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'ln -s /data/rdm/apps/sdk/tools/tools_r22.0.5 /data/rdm/apps/ANDROIDSDK_LINUX_R18/tools';
  }
  
  file { 'ANDROIDSDK_LINUX_R18 build_tools':
    name    => '/data/rdm/apps/ANDROIDSDK_LINUX_R18/build-tools/',
    ensure  => directory,
	require => Exec['sdk link package'],
    owner   => rdm,
    group   => rdm;
  }
  
  exec { 'ANDROIDSDK_LINUX_R18 build_tools link':
    cwd      => '/data/rdm/apps',
	creates  => '/data/rdm/apps/ANDROIDSDK_LINUX_R18/build-tools/android-4.3.1',
	require  => File['ANDROIDSDK_LINUX_R18 build_tools'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'ln -s /data/rdm/apps/sdk/build-tools/android-4.3.1 /data/rdm/apps/ANDROIDSDK_LINUX_R18/build-tools/android-4.3.1';
  }
  
  exec { 'ANDROIDSDK_LINUX_R18 build_tools cp':
    cwd      => '/data/rdm/apps',
	creates  => '/data/rdm/apps/ANDROIDSDK_LINUX_R18/build-tools/renderscript',
	require  => File['ANDROIDSDK_LINUX_R18 build_tools'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'cp -r /data/rdm/apps/sdk/build-tools/android-4.3.1/* /data/rdm/apps/ANDROIDSDK_LINUX_R18/build-tools/; chown rdm:rdm /data/rdm/apps/ANDROIDSDK_LINUX_R19/build-tools/ -R';
  }
  
  exec { 'ANDROIDSDK_LINUX_R17 platforms link':
    cwd      => '/data/rdm/apps',
	creates  => '/data/rdm/apps/ANDROIDSDK_LINUX_R17/platforms',
	require  => Exec['sdk link package'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'ln -s /data/rdm/apps/sdk/platforms /data/rdm/apps/ANDROIDSDK_LINUX_R17/platforms';
  }
  
  exec { 'ANDROIDSDK_LINUX_R17 platform_tools link':
    cwd      => '/data/rdm/apps',
	creates  => '/data/rdm/apps/ANDROIDSDK_LINUX_R17/platform-tools',
	require  => Exec['sdk link package'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'ln -s /data/rdm/apps/sdk/platform-tools/platform-tools_r17 /data/rdm/apps/ANDROIDSDK_LINUX_R17/platform-tools';
  }
  
  exec { 'ANDROIDSDK_LINUX_R17 tools link':
    cwd      => '/data/rdm/apps',
	creates  => '/data/rdm/apps/ANDROIDSDK_LINUX_R17/tools',
	require  => Exec['sdk link package'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'ln -s /data/rdm/apps/sdk/tools/tools_r21.1 /data/rdm/apps/ANDROIDSDK_LINUX_R17/tools';
  }
  
  file { 'ANDROIDSDK_LINUX_R17 build_tools':
    name    => '/data/rdm/apps/ANDROIDSDK_LINUX_R17/build-tools/',
    ensure  => directory,
	require => Exec['sdk link package'],
    owner   => rdm,
    group   => rdm;
  }
  
  exec { 'ANDROIDSDK_LINUX_R17 build_tools link':
    cwd      => '/data/rdm/apps',
	creates  => '/data/rdm/apps/ANDROIDSDK_LINUX_R17/build-tools/android-4.2.2',
	require  => File['ANDROIDSDK_LINUX_R17 build_tools'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'ln -s /data/rdm/apps/sdk/build-tools/android-4.2.2 /data/rdm/apps/ANDROIDSDK_LINUX_R17/build-tools/android-4.2.2';
  }
  
  exec { 'ANDROIDSDK_LINUX_R17 build_tools cp':
    cwd      => '/data/rdm/apps',
	creates  => '/data/rdm/apps/ANDROIDSDK_LINUX_R17/build-tools/renderscript',
	require  => File['ANDROIDSDK_LINUX_R17 build_tools'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'cp -r /data/rdm/apps/sdk/build-tools/android-4.2.2/* /data/rdm/apps/ANDROIDSDK_LINUX_R17/build-tools/; chown rdm:rdm /data/rdm/apps/ANDROIDSDK_LINUX_R19/build-tools/ -R';
  }

  exec { 'ANDROIDSDK_LINUX_R16 platforms link':
    cwd      => '/data/rdm/apps',
	creates  => '/data/rdm/apps/ANDROIDSDK_LINUX_R16/platforms',
	require  => Exec['sdk link package'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'ln -s /data/rdm/apps/sdk/platforms /data/rdm/apps/ANDROIDSDK_LINUX_R16/platforms';
  }
  
  exec { 'ANDROIDSDK_LINUX_R16 platform_tools':
    cwd      => '/data/rdm/apps',
	creates  => '/data/rdm/apps/ANDROIDSDK_LINUX_R16/platform-tools',
	require  => Exec['sdk link package'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'ln -s /data/rdm/apps/sdk/platform-tools/platform-tools_r16 /data/rdm/apps/ANDROIDSDK_LINUX_R16/platform-tools';
  }
  
  exec { 'ANDROIDSDK_LINUX_R16 tools link':
    cwd      => '/data/rdm/apps',
	creates  => '/data/rdm/apps/ANDROIDSDK_LINUX_R16/tools',
	require  => Exec['sdk link package'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'ln -s /data/rdm/apps/sdk/tools/tools_r20.0.3 /data/rdm/apps/ANDROIDSDK_LINUX_R16/tools';
  }
  
  exec { 'ANDROIDSDK_LINUX_R15 platforms link':
    cwd      => '/data/rdm/apps',
	creates  => '/data/rdm/apps/ANDROIDSDK_LINUX_R15/platforms',
	require  => Exec['sdk link package'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'ln -s /data/rdm/apps/sdk/platforms /data/rdm/apps/ANDROIDSDK_LINUX_R15/platforms';
  }
  
  exec { 'ANDROIDSDK_LINUX_R15 platform_tools link':
    cwd      => '/data/rdm/apps',
	creates  => '/data/rdm/apps/ANDROIDSDK_LINUX_R15/platform-tools',
	require  => Exec['sdk link package'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'ln -s /data/rdm/apps/sdk/platform-tools/platform-tools_r14 /data/rdm/apps/ANDROIDSDK_LINUX_R15/platform-tools';
  }
  
  exec { 'ANDROIDSDK_LINUX_R15 tools link':
    cwd      => '/data/rdm/apps',
	creates  => '/data/rdm/apps/ANDROIDSDK_LINUX_R15/tools',
	require  => Exec['sdk link package'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'ln -s /data/rdm/apps/sdk/tools/tools_r17 /data/rdm/apps/ANDROIDSDK_LINUX_R15/tools';
  }
  
  exec { 'ANDROIDSDK_LINUX_R14 platforms link':
    cwd      => '/data/rdm/apps',
	creates  => '/data/rdm/apps/ANDROIDSDK_LINUX_R14/platforms',
	require  => Exec['sdk link package'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'ln -s /data/rdm/apps/sdk/platforms /data/rdm/apps/ANDROIDSDK_LINUX_R14/platforms';
  }
  
  exec { 'ANDROIDSDK_LINUX_R14 platform_tools link':
    cwd      => '/data/rdm/apps',
	creates  => '/data/rdm/apps/ANDROIDSDK_LINUX_R14/platform-tools',
	require  => Exec['sdk link package'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'ln -s /data/rdm/apps/sdk/platform-tools/platform-tools_r14 /data/rdm/apps/ANDROIDSDK_LINUX_R14/platform-tools';
  }
  
  exec { 'ANDROIDSDK_LINUX_R14 tools link':
    cwd      => '/data/rdm/apps',
	creates  => '/data/rdm/apps/ANDROIDSDK_LINUX_R14/tools',
	require  => Exec['sdk link package'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'ln -s /data/rdm/apps/sdk/tools/tools_r14 /data/rdm/apps/ANDROIDSDK_LINUX_R14/tools';
  }
  
  exec { 'ANDROIDSDK_LINUX_R13 platforms link':
    cwd      => '/data/rdm/apps',
	creates  => '/data/rdm/apps/ANDROIDSDK_LINUX_R13/platforms',
	require  => Exec['sdk link package'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'ln -s /data/rdm/apps/sdk/platforms /data/rdm/apps/ANDROIDSDK_LINUX_R13/platforms';
  }
  
  exec { 'ANDROIDSDK_LINUX_R13 platform_tools link':
    cwd      => '/data/rdm/apps',
	creates  => '/data/rdm/apps/ANDROIDSDK_LINUX_R13/platform-tools',
	require  => Exec['sdk link package'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'ln -s /data/rdm/apps/sdk/platform-tools/platform-tools_r13 /data/rdm/apps/ANDROIDSDK_LINUX_R13/platform-tools';
  }
  
  exec { 'ANDROIDSDK_LINUX_R13 tools link':
    cwd      => '/data/rdm/apps',
	creates  => '/data/rdm/apps/ANDROIDSDK_LINUX_R13/tools',
	require  => Exec['sdk link package'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'ln -s /data/rdm/apps/sdk/tools/tools_r12 /data/rdm/apps/ANDROIDSDK_LINUX_R13/tools';
  }
  
  exec { 'ANDROIDSDK_LINUX_R12 platforms link':
    cwd      => '/data/rdm/apps',
	creates  => '/data/rdm/apps/ANDROIDSDK_LINUX_R12/platforms',
	require  => Exec['sdk link package'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'ln -s /data/rdm/apps/sdk/platforms /data/rdm/apps/ANDROIDSDK_LINUX_R12/platforms';
  }
  
  exec { 'ANDROIDSDK_LINUX_R12 platform_tools link':
    cwd      => '/data/rdm/apps',
	creates  => '/data/rdm/apps/ANDROIDSDK_LINUX_R12/platform-tools',
	require  => Exec['sdk link package'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'ln -s /data/rdm/apps/sdk/platform-tools/platform-tools_r12 /data/rdm/apps/ANDROIDSDK_LINUX_R12/platform-tools';
  }
  
  exec { 'ANDROIDSDK_LINUX_R12 tools link':
    cwd      => '/data/rdm/apps',
	creates  => '/data/rdm/apps/ANDROIDSDK_LINUX_R12/tools',
	require  => Exec['sdk link package'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'ln -s /data/rdm/apps/sdk/tools/tools_r12 /data/rdm/apps/ANDROIDSDK_LINUX_R12/tools';
  }
  
  exec { 'ANDROIDSDK_LINUX_R11 platforms link':
    cwd      => '/data/rdm/apps',
	creates  => '/data/rdm/apps/ANDROIDSDK_LINUX_R11/platforms',
	require  => Exec['sdk link package'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'ln -s /data/rdm/apps/sdk/platforms /data/rdm/apps/ANDROIDSDK_LINUX_R11/platforms';
  }
  
  exec { 'ANDROIDSDK_LINUX_R11 platform_tools link':
    cwd      => '/data/rdm/apps',
	creates  => '/data/rdm/apps/ANDROIDSDK_LINUX_R11/platform-tools',
	require  => Exec['sdk link package'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'ln -s /data/rdm/apps/sdk/platform-tools/platform-tools_r11 /data/rdm/apps/ANDROIDSDK_LINUX_R11/platform-tools';
  }
  
  exec { 'ANDROIDSDK_LINUX_R11 tools link':
    cwd      => '/data/rdm/apps',
	creates  => '/data/rdm/apps/ANDROIDSDK_LINUX_R11/tools',
	require  => Exec['sdk link package'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'ln -s /data/rdm/apps/sdk/tools/tools_r12 /data/rdm/apps/ANDROIDSDK_LINUX_R11/tools';
  }
  
  exec { 'ANDROIDSDK_LINUX_R10 platforms link':
    cwd      => '/data/rdm/apps',
	creates  => '/data/rdm/apps/ANDROIDSDK_LINUX_R10/platforms',
	require  => Exec['sdk link package'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'ln -s /data/rdm/apps/sdk/platforms /data/rdm/apps/ANDROIDSDK_LINUX_R10/platforms';
  }
  
  exec { 'ANDROIDSDK_LINUX_R10 platform_tools link':
    cwd      => '/data/rdm/apps',
	creates  => '/data/rdm/apps/ANDROIDSDK_LINUX_R10/platform-tools',
	require  => Exec['sdk link package'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'ln -s /data/rdm/apps/sdk/platform-tools/platform-tools_r10 /data/rdm/apps/ANDROIDSDK_LINUX_R10/platform-tools';
  }
  
  exec { 'ANDROIDSDK_LINUX_R10 tools link':
    cwd      => '/data/rdm/apps',
	creates  => '/data/rdm/apps/ANDROIDSDK_LINUX_R10/tools',
	require  => Exec['sdk link package'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'ln -s /data/rdm/apps/sdk/tools/tools_r12 /data/rdm/apps/ANDROIDSDK_LINUX_R10/tools';
  }
  
  exec { 'ANDROIDSDK_LINUX_R9 platforms link':
    cwd      => '/data/rdm/apps',
	creates  => '/data/rdm/apps/ANDROIDSDK_LINUX_R9/platforms',
	require  => Exec['sdk link package'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'ln -s /data/rdm/apps/sdk/platforms /data/rdm/apps/ANDROIDSDK_LINUX_R9/platforms';
  }
  
  exec { 'ANDROIDSDK_LINUX_R9 platform_tools link':
    cwd      => '/data/rdm/apps',
	creates  => '/data/rdm/apps/ANDROIDSDK_LINUX_R9/platform-tools',
	require  => Exec['sdk link package'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'ln -s /data/rdm/apps/sdk/platform-tools/platform-tools_r09 /data/rdm/apps/ANDROIDSDK_LINUX_R9/platform-tools';
  }
  
  exec { 'ANDROIDSDK_LINUX_R9 tools link':
    cwd      => '/data/rdm/apps',
	creates  => '/data/rdm/apps/ANDROIDSDK_LINUX_R9/tools',
	require  => Exec['sdk link package'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'ln -s /data/rdm/apps/sdk/tools/tools_r12 /data/rdm/apps/ANDROIDSDK_LINUX_R9/tools';
  }
  
  
  #------------------------------install ndk------------------------------
  exec { 'ndk r8d package':
	cwd      => '/data/rdm/apps/ndk',
	creates  => '/data/rdm/apps/ndk/android-ndk-r8d.zip',
	require  => Exec['mkdir apps sub dir'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'wget "http://10.12.198.89:8080/glu/repository/tgzs/Android_NDK/android-ndk-r8d.zip";unzip android-ndk-r8d.zip;chown rdm:rdm android-ndk-r8d -R';
  }

  exec { 'ndk r8e package':
	cwd      => '/data/rdm/apps/ndk',
	creates  => '/data/rdm/apps/ndk/android-ndk-r8e.zip',
	require  => Exec['mkdir apps sub dir'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'wget "http://10.12.198.89:8080/glu/repository/tgzs/Android_NDK/android-ndk-r8e.zip";unzip android-ndk-r8e.zip;chown rdm:rdm android-ndk-r8e -R';
  }
  
  exec { 'ndk r9 package':
	cwd      => '/data/rdm/apps/ndk',
	creates  => '/data/rdm/apps/ndk/android-ndk-r9.zip',
	require  => Exec['mkdir apps sub dir'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'wget "http://10.12.198.89:8080/glu/repository/tgzs/Android_NDK/android-ndk-r9.zip";unzip android-ndk-r9.zip;chown rdm:rdm android-ndk-r9 -R';
  }
  
  exec { 'ndk r9c package':
	cwd      => '/data/rdm/apps/ndk',
	creates  => '/data/rdm/apps/ndk/android-ndk-r9c.zip',
	require  => Exec['mkdir apps sub dir'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'wget "http://10.12.198.89:8080/glu/repository/tgzs/Android_NDK/android-ndk-r9c.zip";unzip android-ndk-r9c.zip;chown rdm:rdm android-ndk-r9c -R';
  }
  
  exec { 'ndk link':
    cwd      => '/data/rdm/apps',
	creates  => '/data/rdm/apps/ANDROIDSDK_LINUX_R9/platforms',
	require  => Exec['sdk link package'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'ln -s /data/rdm/apps/ndk/android-ndk-r8d /data/rdm/apps/ANDROIDNDK_LINUX_R8D && ln -s /data/rdm/apps/ndk/android-ndk-r8e /data/rdm/apps/ANDROIDNDK_LINUX_R8E && ln -s /data/rdm/apps/ndk/android-ndk-r9c /data/rdm/apps/ANDROIDNDK_LINUX_R9C && ln -s /data/rdm/apps/ndk/android-ndk-r9 /data/rdm/apps/ANDROIDNDK_LINUX_R9 ';
  }
  
  file { '/data/rdm/apps/ANDROIDNDK_LINUX_R8D':
    ensure  => 'link',
	owner   => rdm,
    group   => rdm,
	target  => '/data/rdm/apps/ndk/android-ndk-r8d',
    require => Exec['ndk r8d package'];
  }
 
  file { '/data/rdm/apps/ANDROIDNDK_LINUX_R8E':
    ensure  => 'link',
	owner   => rdm,
    group   => rdm,
	target  => '/data/rdm/apps/ndk/android-ndk-r8e',
	require => Exec['ndk r8e package'];
  }
 
  file { '/data/rdm/apps/ANDROIDNDK_LINUX_R9C':
    ensure  => 'link',
	owner   => rdm,
    group   => rdm,
	target  => '/data/rdm/apps/ndk/android-ndk-r9c',
	require => Exec['ndk r9c package'];
  }
  
  file { '/data/rdm/apps/ANDROIDNDK_LINUX_R9':
    ensure  => 'link',
	owner   => rdm,
    group   => rdm,
	target  => '/data/rdm/apps/ndk/android-ndk-r9',
	require => Exec['ndk r9 package'];
  } 
  
  
  #------------------------------install svn------------------------------
  file { 'svn 1.7.9 package':
    name    => '/data/rdm/apps/svn/CollabNetSubversion-client-1.7.9-1.x86_64.rpm',
    ensure  => file,
	require => Exec['mkdir apps sub dir'],
    owner   => rdm,
    group   => rdm,
    source  => 'puppet:///modules/webbank_linux_android_slave/svn/CollabNetSubversion-client-1.7.9-1.x86_64.rpm';
  }

  exec { 'svn 1.7.9':
    cwd      => '/data/rdm/apps/svn/',
    creates  => '/opt/CollabNet_Subversion',
    require  => File['svn 1.7.9 package'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
    command  => 'rpm -iv /data/rdm/apps/svn/CollabNetSubversion-client-1.7.9-1.x86_64.rpm;/opt/CollabNet_Subversion/bin/';
  }
  
  file { '/usr/bin/svn':
    ensure  => 'link',
	target  => '/opt/CollabNet_Subversion/bin/svn',
	require => Exec['svn 1.7.9'];
  }
  
  exec { 'svn --version':
    creates  => '/home/rdm/.subversion/config',
    require  => File['/usr/bin/svn'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
    command  => 'svn --version --quiet';
  }
  
  file { 'svn config':
    name    => '/home/rdm/.subversion/config',
    ensure  => present,
	require => Exec['svn --version'],
    owner   => rdm,
    group   => rdm,
    source  => 'puppet:///modules/webbank_linux_android_slave/svn/svn_config';
  }

  
  #------------------------------sync jenkins ssl cert------------------------------
  file { 'ssh path':
    name    => '/home/rdm/.ssh',
    ensure  => directory,
	mode    => 700,
    owner   => rdm,
    group   => rdm,
  }
  
  file { 'ssl file':
    name    => '/home/rdm/.ssh/authorized_keys',
    ensure  => file,
	require => File['ssh path'],
    owner   => rdm,
    group   => rdm,
	mode    => 600,
    source  => 'puppet:///modules/webbank_linux_android_slave/ssl_cert/RDM_jenkins_ssl_cert.pub';
  }
    
	
  #------------------------------sync workflow script------------------------------
  file { 'workflow script':
    name    => '/data/rdm/workflow',
    ensure  => directory,
    owner   => rdm,
    group   => rdm,
	require => Exec['apps path'],
	ignore  => '.svn',
	recurse => true,
    source  => 'puppet:///modules/webbank_linux_android_slave/workflow';
  }
  
  
  #------------------------------sync build env checking script------------------------------
  file { 'CI_build_env_autoTest':
    name    => '/data/rdm/apps/CI_build_env_autoTest.sh',
    ensure  => file,
	require => Exec['apps path'],
    owner   => mqq,
    group   => mqq,
    mode    => 755,
    source  => 'puppet:///modules/webbank_linux_android_slave/common/CI_build_env_autoTest.sh';
  }
  
  file { 'CI_build_env_strategy_check':
    name    => '/data/rdm/apps/CI_build_env_strategy_check.sh',
    ensure  => file,
	require => Exec['apps path'],
    owner   => mqq,
    group   => mqq,
    mode    => 755,
    source  => 'puppet:///modules/webbank_linux_android_slave/common/CI_build_env_strategy_check.sh';
  }
  
  file { 'CI_build_env_autoTestFunction':
    name    => '/data/rdm/apps/CI_build_env_autoTestFunction.sh',
    ensure  => file,
	require => Exec['apps path'],
    owner   => mqq,
    group   => mqq,
    mode    => 755,
    source  => 'puppet:///modules/webbank_linux_android_slave/common/CI_build_env_autoTestFunction.sh';
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
  
  
  #------------------------------install cov-analysis------------------------------
  exec { 'cov-analysis package':
	cwd      => '/data/',
	creates  => '/data/rdm/apps/cov-analysis/cov-analysis-linux64-7.0.3.gz',
	require  => Exec['mkdir apps sub dir'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
	command  => 'mkdir -p /data/rdm/apps/cov-analysis; chown rdm:rdm /data/rdm -R;cd /data/rdm/apps/cov-analysis;wget "http://10.12.198.89:8080/glu/repository/tgzs/cov-analysis-linux64-7.0.3.gz";tar xzfv cov-analysis-linux64-7.0.3.gz;chown rdm:rdm cov-analysis-linux64-7.0.3 -R';
  }

  #------------------------------install gulp-------------------------------------

  package {
    'npm':
      ensure => present
  }

  exec { 'gulp':
    require => package['npm'],
      path     => ['/usr/bin','/usr/sbin','/bin'],
    command => 'npm install --global gulp; npm run gulp'
  }


  #------------------------------install gradle------------------------------
  file { 'gradle2.0 package':
    name    => '/data/rdm/apps/gradle/gradle-2.0-all.zip',
    ensure  => present,
  require => Exec['mkdir apps sub dir'],
    owner   => rdm,
    group   => rdm,
    source  => 'puppet:///modules/webbank_linux_android_slave/gradle/gradle-2.0-all.zip';
  }

  exec { 'gradle':
    cwd      => '/data/rdm/apps/gradle',
  require  => File['gradle2.0 package'],
    path     => ['/usr/bin','/usr/sbin','/bin'],
  command  => 'unzip gradle-2.0-all.zip';
  }
  
  file { '/usr/local/bin/gradle':
    ensure  => 'link',
  target  => '/data/rdm/apps/gradle/gradle-2.0/bin/gradle',
  require => Exec['gradle'];
  }
}
