# arch
Metapackage repository for my arch-linux configuration

**WARNING**: hardcoded paths are needed here and there (mainly to `/home/brisvag`/).
Remember to change them if the user is different!

This is partially fixed. It's important to run stuff as the user with `sudo`, otherwise it won't work.

For now, `brisvag-core` should be installed with chroot. After that, everything should be installed
as user from within the system.

# Usage

Add the following to `/etc/pacman.conf`:

```
[brisvag]
SigLevel = Optional TrustAll
Server = https://raw.githubusercontent.com/brisvag/arch/master/repo
```
TODO: This passage will be inserted in the installer asap!

# Installer

Run: 
`curl -sL https://git.io/brisvag-arch | bash`
... and profit!
