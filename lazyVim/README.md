# 💤 LazyVim

A starter template for [LazyVim](https://github.com/LazyVim/LazyVim).
Refer to the [documentation](https://lazyvim.github.io/installation) to get started.

--- LazyVim system wide install:
1. Add the following to /etc/profile
export PATH=$PATH:/opt/nvim/bin
export XDG_CONFIG_HOME=/etc/xdg
export XDG_DATA_HOME=/usr/local/share
#export XDG_RUNTIME_DIR=
#export XDG_STATE_HOME=
#export XDG_CACHE_HOME=
export XDG_CONFIG_DIRS=/etc/xdg
export XDG_DATA_DIRS=/usr/local/share
export EDITOR='vi'
export VISUAL='vi'

2. Copy the lua directory to $XDG_CONFIG_HOME/nvim/
