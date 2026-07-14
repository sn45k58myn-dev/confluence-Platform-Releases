# Release contract

Every stable or prerelease tag must publish exactly the following required
assets:

- `CONFLUENCETV.zip` — installer plus the main application archive.
- `confluencetv.tar.gz` — main-node application archive.
- `loadbalancer.tar.gz` — load-balancer application archive.
- `hashes.sha256` — GNU `sha256sum` manifest covering all three archives.

The manifest must use the form `<64 lowercase hex characters>  <filename>`.
Consumers reject missing digests, mismatches, absolute archive paths, path
traversal entries, symlinks escaping the extraction root, and empty archives.

Tags use semantic versions without a leading `v`, for example `2.4.0` or
`2.4.0-beta.1`. The release channel is determined by GitHub's prerelease flag.

Assets are built and tested from the matching source tag in
`sn45k58myn-dev/confluence-Platform`. This repository must never be used as a
source-code mirror.
