<div align="center">
  <h1>DevTools Theme</h1>
  <img src=".github/assets/banner.png" width="80%" />
  <br>
  <h3>DevTools theme <br> for Chromium-based browsers</h3>
  <br>
  <img src="https://raw.githubusercontent.com/metaory/devtools-theme/screenshots/screenshot-0.png" width="90%" />
  <!-- screenshots -->
  <img src="https://raw.githubusercontent.com/metaory/devtools-theme/screenshots/screenshot-1.png" width="40%" />&nbsp;&nbsp;<img src="https://raw.githubusercontent.com/metaory/devtools-theme/screenshots/screenshot-2.png" width="40%" />
  <br>
  <br>
  <img src="https://raw.githubusercontent.com/metaory/devtools-theme/screenshots/screenshot-3.png" width="40%" />&nbsp;&nbsp;<img src="https://raw.githubusercontent.com/metaory/devtools-theme/screenshots/screenshot-4.png" width="40%" />
  <br>
  <br>
  <img src="https://raw.githubusercontent.com/metaory/devtools-theme/screenshots/screenshot-5.png" width="40%" />&nbsp;&nbsp;<img src="https://raw.githubusercontent.com/metaory/devtools-theme/screenshots/screenshot-6.png" width="40%" />
  <!-- /screenshots -->
</div>

---

<div align="center">
<a href="#usage">Usage</a> · <a href="#manual-installation">Manual installation</a> · <a href="#troubleshoot">Troubleshoot</a> · <a href="#forks">Forks</a>
</div>

---

## Usage

Clone this repo. Edit [`config.css`](config.css) (`--hue`, `--sat-in`, `--spread`, `--hue-*`), then `./apply`.

`--sat-in` is 0-100. 50 is the current ramp, 0 is gray, 100 is 2x chroma.
`--spread` offsets the chrome family from `--hue` (secondary `+spread`, tertiary `+2*spread`).

```sh
./apply                         # overlay; download and extract if frontend is missing
./apply -f                      # fetch latest release, extract, overlay
./apply -o                      # overlay, then open Chrome
./apply /path/to.tar.zst        # overlay; extract this archive only if frontend is missing
./apply -f -o /path/to.tar.zst  # download into this path, extract, overlay, open Chrome
```

Needs `bash`, `curl`, `tar`, `sed`. First run downloads `devtools-frontend.tar.zst` to `$TMPDIR` (usually `/tmp`).

- Linux: dest `$HOME/.local/share/chromium`
- macOS: same dest. `brew install zstd`
- Windows: Git Bash, not PowerShell. dest `%LOCALAPPDATA%/chromium`. Windows 11 `tar` reads `.zst`

Without `-o`, `apply` prints the `file://` launch line. `-o` skips exec if Chrome is already running.

For more than hue and sat, edit [`theme.css`](theme.css) (palette formulas from those vars). [`inspector.css`](inspector.css) is checkbox fill. `./apply` overlays those too.

### Alias

Chrome must get `--custom-devtools-frontend` on every launch. Put it in a shell alias (or PowerShell function).

> [!IMPORTANT]
> The flag value must be a `file://` URL to the extracted `front_end` directory, not a bare path. Linux and macOS: `file:///home/...` (three slashes). Windows: `file:///` plus a forward-slash path.
> A path without the scheme is ignored and Chrome loads the bundled DevTools.

> [!NOTE]
> If Chrome is already running, a new launch reuses that process and ignores extra flags.
> Quit Chrome completely and relaunch, or add `--user-data-dir` with a separate profile.

#### Linux

> [!CAUTION]
> Do not write `alias chromium='chromium --custom-devtools-frontend=...'`
> The name calls itself and the shell loops.
> Skip the alias on the right-hand side: `\chromium` or `command chromium`, or a full path like `/usr/bin/chromium`.

```sh
# ~/.bashrc or ~/.zshrc
alias chromium='command chromium --custom-devtools-frontend="file://$HOME/.local/share/chromium/front_end"'
alias chrome='google-chrome --custom-devtools-frontend="file://$HOME/.local/share/chromium/front_end"'
```

Separate profile: `--user-data-dir="$HOME/.config/chromium-custom"`

#### macOS

```sh
# ~/.zshrc
alias chrome='"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --custom-devtools-frontend="file://$HOME/.local/share/chromium/front_end"'
```

Separate profile: `--user-data-dir="$HOME/.config/chromium-custom"`

> [!TIP]
> `open -a "Google Chrome"` drops extra flags unless you pass `--args`, and it still reuses a running Chrome.

#### Windows

> [!WARNING]
> `Set-Alias` cannot pass arguments. Use a function in `$PROFILE` (print the path with `$PROFILE`).
> PowerShell 7: `Documents\PowerShell\Microsoft.PowerShell_profile.ps1`
> Windows PowerShell 5.1: `Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1`

```powershell
if (!(Test-Path $PROFILE)) { New-Item $PROFILE -Force }
notepad $PROFILE
```

```powershell
function chrome {
  & "C:\Program Files\Google\Chrome\Application\chrome.exe" `
    --custom-devtools-frontend="file:///$($env:LOCALAPPDATA -replace '\\','/')/chromium/front_end" @args
}
```

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
. $PROFILE
```

Separate profile: `--user-data-dir="$env:LOCALAPPDATA\chromium-custom"`

---

## Manual installation

Download the prebuilt `devtools-frontend.tar.zst` from the [latest GitHub Release](https://github.com/metaory/devtools-theme/releases/latest). Extract it, then launch with `--custom-devtools-frontend` (or the [alias](#alias) above). No clone. No `apply`.

Each build is the DevTools frontend for current [Chrome Stable](https://chromiumdash.appspot.com/releases?platform=Linux).

```sh
gh release download -R metaory/devtools-theme \
  -p 'devtools-frontend.tar.zst'
```

```sh
curl -fsSL -O \
  https://github.com/metaory/devtools-theme/releases/latest/download/devtools-frontend.tar.zst
```

> [!TIP]
> Open DevTools on startup with `--auto-open-devtools-for-tabs`.

### Linux

```sh
mkdir -p "$HOME/.local/share/chromium"
tar -xaf devtools-frontend.tar.zst -C "$HOME/.local/share/chromium"

chromium --custom-devtools-frontend="file://$HOME/.local/share/chromium/front_end"
google-chrome --custom-devtools-frontend="file://$HOME/.local/share/chromium/front_end"
```

### macOS

Apple's `tar` has no `zstd` codec. `brew install zstd`.

```sh
mkdir -p "$HOME/.local/share/chromium"
zstd -dc devtools-frontend.tar.zst | tar -xf - -C "$HOME/.local/share/chromium"

"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  --custom-devtools-frontend="file://$HOME/.local/share/chromium/front_end"
```

### Windows

Windows 11 `tar` extracts `.zst`. Windows 10 `tar` often cannot.

PowerShell 5 aliases `curl` to `Invoke-WebRequest`. Download with `curl.exe`:

```powershell
curl.exe -fsSL -O https://github.com/metaory/devtools-theme/releases/latest/download/devtools-frontend.tar.zst

mkdir -Force "$env:LOCALAPPDATA\chromium"
tar -xaf devtools-frontend.tar.zst -C "$env:LOCALAPPDATA\chromium"

& "C:\Program Files\Google\Chrome\Application\chrome.exe" `
  --custom-devtools-frontend="file:///$($env:LOCALAPPDATA -replace '\\','/')/chromium/front_end"
```

```cmd
"C:\Program Files\Google\Chrome\Application\chrome.exe" --custom-devtools-frontend=file:///%LOCALAPPDATA%/chromium/front_end
```

---

## Troubleshoot

Builds follow Chrome Stable. Compare the version on the [release](https://github.com/metaory/devtools-theme/releases/latest) to yours at `chrome://version`. A large major gap might cause issues.

If Chrome ignores `--custom-devtools-frontend`, the URL is wrong or Chrome is already running. See [Usage](#usage) and [Manual installation](#manual-installation).

---

## Forks

Fork on GitHub, clone yours, enable **Actions** (disabled on new forks). Point [`apply`](apply) at your repo:

```sh
readonly repo='you/devtools-theme'
```

> [!NOTE]
>
> - First compile: **Actions → Build → Run workflow**, or push `apply` / `config.css` / `theme.css` / `inspector.css`
> - Wait for a GitHub **Release** asset `devtools-frontend.tar.zst`. `./apply -f` downloads that Release, not the Actions artifact
> - To try a Build before you publish, download the workflow artifact and `./apply /path/to.tar.zst`
> - `workflow_dispatch` exists only on the default branch
> - Fork to change `theme.css`, `inspector.css`, or the Chrome channel. Re-tint locally by editing [`config.css`](config.css) then `./apply`
> - CI bakes `config.css` into the artifact. Push and the Monday cron have no workflow inputs, so they use those numbers
> - A manual Run workflow can override hue inputs for that run only.

---

## License

This project is based on [Chromium DevTools](https://github.com/ChromeDevTools/devtools-frontend)
and is distributed under the [BSD-3-Clause](LICENSE) license.

The release archive contains a modified build of the Chromium DevTools frontend
and includes the upstream license and third-party notices.
