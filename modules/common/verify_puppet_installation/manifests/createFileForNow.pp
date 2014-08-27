class createFileForNow {
  Exec {
    path => ['/usr/bin','/usr/sbin','/bin', '/usr/local/bin', '/usr/local/share/bin']
  }

  exec { 'create file':
    cwd    => '/tmp',
    command  => "date > now.txt";
  }
}