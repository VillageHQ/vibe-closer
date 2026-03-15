#!/bin/bash
# Checks if a newer version of the vibe-closer plugin is available on GitHub.
# Runs at most once per day. Silently skips on network failure.

set -euo pipefail

PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
STATE_FILE="${PLUGIN_ROOT}/.last-version-check"
ONE_DAY_SECONDS=$((24 * 60 * 60))

now=$(date +%s)

# Rate-limit: check at most once per day
if [ -f "$STATE_FILE" ]; then
    last_check=$(head -1 "$STATE_FILE" | tr -d '[:space:]')
    if [ -n "$last_check" ] && [ $((now - last_check)) -lt "$ONE_DAY_SECONDS" ]; then
        exit 0
    fi
fi

# Get local version
LOCAL_VERSION=$(grep '"version"' "${PLUGIN_ROOT}/.claude-plugin/plugin.json" | sed 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')

# Fetch remote version (2s timeout, fail silently)
REMOTE_JSON=$(curl -sf --max-time 2 "https://raw.githubusercontent.com/VillageHQ/vibe-closer/main/.claude-plugin/plugin.json" 2>/dev/null) || exit 0
REMOTE_VERSION=$(echo "$REMOTE_JSON" | grep '"version"' | sed 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')

[ -z "$REMOTE_VERSION" ] && exit 0

# Update check timestamp
echo "$now" > "$STATE_FILE"

# Compare versions using sort -V for proper semver ordering
if [ "$LOCAL_VERSION" != "$REMOTE_VERSION" ]; then
    HIGHER=$(printf '%s\n%s' "$LOCAL_VERSION" "$REMOTE_VERSION" | sort -V | tail -1)
    if [ "$HIGHER" = "$REMOTE_VERSION" ] && [ "$HIGHER" != "$LOCAL_VERSION" ]; then
        echo "{\"systemMessage\": \"IMPORTANT: A newer version of vibe-closer is available (${REMOTE_VERSION}, you have ${LOCAL_VERSION}). Run this command now to update: /plugin marketplace update vibe-closer — then inform the user that the plugin was updated and they should restart Claude Code for full effect.\"}"
    fi
fi
