require boxen::environment
require homebrew
require gcc

Exec {
  group       => 'staff',
  logoutput   => on_failure,
  user        => $boxen_user,

  path => [
    "${boxen::config::home}/rbenv/shims",
    "${boxen::config::home}/rbenv/bin",
    "${boxen::config::home}/rbenv/plugins/ruby-build/bin",
    "${boxen::config::homebrewdir}/bin",
    '/usr/bin',
    '/bin',
    '/usr/sbin',
    '/sbin'
  ],

  environment => [
    "HOMEBREW_CACHE=${homebrew::config::cachedir}",
    "HOME=/Users/${::boxen_user}"
  ]
}

File {
  group => 'staff',
  owner => $boxen_user
}

Package {
  provider => homebrew,
  require  => Class['homebrew']
}

Repository {
  provider => git,
  extra    => [
    '--recurse-submodules'
  ],
  require  => File["${boxen::config::bindir}/boxen-git-credential"],
  config   => {
    'credential.helper' => "${boxen::config::bindir}/boxen-git-credential"
  }
}

Service {
  provider => ghlaunchd
}

Homebrew::Formula <| |> -> Package <| |>

node default {
  # core modules, needed for most things
  include dnsmasq
  include git
  include hub
  include karabiner
  include karabiner::login_item
  include java
  include iterm2::stable
  include iterm2::colors::zenburn
  include gpgtools
  include vagrant
  include onepassword
  include skype
  include evernote
  include dropbox
  include firefox
  include chrome
  include calibre
  include hipchat
  include git
  include go
  include homebrew
  include brewcask
  include gcc
  include openssl
  include osx::global::enable_standard_function_keys
  include osx::dock::autohide 
  include osx::finder::show_hidden_files
  include osx::finder::unhide_library 
  include osx::finder::show_all_filename_extensions
  include osx::no_network_dsstores 
  include osx::software_update
  include osx::keyboard::capslock_to_control

  # fail if FDE is not enabled
  if $::root_encrypted == 'no' {
    fail('Please enable full disk encryption and try again')
  }

  # node versions
  nodejs::version { 'v0.6': }
  nodejs::version { 'v0.8': }
  nodejs::version { 'v0.10': }

  # default ruby versions
  ruby::version { '1.9.3': }
  ruby::version { '2.0.0': }
  ruby::version { '2.1.0': }
  ruby::version { '2.1.1': }
  ruby::version { '2.1.2': }

  # common, useful packages
  package {
    [
      'ack',
      'findutils',
      'gnu-tar'
    ]:
  }

  file { "${boxen::config::srcdir}/our-boxen":
    ensure => link,
    target => $boxen::config::repodir
  }

  karabiner::remap{ 'controlL2controlL_escape': }
  karabiner::set{ 'parameter.keyrepeat_delayuntilrepeat':
      value => '200'
  }
  karabiner::set{ 'parameter.keyrepeat_keyrepeat':
      value => '33'
  }
}
