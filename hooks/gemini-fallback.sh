#!/usr/bin/env bash
# Gemini Fallback Hook — Advisory mode
# Detects repeated errors and suggests switching to Gemini.
# Registered as PostToolUse hook in ~/.claude/settings.json

set -euo pipefail

STATE_FILE="$HOME/.claude/hooks/.failure-state.json"
TTL_MINUTES=10

# Read hook input from stdin
INPUT=$(cat)

# Extract tool response as string
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty' 2>/dev/null || echo "")
TOOL_RESPONSE=$(echo "$INPUT" | jq -r '.tool_response // empty' 2>/dev/null || echo "")

# If we couldn't parse input, exit silently
if [ -z "$TOOL_NAME" ]; then
  exit 0
fi

# Detect if this is an error result
IS_ERROR=false
if echo "$TOOL_RESPONSE" | grep -qiE '(error|exception|failed|FAIL|traceback|panic)' 2>/dev/null; then
  IS_ERROR=true
fi

# Initialize state file if missing
if [ ! -f "$STATE_FILE" ]; then
  echo '{"lastErrorHash":"","lastErrorPreview":"","consecutiveFailures":0,"lastUpdated":""}' > "$STATE_FILE"
fi

# Check TTL — reset if stale
LAST_UPDATED=$(jq -r '.lastUpdated // ""' "$STATE_FILE" 2>/dev/null || echo "")
if [ -n "$LAST_UPDATED" ]; then
  LAST_EPOCH=$(date -d "$LAST_UPDATED" +%s 2>/dev/null || echo "0")
  NOW_EPOCH=$(date +%s)
  DIFF_MINUTES=$(( (NOW_EPOCH - LAST_EPOCH) / 60 ))
  if [ "$DIFF_MINUTES" -ge "$TTL_MINUTES" ]; then
    echo '{"lastErrorHash":"","lastErrorPreview":"","consecutiveFailures":0,"lastUpdated":""}' > "$STATE_FILE"
  fi
fi

if [ "$IS_ERROR" = true ]; then
  # Normalize error: strip line numbers, paths, timestamps, take first 200 chars
  NORMALIZED=$(echo "$TOOL_RESPONSE" \
    | sed -E 's/[0-9]{4}-[0-9]{2}-[0-9]{2}[T ][0-9]{2}:[0-9]{2}:[0-9]{2}[^ ]*/TIMESTAMP/g' \
    | sed -E 's/line [0-9]+/line N/gi' \
    | sed -E 's/:[0-9]+:[0-9]+/:N:N/g' \
    | sed -E 's|/[^ ]*\.([a-z]+)|/PATH.\1|g' \
    | sed -E 's|\\[^ ]*\.([a-z]+)|\\PATH.\1|g' \
    | head -c 200)

  # Hash the normalized error
  ERROR_HASH=$(echo "$NORMALIZED" | md5sum | cut -d' ' -f1)
  PREVIEW=$(echo "$TOOL_RESPONSE" | head -c 100)

  # Compare to previous state
  PREV_HASH=$(jq -r '.lastErrorHash // ""' "$STATE_FILE" 2>/dev/null || echo "")
  PREV_COUNT=$(jq -r '.consecutiveFailures // 0' "$STATE_FILE" 2>/dev/null || echo "0")

  if [ "$ERROR_HASH" = "$PREV_HASH" ]; then
    NEW_COUNT=$((PREV_COUNT + 1))
  else
    NEW_COUNT=1
  fi

  # Update state
  NOW=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  jq --arg hash "$ERROR_HASH" \
     --arg preview "$PREVIEW" \
     --argjson count "$NEW_COUNT" \
     --arg ts "$NOW" \
     '.lastErrorHash=$hash | .lastErrorPreview=$preview | .consecutiveFailures=$count | .lastUpdated=$ts' \
     "$STATE_FILE" > "${STATE_FILE}.tmp" && mv "${STATE_FILE}.tmp" "$STATE_FILE"

  # Advisory trigger at 2+ consecutive same errors
  if [ "$NEW_COUNT" -ge 2 ]; then
    if [ -z "${GEMINI_API_KEY:-}" ]; then
      echo '{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":"Claude hit the same error twice but GEMINI_API_KEY is not set. Add it to your environment to enable Gemini fallback."}}'
    else
      echo '{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":"Claude hit the same wall twice on this error pattern. Consider starting a fresh session with Gemini for a different approach: claude --model gemini-2.5-pro"}}'
    fi
  fi
else
  # Success — reset state
  if [ -f "$STATE_FILE" ]; then
    echo '{"lastErrorHash":"","lastErrorPreview":"","consecutiveFailures":0,"lastUpdated":""}' > "$STATE_FILE"
  fi
fi
