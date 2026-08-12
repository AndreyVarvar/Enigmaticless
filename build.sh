#!/bin/zsh
# this file will compile all the assets into a neat zip-package under build/ folder to be distributed

show_help=false
show_version=false
bump_version=false
bump_type="patch"
directory="./build/"

while getopts "hvpB:d:" opt; do
  case "$opt" in
  h) show_help=true ;;
  v) show_version=true ;;
  p)
    bump_version=true
    bump_type="patch"
    ;;
  B)
    bump_version=true
    bump_type="$OPTARG"
    ;;
  d)
    directory="$OPTARG"
    ;;
  *)
    echo "Invalid flag passed"
    exit 1
    ;;
  esac
done

shift $((OPTIND - 1))
directory="${directory%/}"

if $show_help; then
  echo "NAME"
  echo "  build - compile all the assets in this directory into a single zip-file texture-pack"
  echo ""
  echo "DESCRIPTION"
  echo "The build utility parses files in the location of invocation. If no option was passed, the script will compile all the assets"
  echo "  -h                              shows this help menu"
  echo "  -v                              shows current version"
  echo "  -B [major|minor|patch]          bumps version with criteria passed as an argument"
  echo "  -p                              shorthand for '-B patch'"
  echo "  -d [path/to/folder]             if specified, changes the export directory of the zip-file"
  echo ""
  echo "EXIT STATUS"
  echo "The build utility exits 0 on success, and 1 if an error occurs."
  echo ""
  echo "EXAMPLES"
  echo "  The command:"
  echo "    ./build.sh"
  echo "  will compile all the assets"
  echo "  The command:"
  echo "    ./build.sh -B minor"
  echo "  will compile all the assets and bump the minor version"
  echo "  The command:"
  echo "    ./build.sh -b"
  echo "  will compile all the assets and bump the patch version"

  exit 0
fi

VERSION=$(cat pack-version.txt)
VERSION_PREFIX="${VERSION%-*}"

if $show_version; then
  echo "Current version: $VERSION"
  exit 0
fi

if $bump_version; then
  OLD_VERSION_SUFFIX="${VERSION##*-}"

  local -a V
  V=(${(s:.:)OLD_VERSION_SUFFIX})

  case "$bump_type" in
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
    echo "Invalid argument: $bump_type" >&2
    exit 1
    ;;
  esac

  NEW_VERSION_SUFFIX="${(j:.:)V}"

  echo "Updated from $OLD_VERSION_SUFFIX to $NEW_VERSION_SUFFIX"
  VERSION="$VERSION_PREFIX-$NEW_VERSION_SUFFIX"
  echo "$VERSION" >pack-version.txt

  exit 0
fi

PROJECT_NAME="Enigmaticless"

# clear the build directory first
rm -rf "$directory/$PROJECT_NAME-$VERSION_PREFIX-*.zip"
# the compilation part
NAME="$PROJECT_NAME-$VERSION.zip"
zip -q -r "$directory/$NAME" LICENSE.md README.md pack.mcmeta pack.png assets/ -x "*.aseprite" ".DS_Store"
echo "Successfully compiled $NAME under the $directory/ directory"
