<div align="center">
  <h3>A Custom<br>DevTools theme <br> for Chromium-based browsers</h3>
  <br>
  <img src=".github/assets/banner.png" width="60%" />
  <br>
  <br>
  <img src="https://raw.githubusercontent.com/metaory/devtools-theme/screenshots/screenshot-0.png" width="90%" />
  <br>
  <br>
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
  <a href="#install">Install</a> · <a href="#alias">Alias</a> · <a href="#customize">Customize</a> · <a href="#troubleshoot">Troubleshoot</a> · <a href="#fork">Fork</a>
  <br>
  <br>
  <p>
    <a href="https://github.com/metaory/devtools-theme/releases/latest"><img src="https://img.shields.io/github/v/release/metaory/devtools-theme?label=release" alt="latest release" /></a>
    <a href="LICENSE"><img src="https://img.shields.io/badge/license-BSD--3--Clause-blue" alt="BSD-3-Clause" /></a>
  </p>
</div>

---

A custom DevTools UI for Chrome, Chromium, Brave, Edge, and other Chromium-based browsers

Chrome's `--custom-devtools-frontend` points at a local `front_end` path. This repo ships a themed DevTools build for that flag. Releases track Chrome **stable**

---

## Install

1. Quit Chrome completely if it is already running
2. Download `devtools-frontend.tar.zst` from the [latest release](https://github.com/metaory/devtools-theme/releases/latest)
3. Extract and launch per OS below
4. Open DevTools (F12). UI should match the screenshots above

```sh
gh release download -R metaory/devtools-theme \
  -p 'devtools-frontend.tar.zst'
```

```sh
curl -fsSL -O \
  https://github.com/metaory/devtools-theme/releases/latest/download/devtools-frontend.tar.zst
```

To update later: download the newest release and extract into the same directory again

For every launch after this, use an [Alias](#alias)

Other Chromium browsers (Brave, Edge, …): same `--custom-devtools-frontend` flag and `file://…/front_end` path; swap only the binary name

> [!TIP]
> Open DevTools on startup with `--auto-open-devtools-for-tabs`

### Linux

1. Extract:

```sh
mkdir -p "$HOME/.local/share/chromium"
tar -xaf devtools-frontend.tar.zst -C "$HOME/.local/share/chromium"
```

If extract fails, install `zstd`, or use: `zstd -dc devtools-frontend.tar.zst | tar -xf - -C "$HOME/.local/share/chromium"`

2. Launch:

```sh
chromium --custom-devtools-frontend="file://$HOME/.local/share/chromium/front_end"
# or
google-chrome --custom-devtools-frontend="file://$HOME/.local/share/chromium/front_end"
# brave-browser / microsoft-edge: same flag and path
```

### macOS

Same install path as Linux (`$HOME/.local/share/chromium`), not `~/Library/...`

1. Install `zstd`:

```sh
brew install zstd
```

2. Extract:

```sh
mkdir -p "$HOME/.local/share/chromium"
zstd -dc devtools-frontend.tar.zst | tar -xf - -C "$HOME/.local/share/chromium"
```

3. Launch:

```sh
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  --custom-devtools-frontend="file://$HOME/.local/share/chromium/front_end"
```

### Windows

Use Windows 11 (`tar` reads `.zst`)

1. Download with `curl.exe`:

```sh
curl.exe -fsSL -O https://github.com/metaory/devtools-theme/releases/latest/download/devtools-frontend.tar.zst
```

2. Extract:

```sh
mkdir -Force "$env:LOCALAPPDATA\chromium"
tar -xaf devtools-frontend.tar.zst -C "$env:LOCALAPPDATA\chromium"
```

3. Launch:
   - `PowerShell`:

     ```sh
     & "C:\Program Files\Google\Chrome\Application\chrome.exe" `
       --custom-devtools-frontend="file:///$($env:LOCALAPPDATA -replace '\\','/')/chromium/front_end"
     ```

   - `cmd`:

     ```sh
     "C:\Program Files\Google\Chrome\Application\chrome.exe" --custom-devtools-frontend=file:///%LOCALAPPDATA%/chromium/front_end
     ```

---

## Alias

Add `--custom-devtools-frontend` on every Chrome launch so the theme sticks

> [!IMPORTANT]
>
> - Use a `file://` URL to the extracted `front_end` directory
> - Linux and macOS: `file:///home/...` (three slashes). Windows: `file:///` plus a forward-slash path
> - Without the `file://` scheme, Chrome loads the bundled DevTools

> [!NOTE]
>
> - A new launch reuses a running Chrome and ignores extra flags
> - Quit Chrome completely and relaunch, or add `--user-data-dir` with a separate profile

### Linux

> [!CAUTION]
>
> Write the right-hand side with `command chromium`, `\chromium`, or a full path like `/usr/bin/chromium`
> An alias that calls `chromium` by name loops forever

1. Add to `~/.bashrc` or `~/.zshrc`:

```sh
alias chromium='command chromium --custom-devtools-frontend="file://$HOME/.local/share/chromium/front_end"'
# or: alias chromium='\chromium --custom-devtools-frontend="file://$HOME/.local/share/chromium/front_end"'
# or: alias chromium='/usr/bin/chromium --custom-devtools-frontend="file://$HOME/.local/share/chromium/front_end"'
alias chrome='google-chrome --custom-devtools-frontend="file://$HOME/.local/share/chromium/front_end"'
```

2. Reload the shell
3. Launch with `chromium` or `chrome`

Optional separate profile: `--user-data-dir="$HOME/.config/chromium-custom"`

### macOS

1. Add to `~/.zshrc`:

```sh
alias chrome='"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --custom-devtools-frontend="file://$HOME/.local/share/chromium/front_end"'
```

2. Reload the shell
3. Launch with `chrome`

Optional separate profile: `--user-data-dir="$HOME/.config/chromium-custom"`

> [!TIP]
> Prefer the binary path above. `open -a "Google Chrome"` needs `--args` for flags, and still reuses a running Chrome

### Windows

> [!WARNING]
>
> - Use a function in `$PROFILE` (print the path with `$PROFILE`)
> - `Set-Alias` cannot pass arguments
> - `PowerShell 7`: `Documents\PowerShell\Microsoft.PowerShell_profile.ps1`
> - Windows `PowerShell 5.1`: `Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1`

1. Create or open your profile:

```sh
if (!(Test-Path $PROFILE)) { New-Item $PROFILE -Force }
notepad $PROFILE
```

2. Add:

```sh
function chrome {
  & "C:\Program Files\Google\Chrome\Application\chrome.exe" `
    --custom-devtools-frontend="file:///$($env:LOCALAPPDATA -replace '\\','/')/chromium/front_end" @args
}
```

3. Allow the profile and load it:

```sh
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
. $PROFILE
```

4. Launch with `chrome`

Optional separate profile: `--user-data-dir="$env:LOCALAPPDATA\chromium-custom"`

---

## Customize

Change colors on your machine

1. Clone the repo:

```sh
git clone https://github.com/metaory/devtools-theme.git
cd devtools-theme
```

2. Edit [`config.css`](config.css):

- `--hue`
- `--sat-in` (0 gray, 50 default ramp, 100 ≈ 2× chroma)
- `--spread` (secondary `+spread`, tertiary `+2*spread` from `--hue`)
- `--hue-error`, `--hue-blue`, `--hue-cyan`, `--hue-pink`, `--hue-green`, `--hue-orange`, `--hue-yellow`

3. Requirements: `bash`, `curl`, `tar`, `sed`

- macOS: `brew install zstd`
- Windows: run from Git Bash; Windows 11 `tar` reads `.zst`

4. Run `./apply` to put your config on the install:

```sh
./apply                         # overlay; if install missing, download archive and extract
./apply -f                      # download latest archive, extract, overlay
./apply -o                      # overlay, then open Chrome
./apply /path/to.tar.zst        # if install missing, extract this archive (must exist)
./apply -f -o /path/to.tar.zst  # download latest into this archive file, extract, overlay, open Chrome
```

Installed path:

- Linux / macOS: `$HOME/.local/share/chromium`
- Windows: `%LOCALAPPDATA%/chromium`

First run downloads `devtools-frontend.tar.zst` to `$TMPDIR` (usually `/tmp`)

> [!NOTE]
>
> - Without `-o`, `./apply` prints the `file://` launch line
> - With `-o`, launch is skipped if Chrome is already running

5. For deeper changes, edit [`theme.css`](theme.css) (palette) or [`inspector.css`](inspector.css) (checkbox fill), then `./apply` again

> [!TIP]
> To pull a newer release onto an existing install: `./apply -f`

---

## Troubleshoot

- Theme missing after launch: check the `file://` URL, quit Chrome completely, relaunch. See [Install](#install) and [Alias](#alias)
- Launch ignores the flag: Chrome was already running. Quit it, or use `--user-data-dir` with a separate profile
- Odd UI: compare the [release](https://github.com/metaory/devtools-theme/releases/latest) version to `chrome://version`. A large major gap can break things
- macOS extract fails: install `zstd` (`brew install zstd`), then extract again
- Linux extract fails: install `zstd`, or use the `zstd -dc … | tar` form under [Install](#install)
- Windows download fails in `PowerShell`: use `curl.exe`, not `curl`
- Windows extract fails: use Windows 11, or install a `tar` that reads `.zst`
- `./apply` says missing archive: run it from the repo root, or pass a path to the `.tar.zst`
- Undo: remove the alias or PowerShell function, delete `$HOME/.local/share/chromium/front_end` (Windows: `%LOCALAPPDATA%\chromium\front_end`), relaunch without the flag

---

## Fork

Publish your own themed release

See [docs/release-flow.md](docs/release-flow.md) for the full Build → nightly → Release path

1. Fork on GitHub
2. Clone your fork:

```sh
git clone https://github.com/you/devtools-theme.git
cd devtools-theme
```

3. Enable **Actions** (new forks start with Actions off)
4. Point [`apply`](apply) at your repo:

```sh
readonly repo='you/devtools-theme'
```

5. Push `config.css`, `theme.css`, or `inspector.css`, or run **Actions → Build → Run workflow**
6. Wait until Build is green and `nightly` moved
7. Run **Actions → Release → Run workflow**, then publish the draft release that lists `devtools-frontend.tar.zst`
8. Run `./apply -f`

---

## License

This project is based on [Chromium DevTools](https://github.com/ChromeDevTools/devtools-frontend)
and is distributed under the [BSD-3-Clause](LICENSE) license

The release archive contains a modified build of the Chromium DevTools UI
and includes the upstream license and third-party notices
