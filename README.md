# arch
Metapackage repository for my arch-linux configuration

**IMPORTANT**: any package containing dotfiles should be installed (or re-installed) as the desired user with `sudo`,
otherwise the files won't be copied over to the user's directory.

# Usage

Add the following to `/etc/pacman.conf`:

```
[brisvag]
SigLevel = Optional TrustAll
Server = https://raw.githubusercontent.com/brisvag/arch/master/repo
```
TODO: This passage will be inserted in the installer asap!

# Installer

Note for the future: `brisvag-core` and `brisvag-base` should be installed with chroot. After that, everything should be installed
as user from within the system.

**NOTE: INSTALLER DOES NOT WORK YET!**

Run: 
`curl -sL https://git.io/brisvag-arch | bash`
... and profit!
