post_install() {
  (
  echo "${rootdir}"/dotfiles
  files=($(find ${pkgdir} -type f))
  echo ${files}
  (
  cd ${HOME}
  for file in ${files}; do
    echo ${file}
  done
  )
  )
}
