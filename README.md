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

`curl.exe`, not `curl`. Windows 11 `tar` reads `.zst`; Windows 10 may not

```sh
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

`open -a "Google Chrome"` drops extra flags unless you pass `--args`, and it still reuses a running Chrome

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
> Windows `Set-Alias` cannot pass arguments. `$PROFILE` is the file (same role as `~/.bashrc`)
> PowerShell 7: `Documents\PowerShell\Microsoft.PowerShell_profile.ps1`
> Windows PowerShell 5.1: `Documents\WindowsPowerShell\`
> Print it with `$PROFILE`. Create it if missing, paste a function, then reload:
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
> Builds follow Chrome Stable. Compare the version on the [release](https://github.com/metaory/devtools-frontend-custom/releases/latest) to yours at `chrome://version`
> A large major gap might cause issues.

---

## Development

Theme is `theme.css`. Overlay it onto a built frontend and launch Chromium:

```sh
./scripts/development.sh
```

> [!WARNING]
> `gh` must be authenticated. First run downloads the latest Build artifact to `/tmp/devtools-frontend.tar.zst`, extracts to `~/.local/share/chromium`, concatenates `theme.css` onto `design_system_tokens.css`, then opens Chromium with `--custom-devtools-frontend` and `--user-data-dir=/tmp/chromium-custom`.

> [!NOTE]
> Edit `theme.css`, re-run, reload DevTools. If that profile is already running, the script only reapplies the theme.

> [!NOTE]
>
> ```sh
> ./scripts/development.sh -f                 # download even if the tar exists
> ./scripts/development.sh /path/to.tar.zst   # use a local archive
> ```

> [!NOTE]
> Full `gn`/`ninja` rebuilds (`scripts/build.sh`) run in CI. No local DevTools checkout needed.

---

## License

This project is based on [Chromium DevTools](https://github.com/ChromeDevTools/devtools-frontend)
and is distributed under the [BSD-3-Clause](LICENSE) license.

The release archive contains a modified build of the Chromium DevTools frontend
and includes the upstream license and third-party notices.
