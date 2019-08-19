backup_files() {
  files=($(find ${pkgdir} -type f))
  (
  cd ${HOME}
  for file in ${files}; do
    if [[ -f ${file} ]]; then
      mv ${file} ${file}.pacbak
    fi
  done
  )
}
