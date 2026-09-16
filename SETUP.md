# Setup

Tracks your GitHub OSS contributions (merged/open/closed PRs, issues opened,
issues commented on) and writes a summary and detail report to `README.md`.

## Prerequisites

- [`gh`](https://cli.github.com/) (GitHub CLI), authenticated: `gh auth login`
- [`jq`](https://jqlang.org/)

On macOS: `brew install gh jq`

## First run

```bash
./track_contributions.sh
```

This writes `README.md` in the same directory. It auto-detects your GitHub
username from `gh auth`. Override with `GH_USER=someone ./track_contributions.sh`
if needed. Output location can be overridden with `OUT_DIR=/some/path`.

`README.md` is generated. Do not hand-edit it, your changes will be
overwritten on the next run.

## Scoping to specific repos

By default the script searches your contributions across all of GitHub. To
scope it to a fixed list of repos instead, edit `repos.md`:

```
- https://github.com/owner/repo
- another-owner/another-repo
```

One repo per line, either a full GitHub URL or `owner/repo`. Lines starting
with `#` are ignored. Delete or empty the file to go back to tracking
everything.

## Running it on a schedule (macOS)

macOS deprecated `cron` in favor of `launchd`. To run this every 3 days:

1. Copy the template and fill in your actual paths:
   ```bash
   cp com.example.oss-tracker.plist.template ~/Library/LaunchAgents/com.yourname.oss-tracker.plist
   ```
2. Edit that copy. Replace every `/ABSOLUTE/PATH/TO/oss-tracker-log` with
   the real path to this directory on your machine, and `com.example` in the
   `Label` with something unique to you.
3. Load it:
   ```bash
   launchctl load ~/Library/LaunchAgents/com.yourname.oss-tracker.plist
   ```
4. Check it's running:
   ```bash
   launchctl list | grep oss-tracker
   ```

Note: this only fires while your Mac is awake. If it's asleep or off at the
scheduled time, `launchd` generally runs the job on next wake instead of
skipping it, but the exact timing will not be reliable.

To stop it: `launchctl unload ~/Library/LaunchAgents/com.yourname.oss-tracker.plist`

## Auto-committing the report

The script commits and pushes `README.md` automatically at the end of each
run, but only if all of these are true:

- this directory is a git repo
- it has a remote named `origin`
- `README.md` actually changed since the last commit

If your directory is not yet a git repo, or has no `origin` remote set up,
the script just writes the file locally and skips the git step with no
error.
