#!/usr/bin/env bash
# SPDX-License-Identifier: AGPL-3.0-or-later
set -euo pipefail

TOOL_NAME="acceleration-middleware"

fail() {
  echo -e "\e[31mFail:\e[m $*" >&2
  exit 1
}

list_all_versions() {
  echo "1.0.0"
}

download_release() {
  local version="$1"
  local download_path="$2"
  mkdir -p "$download_path"
  echo "$version" > "$download_path/VERSION"
}

install_version() {
  local version="$1"
  local install_path="$2"
  mkdir -p "$install_path/bin"
  cat > "$install_path/bin/$TOOL_NAME" << 'SCRIPT'
#!/usr/bin/env bash
echo "acceleration-middleware meta plugin"
SCRIPT
  chmod +x "$install_path/bin/$TOOL_NAME"
}
