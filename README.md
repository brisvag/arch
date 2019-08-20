# arch
Metapackage repository for my arch-linux configuration

# Usage

Add the following to `/etc/pacman.conf`

```
[brisvag]
SigLevel = Optional TrustAll
Server = https://raw.githubusercontent.com/brisvag/arch/master/repo
```

Also need post-transaction hook for dotfiles update in `/etc/pacman.d/hooks/`

# Installer

Run: 
`curl -sL https://git.io/brisvag-arch | bash`
... and profit!
