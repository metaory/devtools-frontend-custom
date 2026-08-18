# Build dependencies

Phase 1 uses a GitHub-hosted runner directly. Host tools are kept minimal;
upstream owns its build tool versions through `DEPS` and `gclient sync`.

| Component | Owner | Selection | Verification |
| --- | --- | --- | --- |
| OS | workflow | `ubuntu-22.04`, x86-64 | `lsb_release -ds` |
| Git | runner | system package | `git --version` |
| Python | workflow | `actions/setup-python`, 3.11 | `python3 --version` |
| depot_tools | build script | current upstream checkout | `gclient help` |
| CIPD | depot_tools | bundled client | `cipd version` |
| Node.js | upstream DEPS | pinned download from `gclient sync` | `third_party/node/linux/node-linux-x64/bin/node --version` |
| GN | upstream DEPS | pinned CIPD package from `gclient sync` | `buildtools/linux64/gn --version` |
| Ninja | upstream DEPS | pinned CIPD package from `gclient sync` | `third_party/ninja/ninja --version` |
| Clang and toolchains | upstream DEPS | provisioned only when required | no host installation |
| GNU tar | runner | system package | `tar --version` |
| Zstandard | runner | system package | `zstd --version` |
| Network | runner | outbound HTTPS | GitHub, googlesource, GCS, and CIPD endpoints |
| gclient tree cache | workflow | `actions/cache`, keyed by `upstream` + `scripts/build.sh` | cache hit log on Restore gclient tree |
| Docker | none | deferred | not used in Phase 1 |

Do not install Node, GN, Ninja, or Clang separately. Host copies can silently
diverge from the versions expected by the pinned DevTools revision.
