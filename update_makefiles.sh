#!/usr/bin/env bash
set -euo pipefail

# -----------------------------
# CONFIG (edit these two only)
# -----------------------------
MEDIAINFO_VERSION="26.01"   # applies to: mediainfo + libmediainfo
LIBZEN_VERSION="0.4.41"     # applies to: libzen

# -----------------------------
# Makefile locations (relative)
# -----------------------------
MF_LIBMEDIAINFO="libmediainfo/Makefile"
MF_MEDIAINFO="mediainfo/Makefile"
MF_LIBZEN="libzen/Makefile"

die() { echo "ERROR: $*" >&2; exit 1; }

need() {
  command -v "$1" >/dev/null 2>&1 || die "Missing dependency: $1"
}

need awk
need sed
need mktemp
need curl
need sha256sum

get_var() {
  # get_var <makefile> <VAR>
  awk -F':=' -v v="$2" '
    $1==v { sub(/^[ \t]+/, "", $2); sub(/[ \t\r]+$/, "", $2); print $2; exit }
  ' "$1"
}

update_kv() {
  # update_kv <makefile> <KEY> <VALUE>
  # Replaces the first occurrence of ^KEY:=...$
  local mf="$1" key="$2" val="$3"
  grep -qE "^${key}:=" "$mf" || die "$mf: cannot find ${key}:="
  sed -i -E "0,/^${key}:=/s|^(${key}:=).*|\1${val}|" "$mf"
}

extract_source_suffix() {
  # From PKG_SOURCE:= $(PKG_NAME)_$(PKG_VERSION)<suffix>
  # return <suffix> (e.g. .tar.xz)
  local rhs="$1"
  # remove spaces
  rhs="${rhs//[[:space:]]/}"
  # expect prefix '$(PKG_NAME)_$(PKG_VERSION)'
  local prefix="\$(PKG_NAME)_\$(PKG_VERSION)"
  [[ "$rhs" == ${prefix}* ]] || die "PKG_SOURCE is not in expected form: $rhs"
  echo "${rhs#${prefix}}"
}

compute_hash_for_makefile() {
  # compute_hash_for_makefile <makefile> <new_version>
  local mf="$1" ver="$2"

  [[ -f "$mf" ]] || die "Makefile not found: $mf"

  local pkg_name pkg_source_url pkg_source_rhs suffix src_file url tmpdir tarball sha
  pkg_name="$(get_var "$mf" "PKG_NAME")"
  pkg_source_url="$(get_var "$mf" "PKG_SOURCE_URL")"
  pkg_source_rhs="$(get_var "$mf" "PKG_SOURCE")"

  [[ -n "$pkg_name" ]] || die "$mf: PKG_NAME empty/not found"
  [[ -n "$pkg_source_url" ]] || die "$mf: PKG_SOURCE_URL empty/not found"
  [[ -n "$pkg_source_rhs" ]] || die "$mf: PKG_SOURCE empty/not found"

  suffix="$(extract_source_suffix "$pkg_source_rhs")"
  src_file="${pkg_name}_${ver}${suffix}"

  # Evaluate $(PKG_NAME) and $(PKG_VERSION) in PKG_SOURCE_URL
  pkg_source_url="${pkg_source_url//\$(PKG_NAME)/$pkg_name}"
  pkg_source_url="${pkg_source_url//\$(PKG_VERSION)/$ver}"
  pkg_source_url="${pkg_source_url%/}"

  url="${pkg_source_url}/${src_file}"

  tmpdir="$(mktemp -d)"
  tarball="${tmpdir}/${src_file}"

  # Download (fail on 404 etc.)
  if ! curl -fsSL "$url" -o "$tarball"; then
    rm -rf "$tmpdir"
    die "$mf: download failed: $url"
  fi

  sha="$(sha256sum "$tarball" | awk '{print $1}')"

  rm -f "$tarball"
  rm -rf "$tmpdir"

  # Update Makefile
  update_kv "$mf" "PKG_VERSION" "$ver"
  update_kv "$mf" "PKG_HASH" "$sha"

  echo "$pkg_name: PKG_VERSION=$ver PKG_HASH=$sha"
}

main() {
  echo "Updating Makefiles..."
  echo "  mediainfo + libmediainfo -> ${MEDIAINFO_VERSION}"
  echo "  libzen                  -> ${LIBZEN_VERSION}"
  echo

  compute_hash_for_makefile "$MF_LIBMEDIAINFO" "$MEDIAINFO_VERSION"
  compute_hash_for_makefile "$MF_MEDIAINFO" "$MEDIAINFO_VERSION"
  compute_hash_for_makefile "$MF_LIBZEN" "$LIBZEN_VERSION"
}

main "$@"
