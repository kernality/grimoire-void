# grimmstation-void

> A complete, laptop-tuned **Void Linux + Sway** desktop, ported from the
> Arch-based [grimmstation](https://codeberg.org/bibjaw99/grimmstation) dotfiles.
> Rebuilt for **xbps + runit + elogind**, with **wofi**, **zsh + starship**,
> **tuigreet** login and **PipeWire** audio. One script turns a freshly
> installed machine into this whole environment.
>
> **Built for:** Dell Latitude 5490 · i5-8250U · Intel UHD 620 · 16 GB · UEFI · ext4
> **Void flavour:** glibc + runit (the mainstream image)

---

## Table of contents

1. [Read this first (from a Mint brain to a Void brain)](#1-read-this-first)
2. [Words you'll see everywhere (mini-glossary)](#2-glossary)
3. [What's in this desktop](#3-whats-in-this-desktop)
4. [Before you install: make the USB & set BIOS](#4-before-you-install)
5. [Installing Void (the base system)](#5-installing-void)
6. [First boot: bootstrap & clone](#6-first-boot)
7. [Running the installer (what each step does)](#7-running-the-installer)
8. [Reboot & log in](#8-reboot-and-log-in)
9. [Your screen, explained](#9-your-screen-explained)
10. [The 12 keybindings that matter most](#10-the-12-keybindings)
11. [Full keybinding reference](#11-full-keybinding-reference)
12. [Everyday how-to (recipes)](#12-everyday-how-to)
13. [Installing & removing software](#13-software)
14. [Services (the runit way)](#14-services)
15. [Laptop power, battery & lid](#15-laptop-power)
16. [Sound](#16-sound)
17. [Making it yours (customising)](#17-customising)
18. [When something breaks (troubleshooting)](#18-troubleshooting)
19. [App-by-app: what everything is](#19-app-by-app)
20. [Print-me cheat sheet](#20-cheat-sheet)

---

## 1. Read this first

You're coming from Linux Mint. Mint holds your hand; Void hands you the keys and
trusts you. That's the whole difference, and it's a good one once it clicks.
Five things will feel new. None are hard.

**a) There's no "Software Manager" clicking around.** You install things by
typing one command. It's faster than it sounds, and this repo does the big first
batch for you.

**b) There's no systemd.** Mint (and Ubuntu, Fedora...) use an init system
called systemd. Void uses **runit**, which is simpler. You'll rarely touch it,
but when you do, it's "make a symlink" instead of "systemctl enable". Section 14
covers it in full.

**c) It updates forever, no "upgrade to the next version".** Void is a *rolling
release*. There's no "23.04 → 23.10". You just run one update command now and
then, and you're always current. Do it weekly-ish.

**d) The window manager tiles.** Instead of windows floating around that you
drag and drop, **Sway** automatically splits the screen into tiles. You mostly
use the keyboard. This is the part that feels alien on day one and natural by
day three. Section 10 gives you the five keys to start with.

**e) It's a Wayland setup, not X11.** You don't need to know what that means,
except: it's the modern display tech, and everything here is already wired for
it.

> **Mindset:** don't try to make Void behave like Mint. Give it a week as-is.
> The keyboard-driven, tiling workflow is the point, and it's genuinely faster
> once your hands learn it.

---

## 2. Glossary

Quick plain-English definitions for words in this README:

- **Compositor / Window Manager (WM):** the program that draws and arranges your
  windows. Here it's **Sway**. On Wayland the compositor *is* the WM.
- **Wayland:** the modern display system (replaces the older "X11").
- **Tiling:** windows auto-arrange into non-overlapping tiles instead of
  floating.
- **runit:** Void's init system (starts services at boot). Simpler than systemd.
- **service / daemon:** a background program (networking, bluetooth, login
  screen...). You "enable" one so it starts at boot.
- **xbps:** Void's package manager (like Mint's `apt`).
- **repo:** the online library of installable software.
- **package:** one installable piece of software.
- **dotfiles:** your config files (they usually start with a dot, like
  `.zshrc`). This repo *is* a dotfiles collection plus an installer.
- **symlink:** a shortcut/pointer from one file location to another. The
  installer symlinks configs into place.
- **`$mod` / Super:** the Windows/⊞ key. Sway's main modifier key.
- **greetd / tuigreet:** the login screen you see after boot.
- **elogind:** handles power events (lid, sleep, power button) and lets you
  suspend/reboot without a password.
- **PipeWire:** the sound system.
- **wofi:** the app launcher (a search box for programs). Replaces Mint's menu.
- **Waybar:** the bar at the top of the screen (clock, battery, volume...).

---

## 3. What's in this desktop

| Component      | Program                | Mint equivalent            |
| -------------- | ---------------------- | -------------------------- |
| OS             | Void Linux (runit)     | Linux Mint                 |
| Window manager | Sway                   | Cinnamon                   |
| Top bar        | Waybar                 | Cinnamon panel             |
| App launcher   | wofi                   | Mint menu                  |
| Login screen   | greetd + tuigreet      | LightDM                    |
| Shell          | zsh + starship         | bash                       |
| Terminal       | foot                   | GNOME Terminal             |
| File manager   | PCManFM (+ lf in term) | Nemo                       |
| Browser        | Firefox                | Firefox                    |
| Editor         | Neovim                 | xed / gedit                |
| Sound          | PipeWire               | PulseAudio                 |
| Screen lock    | swaylock + swayidle    | cinnamon-screensaver       |
| Power/battery  | elogind + TLP + thermald | (built into Cinnamon)    |
| Screenshots    | grim + swappy          | gnome-screenshot           |
| Notifications  | mako                   | Cinnamon notifications     |
| Bluetooth      | blueman                | blueberry                  |
| Extras         | Flatpak, KVM/virt-manager | (optional on Mint)      |

---

## 4. Before you install

You need a USB stick (4 GB+) and 20 quiet minutes.

### 4a. Download Void

Get the **x86_64 glibc** base live image (not musl, not a desktop spin) from
<https://voidlinux.org/download/>. The file looks like
`void-live-x86_64-YYYYMMDD-base.iso`.

### 4b. Write it to the USB

On your current machine:

- **Linux/Mint:** use the GNOME Disks or `dd` (careful with the target):
  `sudo dd if=void-live-*.iso of=/dev/sdX bs=4M status=progress oflag=sync`
  (replace `/dev/sdX` with your USB, e.g. `/dev/sdb`, NOT a partition).
- **Windows:** use [Rufus](https://rufus.ie) in "DD image" mode.

### 4c. Dell Latitude 5490 BIOS settings

Reboot, tap **F2** at the Dell logo to enter BIOS. Set:

- **Secure Boot: Disabled** (Void's kernel isn't signed for it).
- **SATA Operation: AHCI** (not RAID; RAID hides the SSD from Linux).
- **Virtualization (VT-x) & VT for Direct I/O: Enabled** (needed for KVM later).
- Boot mode: **UEFI** (leave as-is; it's the default).

Save & exit. Then tap **F12** at the logo to pick the USB as a one-time boot
device.

---

## 5. Installing Void

Boot the USB. At the login prompt: user `root`, password `voidlinux`. Then run:

```sh
void-installer
```

Work through the menus (arrow keys, Enter):

1. **Keyboard:** your layout (e.g. `us`).
2. **Network:** connect Wi-Fi/Ethernet now (the installer needs it for the
   Network source). Pick your Wi-Fi and enter the password.
3. **Source:** choose **Network** (installs current packages, not the older
   ISO snapshot).
4. **Hostname:** name the machine, e.g. `void-latitude`.
5. **Locale / Timezone:** your region.
6. **Root password:** set a strong one.
7. **User account:** create your user; **add it to the `wheel` group** when
   asked (this is your admin/sudo group).
8. **Bootloader:** install **GRUB** to the disk.
9. **Partitioning:** the simple path, guided, whole disk:
   - EFI System Partition ~512 MB (`/boot/efi`, FAT32)
   - Root partition, the rest, **ext4**, mounted at `/`
   - (Swap optional; 2 GB is plenty with 16 GB RAM, or skip it.)
10. **Install.** When it finishes, exit and `reboot`. Pull the USB.

> You now have a bare, text-only Void. No desktop yet. That's expected. The next
> steps turn it into the full environment.

---

## 6. First boot

Log in as your user at the black text prompt. First, become root once to enable
`sudo` and install `git`:

```sh
su -
# (enter the ROOT password you set)
xbps-install -Suy git sudo
echo "%wheel ALL=(ALL:ALL) ALL" > /etc/sudoers.d/wheel
chmod 440 /etc/sudoers.d/wheel
usermod -aG wheel YOURUSERNAME     # <- your username
exit
```

If Wi-Fi isn't connected yet, bring it up: `sudo nmtui` won't exist yet, so use
the base tool: `su -` then `wpa_supplicant`/`dhcpcd`, or just plug in Ethernet
for the install. (After the install, `nmtui` handles Wi-Fi graphically.)

Now clone this repo into the exact path the scripts expect and run it:

```sh
mkdir -p "$HOME/workstationdots"
git clone https://github.com/YOURNAME/grimmstation-void "$HOME/workstationdots/grimmstation"
bash "$HOME/workstationdots/grimmstation/install_scripts/install.sh"
```

---

## 7. Running the installer

`install.sh` runs these steps in order. It's safe to re-run; every step checks
before changing anything, and your old configs get backed up.

1. **System sync**, brings Void fully up to date first.
2. **Graphics (`setup_hardware.sh`)**, Intel UHD 620 drivers, hardware video
   decode (iHD), CPU microcode, thermald.
3. **Power (`setup_power.sh`)**, TLP battery tuning, elogind lid/power rules,
   non-root brightness.
4. **Audio (`setup_audio.sh`)**, PipeWire + WirePlumber wiring.
5. **Directories**, creates `~/Pictures/screenshots`, `~/Pictures/backgrounds`,
   etc.
6. **Packages**, installs everything from the package lists.
7. **Dotfiles**, copies configs to `~/.local/share/config_dotfiles` and
   symlinks them into place (old ones backed up to `~/.config.backup/`).
8. **Shell (`setup_shell.sh`)**, installs zsh + starship and makes zsh your
   login shell.
9. **Login (`setup_login.sh`)**, sets up the tuigreet login screen and keyring
   unlock.
10. **Services (`enable_services.sh`)**, enables networking, bluetooth, login,
    power, logging, time sync.

Optional extras, run when you want them:

```sh
bash install_scripts/scripts/install_with_flatpak.sh    # Flathub apps
bash install_scripts/scripts/setup_virtualization.sh    # KVM + virt-manager
```

When it says it's done, **reboot**:

```sh
sudo reboot
```

---

## 8. Reboot and log in

You'll see **tuigreet**, a clean text login with a clock, in gruvbox yellow.

- Your username is pre-filled (it remembers). Type your password, Enter.
- The session (`start-sway`) is already selected. If you ever need to change it,
  press **F3**.

A few seconds later you're in Sway: a wallpaper, a bar at the top, no windows
yet. That's normal, nothing auto-opens on an empty session.

**Do these five things now:**

1. **Open a terminal:** press `Super`+`Return`, then tap `Return` again.
   (`Super` is the ⊞ Windows key.)
2. **Connect Wi-Fi:** in the terminal, run `nmtui`, pick your network, enter the
   password. Arrow keys + Enter to navigate; Esc to exit.
3. **Check video decode:** run `vainfo` — it should mention the `iHD` driver.
4. **Check battery:** run `bat` (a shortcut for `acpi -b`).
5. **Test the lid:** close the laptop, wait two seconds, open it. You should
   resume to a **locked** screen (type your password to get back in).

If all five work, your machine is healthy. 🎉

---

## 9. Your screen, explained

**The top bar (Waybar):**

- **Left:** a launcher icon (click it to open wofi), your workspace numbers, and
  the focused window's name.
- **Center:** the clock (day, date, time).
- **Right:** network speed, free disk, CPU %, CPU temperature, screen
  brightness, memory, volume, and **battery**. The battery icon changes with
  charge and shows a bolt when charging.

**Workspaces** are virtual screens numbered 1–8. This setup themes them: certain
apps automatically open on certain workspaces (see below). Switch with
`Super`+number.

| WS | Meant for      | WS | Meant for          |
| -- | -------------- | -- | ------------------ |
| 1  | Terminal       | 5  | Chat               |
| 2  | Browser        | 6  | Design tools       |
| 3  | Dev / database | 7  | Office / PDF       |
| 4  | Files          | 8  | System / misc      |

So opening Firefox jumps you to workspace 2, GIMP to 6, and so on, automatically.

---

## 10. The 12 keybindings

Learn these first. `Super` = ⊞ key. Everything else can wait.

| Do this | Press |
| --- | --- |
| Open a terminal | `Super`+`Return`, then `Return` |
| Open the app launcher | `Super`+`d`, then `d` |
| Close the focused window | `Super`+`Shift`+`q` |
| Move focus between windows | `Super`+`h`/`j`/`k`/`l` (left/down/up/right) |
| Switch to workspace 1–8 | `Super`+`1`…`8` |
| Send window to a workspace | `Super`+`Shift`+`1`…`8` |
| Fullscreen the window | `Super`+`m` |
| Float / unfloat the window | `Super`+`space` |
| Lock the screen | `Super`+`Shift`+`x` |
| Power menu (suspend/restart/off) | `Super`+`d`, then `Shift`+`e` |
| Screenshot | `Print` |
| Reload Sway after editing config | `Super`+`Shift`+`r` |

> **About "modes":** some shortcuts are two-step. `Super`+`d` enters a mode, then
> a letter picks the action (`d` launcher, `w` window switcher, `e` emoji,
> `Shift`+`e` power). Press `Escape` to back out of any mode. It feels odd for a
> day, then it's muscle memory.

---

## 11. Full keybinding reference

### Windows & focus

| Keys | Action |
| --- | --- |
| `Super`+`h/j/k/l` | Move focus left/down/up/right |
| `Super`+`Shift`+`h/j/k/l` | Move the window |
| `Super`+`Ctrl`+`h/j/k/l` | Resize the window |
| `Super`+`a` / `Super`+`Shift`+`a` | Split next window vertical / horizontal |
| `Super`+`Shift`+`o` | Cycle layout (tabbed / split) |
| `Super`+`m` | Fullscreen toggle |
| `Super`+`space` | Float toggle + center |
| `Super`+`Shift`+`q` | Close window |
| `Super`+`Shift`+`r` | Reload Sway config |
| `Super`+`u` / `Super`+`i` | Focus parent / child container |

### Workspaces

| Keys | Action |
| --- | --- |
| `Super`+`1`…`8` | Go to workspace |
| `Super`+`Shift`+`1`…`8` | Send window to workspace |
| `Super`+`Tab` | Next workspace |
| `Alt`+`Tab` | Previous workspace |

### Launch mode — `Super`+`Return`, then:

`Return` terminal · `w` browser · `i` incognito · `n` files · `o` PDF viewer ·
`b` bluetooth · `p` audio settings · `m` music · `u` wallpaper picker

### Menu mode — `Super`+`d`, then:

`d` app launcher · `Shift`+`d` run a command · `w` window switcher ·
`e` emoji picker · `Shift`+`e` power menu

### Script mode — `Super`+`Shift`+`s`, then:

`b` switch Waybar theme · `t` toggle night-light · `w` pick wallpaper ·
`x` run a custom script

### Bookmarks mode — `Super`+`Shift`+`w`, then:

`m` open in tab · `Shift`+`m` private window · `n` new window
(store bookmarks as `.txt` files in
`~/.local/share/config_dotfiles/bookmarks/`)

### Hardware keys

| Keys | Action |
| --- | --- |
| `Super`+`F4` / `F3` | Brightness up / down (or the Fn brightness keys) |
| `Super`+`F7` / `F6` / `F5` | Volume up / down / mute (or Fn volume keys) |
| `Super`+`Shift`+`↑/↓/←/→` | Play / pause / next / previous track |
| `Print` | Screenshot to `~/Pictures/screenshots` |
| `Super`+`Print` | Screenshot, then annotate in swappy |

Full source: `config_dotfiles/config/sway/keymaps.conf`.

---

## 12. Everyday how-to

**Open an app I don't have a shortcut for:** `Super`+`d` then `d`, type its name,
Enter.

**Switch between open windows quickly:** `Super`+`d` then `w`, type part of the
title, Enter.

**Put two windows side by side:** open the first; before opening the second,
press `Super`+`Shift`+`a` (split horizontal), then open the second. Adjust size
with `Super`+`Ctrl`+`h/l`.

**Type an emoji:** `Super`+`d` then `e`, search, Enter. It types into the focused
box and copies to clipboard.

**Take a screenshot:** `Print` for the whole screen (saved to
`~/Pictures/screenshots`). `Super`+`Print` to screenshot and immediately
annotate/crop in swappy.

**Change the wallpaper:** drop images into `~/Pictures/backgrounds`, then
`Super`+`Shift`+`s` then `w`, pick one.

**Switch the bar theme:** `Super`+`Shift`+`s` then `b`.

**Save/open bookmarks:** put lines like
`https://example.com` into `.txt` files inside
`~/.local/share/config_dotfiles/bookmarks/`, then `Super`+`Shift`+`w` then `m`.

**Lock now:** `Super`+`Shift`+`x`. **Suspend/restart/shut down:** `Super`+`d`
then `Shift`+`e`, pick from the menu.

**File manager:** `Super`+`Return` then `n` (graphical, PCManFM), or run `lf`
in a terminal for a fast keyboard file manager.

---

## 13. Software

Your shell has short aliases for everything (defined in `~/.alias`):

| Alias | Full command | Does |
| --- | --- | --- |
| `xi PKG` | `sudo xbps-install PKG` | Install a package |
| `up` | `sudo xbps-install -Suy` | Update the whole system |
| `search TERM` | `xbps-query -Rs TERM` | Search the repo |
| `xr PKG` | `sudo xbps-remove PKG` | Remove a package |
| `xclean` | `sudo xbps-remove -Oo` | Clean orphans + cache |
| `list` | `xbps-query -l` | List installed packages |

Example: install VLC → `xi vlc`. Search first if unsure → `search vlc`.

**Flatpak** (for apps not in Void's repo, or sandboxed ones) is set up if you ran
the extra script. Install from Flathub: `flatpak install flathub <app-id>`,
run with `flatpak run <app-id>` (or from the launcher).

> **Rule of thumb:** try `xi` first (native, lighter). Use Flatpak for big GUI
> apps that aren't packaged, or when you want sandboxing.

---

## 14. Services (the runit way)

A "service" is a background program. There's no `systemctl` here. Instead:

```sh
sudo ln -s /etc/sv/NAME /var/service/   # enable (start now + at boot)
sudo rm /var/service/NAME               # disable
sudo sv status NAME                     # is it running?
sudo sv restart NAME                    # restart it
sudo sv down NAME                       # stop (until re-enabled)
```

The installer already enabled everything you need: `dbus`, `NetworkManager`,
`bluetoothd`, `polkitd`, `tlp`, `thermald`, `chronyd`, `socklog-unix`,
`nanoklogd`, `greetd` (plus `libvirtd` if you set up KVM).

> **Tip:** `NAME` is the folder name in `/etc/sv/`. Note Void calls the
> bluetooth service `bluetoothd`, not `bluetooth`.

---

## 15. Laptop power, battery & lid

This build is tuned for the 5490 out of the box. Behaviour:

- **Close lid →** suspend. **Open →** resume with the screen **locked**.
- **Idle 5 min →** lock. **Idle 10 min →** screen off (wakes on key/touch).
- **Power button →** suspend (deliberately not shut down, so you can't lose work
  by a stray press).
- **Battery longevity:** managed by **TLP**. Check it with `power`
  (`sudo tlp-stat -s`). Tune in `/etc/tlp.conf`.
- **Overheating protection:** **thermald** throttles before the i5-8250U cooks.
- **Low battery:** you get a desktop warning at 30% and a critical one at 20%.
- **Brightness keys** work without root (you're in the `video` group).
- **Clock** re-syncs after resume via **chrony**.

Change lid/power behaviour in
`/etc/elogind/logind.conf.d/10-grimmstation.conf` (e.g. set
`HandleLidSwitch=ignore` if you dock and use an external monitor with the lid
closed), then reboot or `sudo sv restart dbus`.

> **Why no `acpid`:** on Void, elogind already handles ACPI power events.
> Running acpid too causes double-suspend. This build intentionally omits it.

---

## 16. Sound

PipeWire is already configured and starts with your session. Controls:

- Volume: `Super`+`F7`/`F6`/`F5` (or the Fn volume keys).
- Mixer (per-app volumes, devices): run `wiremix` in a terminal, or open
  `pavucontrol` (`Super`+`Return` then `p`).
- If sound is silent: check you're in the `audio` group (`groups`), and that
  PipeWire is running (`pgrep -a pipewire`). Log out/in if you just installed.

---

## 17. Customising

- **Add/remove packages that get installed:** edit the files in
  `install_scripts/package_lists/`. Lines starting with `#` are ignored.
- **Display & touchpad:** `config_dotfiles/config/sway/devices.conf`. It's set
  for the 5490's 1920×1080@60 panel and tap-to-click touchpad. To pin an
  external monitor to the right of the laptop screen, add:
  ```
  output HDMI-A-1 { mode 1920x1080@60Hz pos 1920 0 }
  ```
  (Run `swaymsg -t get_outputs` to see connected output names.)
- **Launcher looks:** `config_dotfiles/config/wofi/style.css`.
- **Prompt:** `config_dotfiles/config/starship.toml`.
- **Shell:** `config_dotfiles/zshrc` and aliases in `config_dotfiles/alias`.
- **Keybindings:** `config_dotfiles/config/sway/keymaps.conf`. After editing,
  `Super`+`Shift`+`r` to reload.
- **Battery tuning:** `/etc/tlp.conf`.

After editing a dotfile in the repo, re-run the installer (or just
`bash install_scripts/scripts/symlink_configs.sh`) to relink.

---

## 18. Troubleshooting

**Resume shows the desktop for a second before locking, or doesn't lock.**
Ensure swayidle is running (`pgrep -a swayidle`) and every swaylock call uses
`-f` (this build does). Reboot if you just installed.

**The laptop suspends twice or wakes right after sleeping.**
You installed `acpid`. Disable it: `sudo rm /var/service/acpid` and
`sudo mv /etc/acpi/events/anything /etc/acpi/events/anything.disabled`.

**Brightness keys do nothing.**
Confirm you're in the `video` group: `groups | grep video`. If you just
installed, log out and back in. Test: `brightnessctl set 50%` as your user.

**No sound.**
`pgrep -a pipewire` (should list processes). Check `groups` includes `audio`.
Open `pavucontrol` and confirm the right output device isn't muted.

**No hardware video acceleration / video stutters.**
`vainfo` should list the `iHD` driver. The session sets `LIBVA_DRIVER_NAME=iHD`
automatically.

**The power menu asks for a password to suspend/reboot.**
`dbus` must be enabled (it is) and you must have logged in via tuigreet, not a
raw TTY. Check `sudo sv status dbus`.

**Firefox/apps keep asking to unlock a keyring.**
The PAM unlock is set up by the installer. If it still prompts, make sure
`/etc/pam.d/greetd` contains the `pam_gnome_keyring` lines and you logged in
through tuigreet.

**CPU temperature warning never appears (or `sensors` says no chips).**
`lm_sensors` is installed; coretemp is usually auto-loaded. If needed, run
`sudo sensors-detect --auto` once, then reboot.

**Battery drains fast.**
`sudo tlp-stat -s` to confirm TLP is active. Tune `/etc/tlp.conf`.

**Wi-Fi didn't reconnect after resume.**
`sudo sv restart NetworkManager`, then reconnect with `nmtui`.

**A package won't install ("not found").**
Void is rolling; a name may have changed. Search: `search <partial-name>`. The
installer skips a missing package with a warning rather than failing.

**Keep the system healthy:** run `up` every week or so.

---

## 19. App-by-app

- **Sway** — the window manager; arranges everything, reads
  `~/.config/sway/`.
- **Waybar** — the top bar; `~/.config/waybar/`.
- **wofi** — launcher & menus; `~/.config/wofi/`.
- **foot** — terminal (runs as a fast server + client).
- **PCManFM** — graphical file manager; **lf** — terminal file manager.
- **Firefox** — browser (Wayland-native).
- **Neovim** — text editor (LazyVim-style config; installs its plugins on first
  launch, needs internet that once).
- **mako** — notification popups.
- **swaylock / swayidle** — lock screen + idle/sleep automation.
- **grim / swappy** — screenshot capture + annotation.
- **blueman** — Bluetooth manager.
- **wiremix / pavucontrol** — audio mixers.
- **zathura** — PDF viewer. **ristretto** — image viewer. **mpv** — video.
- **btop** — system monitor. **starship** — the shell prompt.
- **TLP / thermald / elogind** — battery, thermal, power events.
- **zsh** — your shell (aliases in `~/.alias`).

---

## 20. Cheat sheet

```
LAUNCH        Super+Return Return   terminal
              Super+d d              app launcher
              Super+d w              window switcher
              Super+d e              emoji
WINDOWS       Super+h/j/k/l          focus
              Super+Shift+h/j/k/l    move
              Super+Ctrl+h/j/k/l     resize
              Super+m                fullscreen
              Super+space            float
              Super+Shift+q          close
WORKSPACE     Super+1..8             switch
              Super+Shift+1..8       send window
SYSTEM        Super+Shift+x          lock
              Super+d Shift+e        power menu
              Print / Super+Print    screenshot / annotate
              Super+Shift+r          reload sway
SHELL         up        update system
              xi PKG    install
              search X  find package
              bat       battery status
              power     TLP status
SERVICES      sudo sv status NAME
              sudo ln -s /etc/sv/NAME /var/service/
```

---

## Credits

Dotfiles and Sway design by **bibjaw99** (grimmstation). Void port and install
tooling (xbps / runit / elogind / wofi / zsh / laptop power) adapted from it for
the Dell Latitude 5490.
