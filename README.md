<div align="center">
  <h1>Custom DevTools Frontend</h1>
  <img src=".github/assets/banner.jpg" width="75%" />
  A custom Chromium DevTools frontend distribution
</div>

---

## Download a release

Grab `devtools-frontend.tar.zst` from the [latest GitHub Release](https://github.com/metaory/devtools-frontend-custom/releases/latest).

The archive contains the built `front_end/` and applicable upstream and third-party license notices.

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

```sh
# You can place it anywhere
mkdir -p "$HOME/.local/share/chromium"
tar -xaf devtools-frontend.tar.zst -C "$HOME/.local/share/chromium"
```

> [!TIP]
> You can launch chrome/chromium with a different user profile with this argument:
> `--user-data-dir="$HOME/.config/chromium-custom"`

---

## Usage

```sh
{chrome/chromium} --custom-devtools-frontend="{PATH}"
```

For example:

```sh
chromium --custom-devtools-frontend="$HOME/.local/share/chromium/front_end"
chrome --custom-devtools-frontend="$HOME/.local/share/chromium/front_end"
google-chrome --custom-devtools-frontend="$HOME/.local/share/chromium/front_end"
```

Or create alias in your shell:

```sh
# ~/.bashrc or ~/.zshrc
alias chrome='google-chrome --custom-devtools-frontend="$HOME/.local/share/chromium/front_end"'
```

> [!CAUTION]
> Do not write `alias chromium='chromium --custom-devtools-frontend=...'`
> The name calls itself and the shell loops
> To reuse the same name, skip the alias on the right-hand side: `\chromium` or `command chromium`
> or a full path like `/usr/bin/chromium`

```sh
# ~/.bashrc or ~/.zshrc
alias chromium='/usr/binchromium --custom-devtools-frontend="$HOME/.local/share/chromium/front_end"'
alias chromium='command chromium --custom-devtools-frontend="$HOME/.local/share/chromium/front_end"'
alias chromium='\chromium --custom-devtools-frontend="$HOME/.local/share/chromium/front_end"'
```

<!--

HTTP instead of a local path. The URL must end with `/` and serve
`inspector.html` at that root:
```sh
caddy file-server --listen :8000 --root "$HOME/.local/share/chromium/front_end"
chromium \
  --user-data-dir="$HOME/.config/chromium-custom" \
  --custom-devtools-frontend=http://127.0.0.1:8000/
```

```sh
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  --user-data-dir="$HOME/.config/chrome-custom" \
  --no-first-run \
  --custom-devtools-frontend="$HOME/.local/share/chromium/front_end"
```
-->

---

## Troubleshoot

> [!NOTE]
> Check the Chromium version listed on the release or the pin in `upstream`.
> A version update might be the culprit

---

## License

This project is based on [Chromium DevTools](https://github.com/ChromeDevTools/devtools-frontend)
and is distributed under the [BSD-3-Clause](LICENSE) license.

The release archive contains a modified build of the Chromium DevTools frontend
and includes the upstream license and third-party notices.
