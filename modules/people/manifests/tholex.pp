class people::tholex {
  notify { 'class people::tholex declared': }

  # For Justice!
  include homebrew

  # Dev Jank
  include vagrant
  include virtualbox

  # Apps
  include firefox::aurora

  include chrome::stable
  include chrome::canary

  # include onepassword
  include dropbox
  include alfred
  include flux
  include divvy
  include macvim
  include zsh
  include iterm2::dev
  include iterm2::colors::solarized_dark
  include skype
  include caffeine
  include spotify
  include vlc
  include pow
  include nvalt::stable
  include daisy_disk
  include utorrent

  # Boxen postgres is on port 15432
  include postgresql

  # Boxen redis provides:
  #   BOXEN_REDIS_PORT: the configured redis port
  #   BOXEN_REDIS_URL: the URL for redis, including localhost & port
  include redis

  # Boxen mongodb provides:
  #   BOXEN_MONGODB_PORT: the configured mongodb port
  #   BOXEN_MONGODB_URL: the URL for mongodb, including localhost & port
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
      pgen      => '/Users/olex/.janus',
      dotfiles  => '/Users/olex/Dropbox/dotfiles'
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
    user => $::luser
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

  ### Link the dotfiles
  # ~> people::tholex::dotfile::link { $env['dotfiles']:
  #   source_dir => $env['directories']['dotfiles'],
  #   dest_dir   => $env['directories']['home'],
  # }

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

  # Install vim plugins into pathogen dir
  repository { 'vim-rails':
    source => 'tpope/vim-rails',
    path   => "${env['directories']['pgen']}"
  }
  repository { 'emmet-vim':
    source => 'mattn/emmet-vim',
    path   => "${env['directories']['pgen']}"
  }
  repository { 'nerdcommenter':
    source => 'scrooloose/nerdcommenter',
    path   => "${env['directories']['pgen']}"
  }
  repository { 'portkey':
    source => 'dsawardekar/portkey',
    path   => "${env['directories']['pgen']}"
  }
  repository { 'vim-bundler':
    source => 'tpope/vim-bundler',
    path   => "${env['directories']['pgen']}"
  }
  repository { 'vim-handlebars':
    source => 'nono/vim-handlebars',
    path   => "${env['directories']['pgen']}"
  }


  # Misc Helpers || https://gist.github.com/jfryman/4963514
  #   define dotfile::link($source_dir, $dest_dir) {
  #     file { "${dest_dir}/.${name}":
  #       ensure => symlink,
  #       target => "${source_dir}/${name}",
  #     }
  #   }
}
