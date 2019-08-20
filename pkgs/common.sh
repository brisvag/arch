# common variables
url='https://github.com/brisvag/arch'
arch=('any')

# autogenerated variables
pkgname="brisvag-${name}"
# backslash (and later eval) are necessary because pkgdir is not defined until later
home="\${pkgdir}${HOME}"
rootdir=${PWD}

# version is rX.Y: X=number of revisions, Y=last commit hash
# important: need to keep this file into account!
version() {
  printf "r%s.%s" \
         "$(git shortlog -s ${rootdir} "${rootdir}/../common.sh" | awk '{n += $1}; END{print n}')" \
         "$(git log -n 1 --pretty=format:%h -- ${rootdir} "${rootdir}/../common.sh")"
}
pkgver=$(version)
pkgrel=1

# use X.txt and X.install (if they exist) for deps an hooks
if [[ -f "${name}.txt" ]]; then
  # grep to ignore comments
  depends=($(grep -v "^#" "${name}.txt"))
fi

if [[ -f "${name}.install" ]]; then
  install="${name}.install"
fi

package() {
  # package dotfiles
  if [[ -d "${rootdir}"/dotfiles ]]; then
    local home=$(eval echo "${home}")
    mkdir -p "${home}"
    cp -a "${rootdir}"/dotfiles "${home}"
  fi
  return 0
}
