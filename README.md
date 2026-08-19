<div align="center">
  <h3>Custom DevTools Frontend</h3>
  <img src=".github/assets/banner.png" width="80%" />
  <br>
  <h5>A custom Chromium DevTools frontend distribution<h5>
</div>

<div align="center">
  <img src=".github/assets/screenshot-dark.png" width="80%" />
  <img src=".github/assets/screenshot-light.png" width="80%" />
</div>
<div align="center">
  <img src=".github/assets/screenshot-dark-270.png" width="24%" />
  <img src=".github/assets/screenshot-dark-180.png" width="24%" />
  <img src=".github/assets/screenshot-dark-90.png" width="24%" />
  <img src=".github/assets/screenshot-dark-0.png" width="24%" />
  <br>
  <img src=".github/assets/screenshot-light-270.png" width="24%" />
  <img src=".github/assets/screenshot-light-180.png" width="24%" />
  <img src=".github/assets/screenshot-light-90.png" width="24%" />
  <img src=".github/assets/screenshot-light-0.png" width="24%" />
</div>

---

> [!WARNING]
> 🚧WORK IN PROGRESS!

---

## Download a release

Grab `devtools-frontend.tar.zst` from the [latest GitHub Release](https://github.com/metaory/devtools-frontend-custom/releases/latest)

The archive contains the built `front_end/` and applicable upstream and third-party license notices

> [!NOTE]
> Each build is the DevTools branch for current [Chrome Stable](https://chromiumdash.appspot.com/releases?platform=Linux)

> [!NOTE]
> Download latest release:
>
> ```sh
> gh release download -R metaory/devtools-frontend-custom \
>   -p 'devtools-frontend.tar.zst'
> ```
>
> or:
>
> ```sh
> curl -fsSL -O \
>   https://github.com/metaory/devtools-frontend-custom/releases/latest/download/devtools-frontend.tar.zst
> ```
>
> PowerShell 5 aliases `curl` to `Invoke-WebRequest`. Use `curl.exe`.

You can place it anywhere

### Linux:

```sh
mkdir -p "$HOME/.local/share/chromium"
tar -xaf devtools-frontend.tar.zst -C "$HOME/.local/share/chromium"
```

### macOS

`brew install zstd`; Apple's `tar` has no `zstd` codec

```sh
mkdir -p "$HOME/.local/share/chromium"
zstd -dc devtools-frontend.tar.zst | tar -xf - -C "$HOME/.local/share/chromium"
```

### Windows

Windows 11 `tar` extracts `.zst`. Windows 10 `tar` often cannot.

```powershell
mkdir -Force "$env:LOCALAPPDATA\chromium"
tar -xaf devtools-frontend.tar.zst -C "$env:LOCALAPPDATA\chromium"
```

---

## Usage

```sh
{chrome/chromium} --custom-devtools-frontend="file://{PATH}"
```

> [!IMPORTANT]
> The value must be a `file://` URL, not a bare path. On Linux and macOS it starts with three slashes: `file:///home/...`
> A path without the scheme is ignored and Chrome loads the bundled DevTools

> [!NOTE]
> If Chrome/Chromium is already running, a new launch reuses that process and ignores extra flags
> Quit Chrome completely and relaunch, or use a separate `--user-data-dir`

> [!TIP]
> You can make the DevTool opens on startup with:
> `--auto-open-devtools-for-tabs`

### Linux:

> [!NOTE]
> With a Chrome/Chromium with custom DevTools:
>
> ```sh
> chromium --custom-devtools-frontend="file://$HOME/.local/share/chromium/front_end"
> chrome --custom-devtools-frontend="file://$HOME/.local/share/chromium/front_end"
> google-chrome --custom-devtools-frontend="file://$HOME/.local/share/chromium/front_end"
> ```

> [!NOTE]
> With a custom user profile:
>
> ```sh
> --user-data-dir="$HOME/.config/chromium-custom"`
> ```

#### Alias:

> [!CAUTION]
>
> Do not write `alias chromium='chromium --custom-devtools-frontend=...'`
> The name calls itself and the shell loops!
> To reuse the same name, skip the alias on the right-hand side: `\chromium` or `command chromium`
> or a full path like `/usr/bin/chromium`

> [!NOTE]
> With alias:
>
> ```sh
> # ~/.bashrc or ~/.zshrc
> alias chromium='/usr/bin/chromium --custom-devtools-frontend="file://$HOME/.local/share/chromium/front_end"'
> alias chromium='command chromium --custom-devtools-frontend="file://$HOME/.local/share/chromium/front_end"'
> alias chromium='\chromium --custom-devtools-frontend="file://$HOME/.local/share/chromium/front_end"'
> alias chrome='google-chrome --custom-devtools-frontend="file://$HOME/.local/share/chromium/front_end"'
> ```

### macOS

Chrome is not on `PATH`. Launch the binary, or alias it in `~/.zshrc`:

> [!NOTE]
> With a Chrome/Chromium with custom DevTools:
>
> ```sh
> "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
>   --custom-devtools-frontend="file://$HOME/.local/share/chromium/front_end"
> ```

> [!NOTE]
> With alias:
>
> ```sh
> alias chrome='"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --custom-devtools-frontend="file://$HOME/.local/share/chromium/front_end"'
> ```

> [!NOTE]
> With a custom user profile:
>
> ```sh
> --user-data-dir="$HOME/.config/chromium-custom"
> ```

> [!TIP]
> `open -a "Google Chrome"` drops extra flags unless you pass `--args`, and it still reuses a running Chrome

### Windows

Chrome is not on `PATH`. Launch the binary:

> [!NOTE]
> With a Chrome/Chromium with custom DevTools:
>
> ```sh
> & "C:\Program Files\Google\Chrome\Application\chrome.exe" `
>   --custom-devtools-frontend="file:///$($env:LOCALAPPDATA -replace '\\','/')/chromium/front_end"
> # or:
> "C:\Program Files\Google\Chrome\Application\chrome.exe" --custom-devtools-frontend=file:///%LOCALAPPDATA%/chromium/front_end
> ```

> [!NOTE]
> With a custom user profile:
>
> ```sh
> --user-data-dir="$env:LOCALAPPDATA\chromium-custom"
> ```

> [!WARNING]
> Windows `Set-Alias` cannot pass arguments
>
> `$PROFILE` is the file (same role as `~/.bashrc`)
>
> PowerShell 7: `Documents\PowerShell\Microsoft.PowerShell_profile.ps1`
> Windows PowerShell 5.1: `Documents\WindowsPowerShell\`
> Print it with `$PROFILE`.
>
> Create it if missing, paste a function, then reload:
>
> ```sh
> # $PROFILE
> if (!(Test-Path $PROFILE)) { New-Item $PROFILE -Force }
> notepad $PROFILE
> ```

> [!NOTE]
> With a shortcut:
>
> ```sh
> function chrome {
>   & "C:\Program Files\Google\Chrome\Application\chrome.exe" `
>     --custom-devtools-frontend="file:///$($env:LOCALAPPDATA -replace '\\','/')/chromium/front_end" @args
> }
> ```
>
> ```sh
> Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
> . $PROFILE
> ```

---

## Troubleshoot

> [!NOTE]
> Builds follow Chrome Stable
> Compare the version on the [release](https://github.com/metaory/devtools-frontend-custom/releases/latest) to yours at `chrome://version`
> A large major gap might cause issues

---

## Development

Theme is `theme.css`. [`scripts/overlay.sh`](scripts/overlay.sh) substitutes knobs, appends it onto a built frontend, then launches Chromium:

> [!NOTE]
> With hue and sat overrides and `ci` action run artifact:
>
> ```sh
> ./scripts/development.sh
> HUE=200 SAT=35 ./scripts/development.sh
> ```

> [!WARNING]
> `gh` must be authenticated.
>
> ```sh
> gh auth login
> ./scripts/development.sh -f
> ```

> [!NOTE]
> First run downloads the latest Build artifact to `/tmp/devtools-frontend.tar.zst`
>
> It:
>
> - extracts to `~/.local/share/chromium`
> - strips any previous overlay at `/* === theme.css === */`
> - appends the substituted theme onto `design_system_tokens.css`

> [!NOTE]
> Edit `theme.css` or pass knobs as `env`, rerun, reload DevTools
>
> If that profile is already running
> the script would only reapplies the theme. Fetch, extract, and launch are the same as before.

> [!NOTE]
>
> ```sh
> ./scripts/development.sh -f               # download even if the tar exists
> ./scripts/development.sh /path/to.tar.zst # use a local archive
> ```

> [!NOTE]
> Full `gn`/`ninja` rebuilds (`scripts/build.sh`) run in CI. No local DevTools checkout needed.

---

## Forks

Fork on GitHub, clone yours, enable **Actions** (disabled on new forks).
Point [`scripts/development.sh`](scripts/development.sh) at your repo (`repo='you/devtools-frontend-custom'`).

> [!NOTE]
> First compile: **Actions → Build → Run workflow**, or push `theme.css`.
> Wait for the artifact `devtools-frontend.tar.zst`.

> [!TIP]
> `workflow_dispatch` only exists on the default branch.

> [!WARNING]
> `gh` must be authenticated.
>
> ```sh
> gh auth login
> ./scripts/development.sh -f
> ```

> [!TIP]
> `development.sh` pulls _your_ latest successful Build, overlays `theme.css`, and launches Chromium.
> Later theme edits are local: rerun, reload DevTools.
>
> No second CI compile.

> [!NOTE]
> Download the artifact from the run and pass it:
>
> ```sh
> ./scripts/development.sh /tmp/devtools-frontend.tar.zst
> ```

> [!NOTE]
> Knobs live in `theme.css` as `"$HUE"` placeholders.
> [`scripts/overlay.sh`](scripts/overlay.sh) substitutes them.
>
> Empty or non-digit env uses the defaults below.
> Push and the Monday cron have no inputs, so they always get those defaults.

<div align="center">

| `env`        | `default` |
| :----------- | :-------- |
| `HUE`        | 270       |
| `HUE_ERROR`  | 10        |
| `HUE_BLUE`   | 220       |
| `HUE_GREEN`  | 140       |
| `HUE_ORANGE` | 30        |
| `HUE_YELLOW` | 50        |
| `HUE_CYAN`   | 190       |
| `HUE_PINK`   | 330       |
| `SPREAD`     | 20        |
| `SAT`        | 50        |

</div>

> [!TIP]
> `SAT` is 0-100. 50 is the current ramp, 0 is gray, 100 is 2x chroma
> `SPREAD` is the chrome family offset from `HUE` (secondary `+spread`, tertiary `+2*spread`)

> [!NOTE]
> With hue and sat overrides and `ci` action run artifact:
>
> ```sh
> ./scripts/development.sh
> HUE=200 SAT=35 ./scripts/development.sh
> ```

---

## License

This project is based on [Chromium DevTools](https://github.com/ChromeDevTools/devtools-frontend)
and is distributed under the [BSD-3-Clause](LICENSE) license.

The release archive contains a modified build of the Chromium DevTools frontend
and includes the upstream license and third-party notices.
