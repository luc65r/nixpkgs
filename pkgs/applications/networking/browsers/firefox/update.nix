{ writeScript
, lib
, xidel
, common-updater-scripts
, coreutils
, gnused
, gnugrep
, curl
, gnupg
, attrPath
, runtimeShell
, baseUrl ? "http://archive.mozilla.org/pub/firefox/releases/"
, versionSuffix ? ""
, versionKey ? "version"
}:

writeScript "update-${attrPath}" ''
  #!${runtimeShell}
  PATH=${lib.makeBinPath [ common-updater-scripts coreutils curl gnugrep gnupg gnused xidel ]}

  set -eux
  HOME=`mktemp -d`
  export GNUPGHOME=`mktemp -d`
  gpg --import ${../firefox-bin/mozilla.asc}

  url=${baseUrl}

  # retriving latest released version
  #  - extracts all links from the $url
  #  - extracts lines only with number and dots followed by a slash
  #  - removes trailing slash
  #  - sorts everything with semver in mind
  #  - picks up latest release
  version=`xidel -s $url --extract "//a" | \
           grep "^[0-9.]*${versionSuffix}/$" | \
           sed s/[/]$// | \
           sort --version-sort | \
           tail -n 1`

  curl --silent --show-error -o "$HOME"/shasums "$url$version/SHA512SUMS"
  curl --silent --show-error -o "$HOME"/shasums.asc "$url$version/SHA512SUMS.asc"
  gpgv --keyring="$GNUPGHOME"/pubring.kbx "$HOME"/shasums.asc "$HOME"/shasums

  hash=$(grep '\.source\.tar\.xz$' "$HOME"/shasums | grep '^[^ ]*' -o)

  update-source-version ${attrPath} "$version" "$hash" "" --version-key=${versionKey}
''
