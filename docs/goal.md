# devtools-frontend-custom

## References

- [docker guide](https://github.com/chromium/chromium/blob/main/docs/linux/build_instructions.md#docker)
- [devtools-github-mirror](https://github.com/ChromeDevTools/devtools-frontend)
- [devtools build steps](https://chromium.googlesource.com/devtools/devtools-frontend/+/main/docs/get_the_code.md)
- [incomplete dockerfile](https://chromium.googlesource.com/infra/infra/+/refs/heads/main/rbe/images/siso-chromium/linux/Dockerfile)

---

## 1. Keep the repository small

The GitHub repository contains only our customization and build tooling:

```text
devtools-frontend-custom/
├── upstream
├── theme.css
├── scripts/
│   └── build.sh
└── .github/workflows/
    └── build.yml


---

GitHub Actions / Ubuntu 22.04
├── Python 3.11
├── system Git
├── depot_tools
└── gclient-provisioned Node / GN / Ninja

---

gclient sync
buildtools/linux64/gn gen out/Default
third_party/ninja/ninja -C out/Default

---

ChromeDevTools/devtools-frontend
       +
pinned commit
       +
our theme / patches
       ↓
custom DevTools source
       ↓
out/Default/gen/front_end/
       ↓
front_end/
       ↓
.tar.zst / .zip
       ↓
GitHub Release

```

## Version releases against upstream

Each release records:

- Custom DevTools version
- Upstream DevTools commit
- Compatible Chromium version

Example

- v1.0.0
- Upstream: <commit>
- Chromium: <version>

## Automate upstream updates later

```
check upstream
    ↓
select new revision
    ↓
apply customization
    ↓
build
    ↓
test
    ↓
create release
```

---

Goal: keep the source repository tiny, let GitHub Actions handle the expensive build, and distribute only the prebuilt custom DevTools frontend.
