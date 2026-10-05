# buildenv.sh :
#
#   source ./buildenv.sh        enabled the environment
#   buildenv_deactivate         restores the previous environment
#
# In this shell :
#   - CC / CXX      = clang / clang++ Apple (/usr/bin)
#   - gcc / g++     = from Homebrew
#   - bison         = from Homebrew
#   - brew          = Available, but limited to bison and gcc (see wrapper)

(return 0 2>/dev/null) || { echo "This file must be sourced : source $0" >&2; exit 1; }

if [ -n "${BUILDENV_ACTIVE-}" ]; then
  echo "buildenv is already enabled (buildenv_deactivate to escape buildenv)" >&2
  return 0
fi

# Checks (Before editing PATH)
_be_real_brew="$(command -v brew 2>/dev/null)"
[ -n "$_be_real_brew" ] || { echo "Homebrew missing" >&2; return 1; }
[ -x /usr/bin/clang ]   || { echo "clang Apple missing : xcode-select --install" >&2; return 1; }

_be_bison_prefix="$("$_be_real_brew" --prefix bison)"
_be_gcc_prefix="$("$_be_real_brew" --prefix gcc)"

[ -x "$_be_bison_prefix/bin/bison" ] || { echo "bison missing : brew install bison" >&2; return 1; }

_be_gcc="$(ls "$_be_gcc_prefix"/bin/gcc-[0-9]* 2>/dev/null | sort -V | tail -n1)"
_be_gxx="$(ls "$_be_gcc_prefix"/bin/g++-[0-9]* 2>/dev/null | sort -V | tail -n1)"
[ -n "$_be_gcc" ] || { echo "gcc missing : brew install gcc" >&2; return 1; }

# Links Folder
export BUILDENV_DIR="${BUILDENV_DIR:-$PWD/.toolchain}"
rm -rf "$BUILDENV_DIR"
mkdir -p "$BUILDENV_DIR/bin" "$BUILDENV_DIR/empty-pkgconfig"

ln -s "$_be_bison_prefix/bin/bison" "$BUILDENV_DIR/bin/bison"
ln -s "$_be_gcc" "$BUILDENV_DIR/bin/gcc"
[ -n "$_be_gxx" ] && ln -s "$_be_gxx" "$BUILDENV_DIR/bin/g++"

# Wrapper brew :  allows only bison and gcc
export BUILDENV_REAL_BREW="$_be_real_brew"
cat > "$BUILDENV_DIR/bin/brew" <<'WRAPPER'
#!/bin/bash
# Wrapper brew
real="${BUILDENV_REAL_BREW:?}"
deny() { echo "brew (buildenv) : refused, $*. Only bison and gcc are allowed." >&2; exit 1; }

cmd="${1:-}"
case "$cmd" in
  --version|-v) exec "$real" "$@" ;;
  --prefix|--cellar|install|upgrade|reinstall|uninstall|remove|info|list|ls) ;;
  *) deny "commande '$cmd'" ;;
esac
shift

n=0
for a in "$@"; do
  case "$a" in -*) continue ;; esac
  case "$a" in
    bison|gcc) n=$((n+1)) ;;
    *) deny "formule '$a'" ;;
  esac
done
[ "$n" -gt 0 ] || deny "bison or gcc"

exec "$real" "$cmd" "$@"
WRAPPER
chmod +x "$BUILDENV_DIR/bin/brew"

# Save the current state
for _be_v in PATH CC CXX SDKROOT PKG_CONFIG_LIBDIR PKG_CONFIG_PATH CMAKE_PREFIX_PATH \
             CMAKE_IGNORE_PREFIX_PATH CPATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH LIBRARY_PATH \
             CPPFLAGS CFLAGS CXXFLAGS LDFLAGS DYLD_LIBRARY_PATH DYLD_FALLBACK_LIBRARY_PATH \
             ACLOCAL_PATH PS1; do
  eval "_BUILDENV_SAVED_${_be_v}=\${${_be_v}-__unset__}"
done

# Fonction de sortie
buildenv_deactivate() {
  local _v _val
  for _v in PATH CC CXX SDKROOT PKG_CONFIG_LIBDIR PKG_CONFIG_PATH CMAKE_PREFIX_PATH \
            CMAKE_IGNORE_PREFIX_PATH CPATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH LIBRARY_PATH \
            CPPFLAGS CFLAGS CXXFLAGS LDFLAGS DYLD_LIBRARY_PATH DYLD_FALLBACK_LIBRARY_PATH \
            ACLOCAL_PATH PS1; do
    eval "_val=\${_BUILDENV_SAVED_${_v}-__unset__}"
    if [ "$_val" = "__unset__" ]; then
      unset "$_v"
    else
      export "$_v=$_val"
    fi
    unset "_BUILDENV_SAVED_${_v}"
  done
  unset BUILDENV_ACTIVE BUILDENV_REAL_BREW
  unset -f buildenv_deactivate
  hash -r 2>/dev/null
  echo "buildenv disabled"
}

# Activation
unset CPATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH LIBRARY_PATH \
      CPPFLAGS CFLAGS CXXFLAGS LDFLAGS \
      PKG_CONFIG_PATH CMAKE_PREFIX_PATH \
      DYLD_LIBRARY_PATH DYLD_FALLBACK_LIBRARY_PATH ACLOCAL_PATH

export PATH="$BUILDENV_DIR/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export SDKROOT="$(xcrun --show-sdk-path)"
export CC=/usr/bin/clang CXX=/usr/bin/clang++
export PKG_CONFIG_LIBDIR="$BUILDENV_DIR/empty-pkgconfig"
export CMAKE_IGNORE_PREFIX_PATH="/opt/homebrew;/usr/local"
export BUILDENV_ACTIVE=1
PS1="(buildenv) ${PS1-}"
hash -r 2>/dev/null

echo "buildenv enabled :"
echo "  CC    -> $("$CC" --version | head -n1)"
echo "  gcc   -> $(gcc --version | head -n1)"
echo "  bison -> $(bison --version | head -n1)"

unset _be_real_brew _be_bison_prefix _be_gcc_prefix _be_gcc _be_gxx _be_v
