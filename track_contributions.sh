#!/bin/bash
# Generates .md report of GitHub OSS contributions using gh CLI search.
# If repos.md lists repos, tracking is scoped to just those. Otherwise it
# covers all public GH repos.
#
# Config (env vars, all optional):
#   GH_USER - GitHub username to track (default: current `gh auth` user)
#   OUT_DIR - where to write output (default: this script's directory)
#
# Requires: gh, jq
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GH_USER="${GH_USER:-$(gh api user --jq .login)}"
OUT_DIR="${OUT_DIR:-$SCRIPT_DIR}"
OUT_FILE="$OUT_DIR/README.md"
LOG_FILE="$OUT_DIR/run.log"
REPOS_FILE="$OUT_DIR/repos.md"

mkdir -p "$OUT_DIR"

# Parse repos.md into --repo=owner/repo flags. Accepts full GitHub URLs or
# bare "owner/repo" lines. Ignores blank lines and lines starting with #.
REPO_ARGS=()
if [[ -f "$REPOS_FILE" ]]; then
  while IFS= read -r line; do
    line="${line#"${line%%[![:space:]]*}"}"  # trim leading whitespace
    [[ -z "$line" || "$line" == \#* ]] && continue
    repo=""
    if [[ "$line" =~ github\.com/([A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+) ]]; then
      repo="${BASH_REMATCH[1]}"
    elif [[ "$line" =~ ^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$ ]]; then
      repo="$line"
    fi
    [[ -n "$repo" ]] && REPO_ARGS+=(--repo="${repo%.git}")
  done < "$REPOS_FILE"
fi

# Fetch each category once as JSON. both the detail list and the aggregate
# table below render from these same blobs instead of re-querying GitHub.
MERGED_JSON=$(gh search prs --author="$GH_USER" --merged --sort=updated --limit=100 \
  ${REPO_ARGS[@]+"${REPO_ARGS[@]}"} --json repository,title,url,updatedAt)
OPEN_JSON=$(gh search prs --author="$GH_USER" --state=open --sort=updated --limit=100 \
  ${REPO_ARGS[@]+"${REPO_ARGS[@]}"} --json repository,title,url,updatedAt)
CLOSED_JSON=$(gh search prs --author="$GH_USER" --state=closed --sort=updated --limit=100 \
  ${REPO_ARGS[@]+"${REPO_ARGS[@]}"} --json repository,title,url,updatedAt -- -is:merged)
ISSUES_JSON=$(gh search issues --author="$GH_USER" --sort=updated --limit=100 \
  ${REPO_ARGS[@]+"${REPO_ARGS[@]}"} --json repository,title,url,updatedAt,state)
COMMENTED_JSON=$(gh search issues --commenter="$GH_USER" --sort=updated --limit=100 \
  ${REPO_ARGS[@]+"${REPO_ARGS[@]}"} --json repository,title,url,updatedAt,state -- "-author:$GH_USER")

# Renders a JSON array of PR/issue objects as a Markdown bullet list.
render_list() {
  local json="$1" show_state="$2"
  if [[ "$show_state" == "true" ]]; then
    echo "$json" | jq -r '.[] | "- [\(.repository.nameWithOwner)] [\(.title)](\(.url)) (\(.state))"'
  else
    echo "$json" | jq -r '.[] | "- [\(.repository.nameWithOwner)] [\(.title)](\(.url))"'
  fi
}

{
echo "# OSS Contributions for $GH_USER"
echo
echo "_Last updated: $(date '+%Y-%m-%d %H:%M %Z')_"
if [[ ${#REPO_ARGS[@]} -gt 0 ]]; then
  echo
  echo "_Scoped to repos listed in repos.md_"
fi
echo

echo "## Summary"
echo
echo "| Repo | Merged PRs | Open PRs | Closed PRs | Issues Opened | Issues Commented | Total |"
echo "|---|---|---|---|---|---|---|"
jq -n \
  --argjson merged "$MERGED_JSON" \
  --argjson open "$OPEN_JSON" \
  --argjson closed "$CLOSED_JSON" \
  --argjson issues "$ISSUES_JSON" \
  --argjson commented "$COMMENTED_JSON" '
  def counts(arr): arr | group_by(.repository.nameWithOwner)
    | map({key: .[0].repository.nameWithOwner, value: length}) | from_entries;
  (counts($merged)) as $m | (counts($open)) as $o | (counts($closed)) as $c
    | (counts($issues)) as $i | (counts($commented)) as $cm
    | ([$m, $o, $c, $i, $cm] | map(keys) | add | unique) as $repos
    | $repos[] as $r
    | [$r, ($m[$r] // 0), ($o[$r] // 0), ($c[$r] // 0), ($i[$r] // 0), ($cm[$r] // 0)] as $row
    | $row + [$row[1:] | add]
    | "| \(.[0]) | \(.[1]) | \(.[2]) | \(.[3]) | \(.[4]) | \(.[5]) | \(.[6]) |"
  ' -r
echo

echo "## Merged Pull Requests"
echo
render_list "$MERGED_JSON" false
echo

echo "## Open Pull Requests"
echo
render_list "$OPEN_JSON" false
echo

echo "## Closed (Unmerged) Pull Requests"
echo
render_list "$CLOSED_JSON" false
echo

echo "## Issues Opened"
echo
render_list "$ISSUES_JSON" true
echo

echo "## Issues Participation (not opened by me)"
echo
render_list "$COMMENTED_JSON" true
echo

} > "$OUT_FILE" 2>"$LOG_FILE"

echo "Report written to $OUT_FILE" >> "$LOG_FILE"

# Commit and push only if README.md actually changed, ignoring the
# "Last updated" timestamp line, and this is a git repo with a remote
# configured.
if git -C "$OUT_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1 \
  && git -C "$OUT_DIR" remote get-url origin >/dev/null 2>&1; then
  OUT_FILE_NAME="$(basename "$OUT_FILE")"
  OLD_CONTENT="$(git -C "$OUT_DIR" show "HEAD:$OUT_FILE_NAME" 2>/dev/null | grep -v '^_Last updated:')"
  NEW_CONTENT="$(grep -v '^_Last updated:' "$OUT_FILE")"
  if [[ "$OLD_CONTENT" != "$NEW_CONTENT" ]]; then
    {
      git -C "$OUT_DIR" add "$OUT_FILE"
      git -C "$OUT_DIR" commit -m "Update contributions report"
      git -C "$OUT_DIR" push
    } >> "$LOG_FILE" 2>&1
  fi
fi
