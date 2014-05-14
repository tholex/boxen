class people::tholex {
  notify { 'class people::tholex declared': }

  # Apps
  include chrome::stable
  include chrome::canary

  # include onepassword
  include dropbox
  include alfred
  include flux
  include divvy
  include macvim
  include zsh
  include homebrew
  include iterm2::dev
  include iterm2::colors::solarized_dark
  include skype
  include caffeine
  include spotify
  include vlc
  include virtualbox
  include pow
  include nvalt::stable
  include daisy_disk
  include utorrent

  include postgresql
  include redis
  include mongodb

  # Projects
  # You can add projects manifests, and call them
  # e.g. include project::some_app
  # e.g. include project::initd
  # e.g. include project::ci


  # Personal Configuration
  $env = {
    directories => {
      home      => '/Users/olex',
      dotfiles  => '/Users/olex/.dotfiles'
    },
    dotfiles => [
      'vimrc.after',
      'zshrc'
    ],
    packages => {
      brew   => [
        'wget',
        'the_silver_searcher',
        'imagemagick',
        'tmux'
      ]
    }
  }

  # Install Brew Applications
  package { $env['packages']['brew']:
    provider => 'homebrew',
  }


  Boxen::Osx_defaults {
    user => $::luser,
  }

  # OSX Settings
  # =====

  include osx::global::expand_save_dialog
  include osx::global::expand_print_dialog
  include osx::global::enable_keyboard_control_access
  include osx::dock::2d
  include osx::dock::autohide
  include osx::dock::dim_hidden_apps
  class { 'osx::dock::position':
    position => 'left'
  }
  include osx::dock::pin_position

  # Finder
  include osx::finder::empty_trash_securely
  include osx::finder::unhide_library

  # Keyboard
  include osx::keyboard::capslock_to_control
  # Default : key repeat = 0ms, aka no repeat
  include osx::global::key_repeat_rate

  # Trackpad
  # Default : zooms cursor by 1.5
  include osx::universal_access::cursor_size

  # Install Janus
  repository { 'janus':
    source => 'carlhuda/janus',
    path   => "${env['directories']['home']}/.vim",
  }
  ~> exec { 'Boostrap Janus':
    command     => 'rake',
    cwd         => "${env['directories']['home']}/.vim",
    refreshonly => true,
    environment => [
      "HOME=${env['directories']['home']}",
    ],
  }
}
