<div align="center">
  <h1>devtools theme</h1>
  <img src=".github/assets/banner.png" width="80%" />
  <br>
  <h3>DevTools theme <br> for Chromium-based browsers</h3>
  <br>
  <!-- screenshots -->
  <img src="https://raw.githubusercontent.com/metaory/devtools-theme/screenshots/screenshot-1.png" width="40%" />&nbsp;&nbsp;<img src="https://raw.githubusercontent.com/metaory/devtools-theme/screenshots/screenshot-2.png" width="40%" />
  <br>
  <br>
  <img src="https://raw.githubusercontent.com/metaory/devtools-theme/screenshots/screenshot-3.png" width="40%" />&nbsp;&nbsp;<img src="https://raw.githubusercontent.com/metaory/devtools-theme/screenshots/screenshot-4.png" width="40%" />
  <!-- /screenshots -->
</div>

---

> [!WARNING]
> 🚧WORK IN PROGRESS!

---

## Download a release

Grab `devtools-frontend.tar.zst` from the [latest GitHub Release](https://github.com/metaory/devtools-theme/releases/latest)

The archive contains the built `front_end/` and applicable upstream and third-party license notices

> [!NOTE]
> Each build is the DevTools branch for current [Chrome Stable](https://chromiumdash.appspot.com/releases?platform=Linux)

> [!NOTE]
> Download latest release:
>
> ```sh
> gh release download -R metaory/devtools-theme \
>   -p 'devtools-frontend.tar.zst'
> ```
>
> or:
>
> ```sh
> curl -fsSL -O \
>   https://github.com/metaory/devtools-theme/releases/latest/download/devtools-frontend.tar.zst
> ```
>
> PowerShell 5 aliases `curl` to `Invoke-WebRequest`. Use `curl.exe`.

You can place it anywhere

### Linux

```sh
mkdir -p "$HOME/.local/share/chromium"
tar -xaf devtools-frontend.tar.zst -C "$HOME/.local/share/chromium"
```

### macOS

`brew install zstd`

Apple's `tar` has no `zstd` codec

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
> You can make DevTools open on startup with:
> `--auto-open-devtools-for-tabs`

### Linux

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
> --user-data-dir="$HOME/.config/chromium-custom"
> ```

#### Alias

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
> alias chromium='command chromium --custom-devtools-frontend="file://$HOME/.local/share/chromium/front_end"'
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
> Compare the version on the [release](https://github.com/metaory/devtools-theme/releases/latest) to yours at `chrome://version`
> A large major gap might cause issues

---

## Forks

> [!NOTE]
> Fork on GitHub, clone yours, enable **Actions** (disabled on new forks).
> Point [`scripts/development.sh`](scripts/development.sh) at your repo:
>
> ```sh
> readonly repo='you/devtools-thene'
> ```

> [!NOTE]
> First compile: **Actions → Build → Run workflow**, or push `theme.css`.
> Wait for the artifact `devtools-frontend.tar.zst`.

> [!TIP]
> `workflow_dispatch` only exists on the default branch.

> [!NOTE]
> CI bakes the defaults from [`scripts/overlay.sh`](scripts/overlay.sh) into the artifact.
> Push and the Monday cron have no inputs, so they always get those defaults.
> A manual Run workflow can override hues for that run

---

## Development

Modify is `theme.css`

> [!NOTE]
> With hue and sat overrides:
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
> If that profile is already running
> the script only reapplies the theme. Fetch, extract, and launch are the same as before.

> [!NOTE]
>
> ```sh
> ./scripts/development.sh -f               # download even if the tar exists
> ./scripts/development.sh /path/to.tar.zst # use a local archive
> ```

> [!NOTE]
> Full `gn`/`ninja` rebuilds (`scripts/build.sh`) run in CI.
> No local DevTools checkout need

> [!TIP]
> `SAT` is 0-100. 50 is the current ramp, 0 is gray, 100 is 2x chroma
> `SPREAD` is the chrome family offset from `HUE` (secondary `+spread`, tertiary `+2*spread`)

---

## License

This project is based on [Chromium DevTools](https://github.com/ChromeDevTools/devtools-frontend)
and is distributed under the [BSD-3-Clause](LICENSE) license.

The release archive contains a modified build of the Chromium DevTools frontend
and includes the upstream license and third-party notices.
