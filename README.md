<div align="center">
  <h1>Custom DevTools Frontend</h1>
  <img src=".github/assets/banner.jpg" width="75%" />
  <br>
  <h5>A custom Chromium DevTools frontend distribution<h5>
</div>

---

> [!WARNING]
> 🚧WORK IN PROGRESS!

---

## Download a release

Grab `devtools-frontend.tar.zst` from the [latest GitHub Release](https://github.com/metaory/devtools-frontend-custom/releases/latest)

The archive contains the built `front_end/` and applicable upstream and third-party license notices

```sh
gh release download -R metaory/devtools-frontend-custom \
  -p 'devtools-frontend.tar.zst'
```

or:

```sh
curl -fsSL -O \
  https://github.com/metaory/devtools-frontend-custom/releases/latest/download/devtools-frontend.tar.zst
```

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

```powershell
mkdir -Force "$env:LOCALAPPDATA\chromium"
tar -xaf devtools-frontend.tar.zst -C "$env:LOCALAPPDATA\chromium"
```

---

## Usage

```sh
{chrome/chromium} --custom-devtools-frontend="{PATH}"
```

> [!NOTE]
> If Chrome/Chromium is already running, a new launch reuses that process and ignores extra flags
> Quit Chrome completely and relaunch, or use a separate `--user-data-dir`

### Linux:

```sh
chromium --custom-devtools-frontend="$HOME/.local/share/chromium/front_end"
chrome --custom-devtools-frontend="$HOME/.local/share/chromium/front_end"
google-chrome --custom-devtools-frontend="$HOME/.local/share/chromium/front_end"
```

With a custom user profile:

`--user-data-dir="$HOME/.config/chromium-custom"`

Or create alias in bash/zsh:

> [!CAUTION]
> Do not write `alias chromium='chromium --custom-devtools-frontend=...'`
> The name calls itself and the shell loops!
> To reuse the same name, skip the alias on the right-hand side: `\chromium` or `command chromium`
> or a full path like `/usr/bin/chromium`

```sh
# ~/.bashrc or ~/.zshrc
alias chromium='/usr/bin/chromium --custom-devtools-frontend="$HOME/.local/share/chromium/front_end"'
alias chromium='command chromium --custom-devtools-frontend="$HOME/.local/share/chromium/front_end"'
alias chromium='\chromium --custom-devtools-frontend="$HOME/.local/share/chromium/front_end"'
alias chrome='google-chrome --custom-devtools-frontend="$HOME/.local/share/chromium/front_end"'
```

### macOS

Chrome is not on `PATH`. Launch the binary, or alias it in `~/.zshrc`:

```sh
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  --custom-devtools-frontend="$HOME/.local/share/chromium/front_end"
```

```sh
alias chrome='"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --custom-devtools-frontend="$HOME/.local/share/chromium/front_end"'
```

`--user-data-dir="$HOME/.config/chromium-custom"`

`open -a "Google Chrome"` drops extra flags unless you pass `--args`, and it still reuses a running Chrome

### Windows

Chrome is not on `PATH`. Launch the binary:

```powershell
& "C:\Program Files\Google\Chrome\Application\chrome.exe" `
  --custom-devtools-frontend="$env:LOCALAPPDATA\chromium\front_end"
```

`--user-data-dir="$env:LOCALAPPDATA\chromium-custom"`

> [!WARNING]
> Windows `Set-Alias` cannot pass arguments. `$PROFILE` is the file (same role as `~/.bashrc`)
> PowerShell 7: `Documents\PowerShell\Microsoft.PowerShell_profile.ps1`
> Windows PowerShell 5.1: `Documents\WindowsPowerShell\`
> Print it with `$PROFILE`. Create it if missing, paste a function, then reload:
>
> ```powershell
> # $PROFILE
> if (!(Test-Path $PROFILE)) { New-Item $PROFILE -Force }
> notepad $PROFILE
> ```

```powershell
function chrome {
  & "C:\Program Files\Google\Chrome\Application\chrome.exe" `
    --custom-devtools-frontend="$env:LOCALAPPDATA\chromium\front_end" @args
}
```

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
. $PROFILE
```

Or a shortcut. Target:

```
"C:\Program Files\Google\Chrome\Application\chrome.exe" --custom-devtools-frontend=%LOCALAPPDATA%\chromium\front_end
```

---

## Troubleshoot

> [!NOTE]
> Compare the Chrome/Chromium version on the [release](https://github.com/metaory/devtools-frontend-custom/releases/latest) to yours at `chrome://version`
> A large version gap might be the culprit

---

## License

This project is based on [Chromium DevTools](https://github.com/ChromeDevTools/devtools-frontend)
and is distributed under the [BSD-3-Clause](LICENSE) license.

The release archive contains a modified build of the Chromium DevTools frontend
and includes the upstream license and third-party notices.
