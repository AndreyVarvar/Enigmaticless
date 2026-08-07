#!/bin/zsh
# this file will compile all the assets into a neat zip-package under build/ folder to be distributed

if [[ $1 == "--help" || $1 == "-h" ]]; then
  echo "NAME"
  echo "  build - compile all the assets in this directory into a single zip-file texture-pack"
  echo ""
  echo "SYNPOPSIS"
  echo "  build [-hvb] [...]"
  echo ""
  echo "DESCRIPTION"
  echo "The build utility parses files in the location of invocation. If no option was passed, the script will compile all the assets and bump the version that can be specified as na argument similar to the ones for -b"
  echo "  -h, --help                      shows this help menu"
  echo "  -v, --version                   shows current version"
  echo "  -b, --bump [major|minor|patch]  compiles and bumps version to a next one based on the argument. Defaults to a patch"
  echo ""
  echo "EXIT STATUS"
  echo "The build utility exits 0 on success, and 1 if an error occurs."
  echo ""
  echo "EXAMPLES"
  echo "  The command:"
  echo "    ./build.sh"
  echo "  will compile all the assets"
  echo "  The command:"
  echo "    ./build.sh -b minor"
  echo "  will compile all the assets and bump the minor version"
  echo "  The command:"
  echo "    ./build.sh -b"
  echo "  will compile all the assets and bump the patch version"

  exit 0
fi

VERSION=$(cat pack-version.txt)

if [[ $1 == "-v" || $1 == "--version" ]]; then
  echo "Current version: $VERSION"
  exit 0
fi

if [[ $1 == "-b" || $1 == "--bump" ]]; then
  BUMPTYPE="${2:-patch}"

  OLDVERSIONSUFFIX="${VERSION##*-}"

  local -a V
  V=(${(s:.:)OLDVERSIONSUFFIX})

  case "$BUMPTYPE" in
  major)
    ((V[1]++))
    V[2]=0
    V[3]=0
    ;;
  minor)
    ((V[2]++))
    V[3]=0
    ;;
  patch)
    ((V[3]++))
    ;;
  *)
    echo "Invalid argument: $BUMPTYPE" >&2
    exit 1
    ;;
  esac

  VERSIONPREFIX="${VERSION%-*}"
  NEWVERSIONSUFFIX="${(j:.:)V}"

  echo "Updated from $OLDVERSIONSUFFIX to $NEWVERSIONSUFFIX"
  echo "$VERSIONPREFIX-$NEWVERSIONSUFFIX" >pack-version.txt
  VERSION="$VERSIONPREFIX-$NEWVERSIONSUFFIX"
fi

# clear the build directory first
rm -rf ./build/*.zip
# the compilation part
NAME="Enigmaticless-$VERSION.zip"
zip -q -r "build/$NAME" LICENSE.md README.md pack.mcmeta pack.png assets/ -x "*.aseprite"
echo "Successfully compiled $NAME under the build/ directory"
