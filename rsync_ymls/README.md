# `sync_ymls.sh` — YAML Sync Helper

A small utility script that syncs a set of YAML files from a **source directory** to a **destination directory** using `rsync`, with optional ownership fixing.

This is intended to be installed somewhere on your `$PATH` so you can run it from anywhere.

---

## What it does

1. Validates the source directory exists.
2. Validates the destination directory exists.
3. Validates the requested files exist in the source directory.
4. Runs `rsync` to copy/update files into the destination directory.
5. Optionally fixes file ownership (best-effort; may require sudo).

---

## Install location (recommended)

Install the script into a standard bin directory, for example:

- `/usr/local/bin/sync_ymls.sh`

This location is commonly included in `$PATH` on Linux, and is a conventional place for local admin scripts.

---

## Installation

### 1) Create the script

```bash
sudo tee /usr/local/bin/sync_ymls.sh >/dev/null <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

# -----------------------------
# Defaults (override via flags)
# -----------------------------
SRC_DIR="${SRC_DIR:-/path/to/source}"
DST_DIR="${DST_DIR:-/path/to/destination}"
FILES_DEFAULT=("file1.yml" "file2.yml")

usage() {
  cat <<'USAGE'
Usage:
  sync_ymls.sh [options]

Options:
  --src DIR              Source directory (default: $SRC_DIR or /path/to/source)
  --dst DIR              Destination directory (default: $DST_DIR or /path/to/destination)
  --files "A B C"        Space-separated list of files to sync (default: file1.yml file2.yml)
  --owner USER:GROUP     Set ownership on destination files (best-effort; may require sudo)
  -n, --dry-run          Print what would change, but do not modify anything
  -h, --help             Show this help

Examples:
  # Minimal (uses defaults)
  sync_ymls.sh

  # Specify src/dst and files
  sync_ymls.sh --src /src/dir --dst /dst/dir --files "Movies.yml series.yml"

  # Dry-run
  sync_ymls.sh --src /src/dir --dst /dst/dir --files "a.yml b.yml" --dry-run

  # Set ownership after sync
  sync_ymls.sh --src /src/dir --dst /dst/dir --files "a.yml b.yml" --owner plex:plex
USAGE
}

DRY_RUN=0
OWNER=""

# Parse args
FILES=("${FILES_DEFAULT[@]}")
while [[ $# -gt 0 ]]; do
  case "$1" in
    --src)
      SRC_DIR="$2"; shift 2 ;;
    --dst)
      DST_DIR="$2"; shift 2 ;;
    --files)
      # Space-separated string -> array
      read -r -a FILES <<< "$2"
      shift 2 ;;
    --owner)
      OWNER="$2"; shift 2 ;;
    -n|--dry-run)
      DRY_RUN=1; shift ;;
    -h|--help)
      usage; exit 0 ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2 ;;
  esac
done

echo "Source:      $SRC_DIR"
echo "Destination: $DST_DIR"
echo "Files:       ${FILES[*]}"
[[ "$DRY_RUN" -eq 1 ]] && echo "Mode:        dry-run"

# Sanity checks
if [[ ! -d "$SRC_DIR" ]]; then
  echo "ERROR: Source directory does not exist: $SRC_DIR" >&2
  exit 1
fi

if [[ ! -d "$DST_DIR" ]]; then
  echo "ERROR: Destination directory does not exist: $DST_DIR" >&2
  exit 1
fi

for f in "${FILES[@]}"; do
  if [[ ! -f "$SRC_DIR/$f" ]]; then
    echo "ERROR: Missing source file: $SRC_DIR/$f" >&2
    exit 1
  fi
done

RSYNC_FLAGS=(-av --progress)
if [[ "$DRY_RUN" -eq 1 ]]; then
  RSYNC_FLAGS=(-avn --progress)
fi

# Sync
rsync "${RSYNC_FLAGS[@]}" \
  "${FILES[@]/#/$SRC_DIR/}" \
  "$DST_DIR/"

# Ownership fix (best-effort)
if [[ -n "$OWNER" && "$DRY_RUN" -eq 0 ]]; then
  if command -v sudo >/dev/null 2>&1; then
    sudo chown "$OWNER" "${FILES[@]/#/$DST_DIR/}" 2>/dev/null || true
  else
    chown "$OWNER" "${FILES[@]/#/$DST_DIR/}" 2>/dev/null || true
  fi
fi

echo "Result:"
ls -l "${FILES[@]/#/$DST_DIR/}"
EOF
