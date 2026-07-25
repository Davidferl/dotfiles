#!/usr/bin/env bash
# Fires after herdr has already run `git worktree remove`, so the checkout is
# gone; the job here is deleting the now-orphaned local branch.
set -uo pipefail

LOG="${HERDR_PLUGIN_STATE_DIR:-/tmp}/cleanup.log"
log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >>"$LOG"
}

EVENT_JSON="${HERDR_PLUGIN_EVENT_JSON:-}"
if [ -z "$EVENT_JSON" ]; then
  log "no event payload, exiting"
  exit 0
fi

log "worktree.removed payload: $EVENT_JSON"

# herdr wraps the event as {"event":..,"data":{"worktree":{..}}}. Older builds
# put it at the top level, so read both shapes.
branch=$(echo "$EVENT_JSON" | jq -r '.data.worktree.branch // .worktree.branch // empty')
wt_path=$(echo "$EVENT_JSON" | jq -r '.data.worktree.path // .worktree.path // empty')

if [ -z "$branch" ] || [ -z "$wt_path" ]; then
  log "missing branch or path in payload, skipping"
  exit 0
fi

case "$branch" in
master | main)
  log "refusing to delete protected branch '$branch'"
  exit 0
  ;;
esac

# The docs don't say whether this event fires before or after the checkout is
# deleted; tear down Tilt only if the Tiltfile is still there.
if [ -e "$wt_path/Tiltfile" ] && command -v tilt >/dev/null 2>&1; then
  if tilt down -f "$wt_path/Tiltfile" >>"$LOG" 2>&1; then
    log "tilt down succeeded for $wt_path"
  else
    log "tilt down failed for $wt_path"
  fi
else
  log "skipping tilt down (checkout already gone or tilt not installed)"
fi

repo_root=$(echo "$EVENT_JSON" | jq -r '.data.workspace.worktree.repo_root // .data.worktree.repo_root // .worktree.repo_root // .repo_root // empty')
if [ -z "$repo_root" ]; then
  # herdr worktrees live at <dir>/<repo-name>/<branch>; recover the main
  # checkout from that.
  repo_name=$(basename "$(dirname "$wt_path")")
  for candidate in "$HOME/botpress/$repo_name" "$HOME/$repo_name"; do
    if git -C "$candidate" rev-parse --show-toplevel >/dev/null 2>&1; then
      repo_root="$candidate"
      break
    fi
  done
fi

if [ -z "$repo_root" ]; then
  log "could not locate main repo for '$branch' (worktree was $wt_path), skipping"
  exit 0
fi

if ! git -C "$repo_root" show-ref --verify --quiet "refs/heads/$branch"; then
  log "branch '$branch' does not exist in $repo_root, nothing to do"
  exit 0
fi

if git -C "$repo_root" branch -d "$branch" >>"$LOG" 2>&1; then
  log "deleted branch '$branch' in $repo_root"
  exit 0
fi

# Squash-merged PRs fail `-d` because git can't see the merge; trust GitHub's
# merged state before force-deleting.
pr_state=$(cd "$repo_root" && gh pr view "$branch" --json state --jq .state 2>/dev/null || true)
if [ "$pr_state" = "MERGED" ]; then
  if git -C "$repo_root" branch -D "$branch" >>"$LOG" 2>&1; then
    log "force-deleted branch '$branch' (PR merged) in $repo_root"
    exit 0
  fi
fi

log "kept branch '$branch': not merged (PR state: ${pr_state:-none})"
