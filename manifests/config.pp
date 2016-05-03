class ssh::config inherits ssh {
  # Generate RSA keys reliably
  $rsa_priv = ssh_keygen({name => "ssh_host_rsa_${::fqdn}", dir => 'ssh/hostkeys'})
  $rsa_pub  = ssh_keygen({name => "ssh_host_rsa_${::fqdn}", dir => 'ssh/hostkeys', public => 'true'})

  file { '/etc/ssh/ssh_host_rsa_key':
    owner   => 'root',
    group   => '$groupowner',
    mode    => 0600,
    content => $rsa_priv,
    notify => ssh::service[service['sshd']],

  }

  file { '/etc/ssh/ssh_host_rsa_key.pub':
    owner   => 'root',
    group   => '$groupowner',
    mode    => 0644,
    content => $rsa_pub,
    notify => ssh::service[service['sshd']],

  }

  file { '/etc/ssh/sshd_config':
    owner   => 'root',
    group   => 'groupowner',
    mode    => '0644',
    content => template('$config')
    notify => ssh::service[service['sshd']],

  }


}