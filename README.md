# arch-installer
This is my arch linux installer script. There are many like it, but this one is mine. My arch linux installer script is my best friend. It is my life. I must master it as I must master my life. My arch linux installer script, without me, is useless. Without my arch linux installer script, I am useless.

## Instructions
This is currently designed to work on my unraid server in a VM. I will expand it to support more systems as I have the need.

Copy `config.sh.example` to `config.sh` and edit the values otherwise you will get useless defaults.

Run `./install.sh`

This installs
 - `base`
 - `base-devel`
 - `grub`
 - `efibootmgr`
 - `network manager`
 - `sudo`
 - My dotfiles https://github.com/empeee/dotfiles
 - Other useful tools: `vim`, `tmux`, `git`, `ranger`, `htop` and `iftop`

This is what I consider a bare-bones but useful system.

Additional you can run
 - `./gui_install.sh` to get
   - `xorg-server`, `xorg-apps`, and `xorg-xinit`
   - `st`, `dwm`, and `dmenu` all from https://suckless.org source
 - `./yay-install.sh` to get
   - YAY
 - `./extras-install.sh` to get
   - `chromium`
   - `ttf-liberation`
   - `octave`
   
For a slightly more useful, but 'more stuff' system.
