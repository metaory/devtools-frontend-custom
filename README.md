#

<div align="center">
  <h1>Custom DevTools Frontend</h1>
  A custom Chromium DevTools frontend distribution
</div>

---

## Use a release

Grab `devtools-frontend.tar.zst` from the
[latest GitHub Release](https://github.com/metaory/devtools-frontend-custom/releases/latest).
The archive is `front_end/` plus the upstream license. It is not stored in git.

```sh
gh release download -R metaory/devtools-frontend-custom \
  -p 'devtools-frontend.tar.zst'
tar -xaf devtools-frontend.tar.zst
```

or:

```sh
curl -fsSL -O \
  https://github.com/metaory/devtools-frontend-custom/releases/latest/download/devtools-frontend.tar.zst
tar -xaf devtools-frontend.tar.zst
```

Until a release is published, each green CI run force-pushes tag
[`nightly`](https://github.com/metaory/devtools-frontend-custom/tags)
and uploads the same archive as a workflow artifact. Promote `nightly` to a
GitHub Release when you want it on the releases page.

```sh
# latest CI artifact
gh run download -R metaory/devtools-frontend-custom -n devtools-frontend.tar.zst
tar -xaf devtools-frontend.tar.zst
```

Point Chrome or Chromium at the extracted `front_end` with
`--custom-devtools-frontend`. Needs Chromium 79+.

The path must be absolute. On Linux and macOS the `file://` URL starts with
three slashes (`file:///home/...`). Use a dedicated `--user-data-dir` so an
already running browser does not ignore the flag.

Match the Chromium version listed on the release or the upstream pin in
`upstream`.

### Chromium, throwaway profile

```sh
chromium \
  --user-data-dir="$(mktemp -d)" \
  --no-first-run \
  --custom-devtools-frontend="file://$(realpath front_end)"
```

Open DevTools with F12. The custom theme should be visible immediately.

### Chrome, persistent profile, open a page

```sh
google-chrome-stable \
  --user-data-dir="$HOME/.cache/devtools-custom" \
  --no-first-run \
  --custom-devtools-frontend="file://$(realpath front_end)" \
  https://example.com
```

Reuse the same profile later. Chrome binary names vary: `google-chrome`,
`google-chrome-stable`, or `/opt/google/chrome/chrome`.

### Chromium, auto-open DevTools

```sh
chromium \
  --user-data-dir="$(mktemp -d)" \
  --auto-open-devtools-for-tabs \
  --custom-devtools-frontend="file://$(realpath front_end)" \
  about:blank
```

### Chrome, serve the frontend over HTTP

```sh
caddy file-server --listen :8000 --root front_end
```

```sh
google-chrome-stable \
  --user-data-dir="$HOME/.cache/devtools-custom-http" \
  --custom-devtools-frontend=http://127.0.0.1:8000/
```

Any static file server works. The URL must end with `/` and serve
`inspector.html` at that root.

### Chromium, remote debugging

```sh
chromium \
  --user-data-dir="$(mktemp -d)" \
  --remote-debugging-port=9222 \
  --custom-devtools-frontend="file://$(realpath front_end)"
```

Then inspect from `chrome://inspect` in another window.

### macOS Chrome

```sh
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  --user-data-dir="$(mktemp -d)" \
  --custom-devtools-frontend="file://$(realpath front_end)"
```

Chromium.app is the same flag, different binary:

```sh
"/Applications/Chromium.app/Contents/MacOS/Chromium" \
  --user-data-dir="$(mktemp -d)" \
  --custom-devtools-frontend="file://$(realpath front_end)"
```

---

## License

[BSD-3-Clause](LICENSE)
