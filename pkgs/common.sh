# common variables
url='https://github.com/brisvag/arch'
arch=('any')
groups=('brisvag-all')

# autogenerated variables
pkgname="brisvag-${_name}"
# backslash (and later eval) are necessary because pkgdir is not defined until later
_home="\${pkgdir}${HOME}"
_rootdir=${PWD}

# version is rX.Y: X=number of revisions, Y=last commit hash
# important: need to keep also this file into account for revision number!
# however, only count commits of this file AFTER the package was first created
version() {
  this="${_rootdir}/../common.sh"
  _startdate=$(git log --follow --date=local --pretty=format:%ad --diff-filter=A "${_rootdir}" | tail -n 1)
  _ncommits=$(git shortlog -s --date=local --since="${_startdate}" "${_rootdir}" "${this}" | awk '{n += $1}; END{print n}')
  _lasthash=$(git log -n 1 --pretty=format:%h -- "${_rootdir}" "${this}")
  printf "r%s.%s" "${_ncommits}" "${_lasthash}"
}
# must call version() function despite it being called by default because of $rootdir causing issues
pkgver=$(version)
pkgrel=1

# use X.txt and X.install (if they exist) for deps an hooks
if [[ -f "${_name}.txt" ]]; then
  # grep to ignore comments
  depends=($(grep -v "^#" "${_name}.txt"))
fi

if [[ -f "${_name}.install" ]]; then
  install="${_name}.install"
fi

package() {
  # package dotfiles
  _dotfiles="${_rootdir}/dotfiles"
  if [[ -d "${_dotfiles}" ]]; then
    local _home=$(eval echo "${_home}")
    mkdir -p "${_home}"
    cp -a "${_dotfiles}" "${_home}"
  fi

  # package root files
  _root="${_rootdir}/root"
  if [[ -d "${_root}" ]]; then
    _tree=$(find "${_root}" -mindepth 1 -type d | xargs -r -n 1 realpath --relative-to="${_root}")
    for dir in ${_tree}; do
      mkdir -p "${pkgdir}/${dir}"
    done
    cp -a "${_root}/"* "${pkgdir}/"
  fi
  return 0
}
