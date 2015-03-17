class people::mavant {
  include karabiner
  include karabiner::login_item
  include java
  include iterm2::stable
  include vagrant
  include onepassword
  include skype
  include evernote
  include dropbox
  include firefox
  include chrome
  include hipchat
  include brewcask
  include osx::global::enable_standard_function_keys
  include osx::dock::autohide
  include osx::finder::show_hidden_files
  include osx::finder::unhide_library
  include osx::finder::show_all_filename_extensions
  include osx::no_network_dsstores
  include osx::software_update
  include osx::keyboard::capslock_to_control
  include zsh

  $home     = "/Users/${::boxen_user}"
  $srcdir   = "/Volumes/git"
  $src      = "/src"
  
  file { $srcdir:
    ensure  => directory
  }

  file { $src:
      ensure => link,
      target => $srcdir
  }

  # Because some asshole decided the git module should manage my gitignore for me.
  Git::Config::Global <| title == 'core.excludesfile' |> {
      value => "${home}/.gitignore_global"
  }

  karabiner::remap{ 'controlL2controlL_escape': }
  karabiner::set{ 'repeat.initial_wait':
      value => '200'
  }
  karabiner::set{ 'repeat.wait':
      value => '33'
  }

  package { 'vim':
    ensure => present,
    install_options => [
      '--with-lua',
      '--with-luajit',
      '--override-system-vim'
    ]
  }
}
