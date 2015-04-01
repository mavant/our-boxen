class people::mavant {
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
  include zsh

  # Set various OSX options
  include osx::global::enable_standard_function_keys
  include osx::dock::autohide
  include osx::finder::show_hidden_files
  include osx::finder::unhide_library
  include osx::finder::show_all_filename_extensions
  include osx::no_network_dsstores
  include osx::software_update
  include osx::keyboard::capslock_to_control

  # The git module attempts to set its own gitignore unless overwritten
  Git::Config::Global <| title == 'core.excludesfile' |> {
      value => "${home}/.gitignore_global"
  }

  # Karabiner config
  include karabiner
  include karabiner::login_item
  karabiner::remap { 'controlL2controlL_escape': }
  karabiner::set { 'repeat.initial_wait':
      value => '200'
  }
  karabiner::set { 'repeat.wait':
      value => '33'
  }

  # Homebrew packages
  package {
      [
          'cabal-install',
          'gh',
          'ghc',
          'fzf',
          'lua',
          'luajit',
          'luarocks',
          'pcre',
          'task',
          'the_platinum_searcher',
          'the_silver_searcher',
          'tor',
          'vifm'
      ]:
  }

  package { 'vim':
    ensure => present,
    install_options => [
      '--with-lua',
      '--with-luajit',
      '--override-system-vim'
    ]
  }

  # IntelliJ
  class { 'intellij':
      edition => 'ultimate'
  }

  # rcm (but maybe I should do this with puppet instead?)
  homebrew::tap { 'thoughtbot/formulae': } ->
  package { 'rcm': }

  # gnu grep is crucial
  homebrew::tap { 'homebrew/dupes': } ->
  package { 'homebrew/dupes/grep':
    ensure => present,
    install_options => [
      '--with-default-names'
    ]
  }
}
