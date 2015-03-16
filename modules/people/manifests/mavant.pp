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
  # include homebrew
    include brewcask
    include openssl
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
  $my       = "${home}/my"
  $dotfiles = "${my}/dotfiles"
  
  file { $my:
    ensure  => directory
  }

  repository { $dotfiles:
    source  => 'mavant/dotfiles',
    require => File[$my]
  }
  karabiner::remap{ 'controlL2controlL_escape': }
  karabiner::set{ 'repeat.initial_wait':
      value => '200'
  }
  karabiner::set{ 'repeat.wait':
      value => '33'
  }
}
