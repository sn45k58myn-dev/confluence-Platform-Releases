# Confluence Platform Releases

Public, integrity-checked release artifacts for the private
[`confluence-Platform`](https://github.com/sn45k58myn-dev/confluence-Platform)
source repository.

This repository contains release metadata and validation tooling. Release
payloads are attached to GitHub Releases; generated archives are never committed
to the default branch.

See [RELEASE_CONTRACT.md](RELEASE_CONTRACT.md) for the required assets and
`tools/verify-release.sh` for the fail-closed verification performed after each
release is published.

No release is considered usable until the verification workflow passes.
