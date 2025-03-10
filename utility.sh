#!/bin/sh
# Usage:
#  $ ./utility.sh # Launch the OpenRA.Utility with the default mod
#  $ Mod="<mod id>" ./launch-utility.sh # Launch the OpenRA.Utility with a specific mod

set -e
command -v make >/dev/null 2>&1 || { echo >&2 "The OpenRA mod template requires make."; exit 1; }
command -v python >/dev/null 2>&1 || { echo >&2 "The OpenRA mod template requires python."; exit 1; }
command -v mono >/dev/null 2>&1 || { echo >&2 "The OpenRA mod template requires mono."; exit 1; }

TEMPLATE_LAUNCHER=$(python -c "import os; print(os.path.realpath('$0'))")
TEMPLATE_ROOT=$(dirname "${TEMPLATE_LAUNCHER}")
MOD_SEARCH_PATHS="${TEMPLATE_ROOT}/mods,./mods"

# shellcheck source=mod.config
. "${TEMPLATE_ROOT}/mod.config"

if [ -f "${TEMPLATE_ROOT}/user.config" ]; then
	# shellcheck source=user.config
	. "${TEMPLATE_ROOT}/user.config"
fi

LAUNCH_MOD="${Mod:-"${MOD_ID}"}"

cd "${TEMPLATE_ROOT}"
if [ ! -f "${ENGINE_DIRECTORY}/OpenRA.Game.exe" ] || [ "$(cat "${ENGINE_DIRECTORY}/VERSION")" != "${ENGINE_VERSION}" ]; then
	echo "Required engine files not found."
	echo "Run \`make\` in the mod directory to fetch and build the required files, then try again.";
	exit 1
fi

cd "${ENGINE_DIRECTORY}"
MOD_SEARCH_PATHS="${MOD_SEARCH_PATHS}" mono --debug OpenRA.Utility.exe "${LAUNCH_MOD}" "$@"
