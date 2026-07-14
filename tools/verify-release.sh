#!/usr/bin/env bash
set -euo pipefail

TAG="${1:-${GITHUB_REF_NAME:-}}"
REPOSITORY="${2:-sn45k58myn-dev/confluence-Platform-Releases}"

if [[ ! "$TAG" =~ ^[0-9]+\.[0-9]+\.[0-9]+([.-][A-Za-z0-9.-]+)?$ ]]; then
    echo "A semantic release tag is required" >&2
    exit 1
fi

for command in gh sha256sum tar unzip; do
    command -v "$command" >/dev/null || { echo "Missing command: $command" >&2; exit 1; }
done

workdir="$(mktemp -d)"
trap 'rm -rf "$workdir"' EXIT

assets=(CONFLUENCETV.zip confluencetv.tar.gz loadbalancer.tar.gz hashes.sha256)
gh release download "$TAG" --repo "$REPOSITORY" --dir "$workdir" --pattern '*'

for asset in "${assets[@]}"; do
    [[ -s "$workdir/$asset" ]] || { echo "Missing release asset: $asset" >&2; exit 1; }
done

for asset in CONFLUENCETV.zip confluencetv.tar.gz loadbalancer.tar.gz; do
    count="$(awk -v file="$asset" '$2 == file || $2 == "*" file { count++ } END { print count + 0 }' "$workdir/hashes.sha256")"
    [[ "$count" == 1 ]] || { echo "Expected one digest for $asset" >&2; exit 1; }
done

(cd "$workdir" && sha256sum --check --strict hashes.sha256)

unzip -tqq "$workdir/CONFLUENCETV.zip"
for archive in confluencetv.tar.gz loadbalancer.tar.gz; do
    tar -tzf "$workdir/$archive" >/dev/null
done

check_paths() {
    local listing="$1"
    if grep -Eq '(^/|(^|/)\.\.(/|$)|^[A-Za-z]:)' "$listing"; then
        echo "Unsafe archive path detected" >&2
        exit 1
    fi
}

unzip -Z1 "$workdir/CONFLUENCETV.zip" > "$workdir/zip.paths"
check_paths "$workdir/zip.paths"
for archive in confluencetv.tar.gz loadbalancer.tar.gz; do
    tar -tzf "$workdir/$archive" > "$workdir/$archive.paths"
    check_paths "$workdir/$archive.paths"
done

echo "Release $TAG satisfies the Confluence Platform release contract"
