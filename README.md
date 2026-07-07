# grimoire-void

> A complete, laptop-tuned **Void Linux + Sway** desktop, ported from the
> Arch-based [grimmstation](https://codeberg.org/bibjaw99/grimmstation) dotfiles
> and rebuilt for **xbps + runit + elogind**, with **wofi**, **zsh + starship**,
> **tuigreet** login and **PipeWire** audio. One script turns a freshly
> installed machine into this whole environment.
>
> **Built for:** Dell Latitude 5490 · i5-8250U · Intel UHD 620 · 16 GB · UEFI · ext4
> **Void flavour:** glibc + runit

## Table of contents

1. Read this first · 2. Glossary · 3. What's in this desktop ·
4. Before you install · 5. Installing Void · 6. First boot · 7. The installer ·
8. Reboot & log in · 9. Your screen · 10. The 12 keys · 11. Full keys ·
12. Everyday how-to · 13. Software · 14. runit vs systemd · 15. xbps ·
16. Sway · 17. The Sway stack · 18. zsh + starship · 19. Grimm Neovim ·
20. Laptop power · 21. Sound · 22. Customising · 23. Troubleshooting ·
24. App-by-app · 25. Cheat sheet · 26. Credits

---

## 1. Read this first

Coming from Linux Mint, five things feel new; none are hard:
1. **You install software by typing one command** (this repo does the big first
   batch for you).
2. **No systemd.** Void uses **runit** (simpler). Section 14.
3. **Rolling release** — no version upgrades, just update often.
4. **The window manager tiles** — Sway arranges windows; you drive it from the
   keyboard. Section 10 has the starter keys.
5. **It's Wayland** — modern display tech, already wired for you.

## 2. Glossary

- **Compositor / WM:** draws & arranges windows — here, **Sway**.
- **Wayland:** modern display system (replaces X11). **Tiling:** no overlap.
- **runit:** Void's init system. **xbps:** its package manager (like apt).
- **$mod / Super:** the ⊞ key. **greetd/tuigreet:** login screen.
- **elogind:** power/seat handling. **PipeWire:** sound. **wofi:** launcher.

## 3. What's in this desktop

Sway (WM) · Waybar (bar) · wofi (launcher) · greetd+tuigreet (login) ·
zsh+starship (shell) · foot (terminal) · PCManFM + lf (files) · Firefox ·
Neovim · PipeWire (sound) · swaylock+swayidle · elogind+TLP+thermald (power) ·
grim+swappy (screenshots) · mako · blueman · optional Flatpak + KVM.

## 4. Before you install

USB (4 GB+), ~20 min. Download the **x86_64 glibc base** image from
<https://voidlinux.org/download/>. Write: Linux
`sudo dd if=void-live-*.iso of=/dev/sdX bs=4M status=progress oflag=sync`;
Windows → Rufus (DD mode). **Dell 5490 BIOS (F2):** Secure Boot **Disabled**,
SATA **AHCI**, Virtualization **Enabled**, boot **UEFI**. F12 to boot the USB.

## 5. Installing Void

`root` / `voidlinux`, run `void-installer`: keyboard; connect network;
**Source: Network**; hostname; locale/timezone; root password; your user **in
`wheel`**; **GRUB**; guided whole-disk with ~512 MB EFI (FAT32) + rest **ext4**
at `/`. Install, `reboot`, pull USB.

## 6. First boot

```sh
su -
xbps-install -Suy git sudo
echo "%wheel ALL=(ALL:ALL) ALL" > /etc/sudoers.d/wheel
chmod 440 /etc/sudoers.d/wheel
usermod -aG wheel YOURUSERNAME
exit

mkdir -p "$HOME/workstationdots"
git clone https://github.com/YOURNAME/grimoire-void "$HOME/workstationdots/grimmstation"
bash "$HOME/workstationdots/grimmstation/install_scripts/install.sh"
```

> The clone target folder stays `grimmstation` (the scripts resolve their own
> paths, but the original layout expects that name). Only the GitHub repo is
> named grimoire-void.

## 7. The installer

Order: system sync → Intel graphics + thermald → power → PipeWire →
directories → packages → copy+symlink dotfiles → zsh → tuigreet (elogind
session + keyring PAM) → services. Safe to re-run. Extras:
`install_with_flatpak.sh`, `setup_virtualization.sh`. Then `sudo reboot`.

## 8. Reboot & log in

tuigreet (gruvbox yellow); username remembered. `start-sway` preselected (F3 to
change). Then: 1) `Super`+`Return` terminal; 2) `nmtui` Wi-Fi; 3) `vainfo` shows
`iHD`; 4) `bat` battery; 5) close/open lid → resume **locked**.

## 9. Your screen

Top bar: left launcher+workspaces+title, center clock, right
network/disk/CPU/temp/brightness/memory/volume/battery. Workspaces 1–8 themed
(1 terminal · 2 browser · 3 dev · 4 files · 5 chat · 6 design · 7 office ·
8 system).

## 10. The 12 keys

`Super` = ⊞. **Everyday actions are single chords.**

| Do | Press |
| --- | --- |
| Terminal | `Super`+`Return` |
| Launcher | `Super`+`d` |
| Browser | `Super`+`b` |
| Window switcher | `Super`+`` ` `` |
| Emoji | `Super`+`e` |
| Power menu | `Super`+`Shift`+`e` |
| Close window | `Super`+`Shift`+`q` |
| Lock | `Super`+`Shift`+`x` |
| Fullscreen | `Super`+`m` |
| Move focus | `Super`+`h/j/k/l` |
| Workspace 1–8 | `Super`+`1`…`8` |
| Reload Sway | `Super`+`Shift`+`r` |

## 11. Full keys

**Apps:** `Super`+`Return` term · `Super`+`b` browser · `Super`+`Shift`+`b`
incognito · `Super`+`Shift`+`Return` files.
**Menus:** `Super`+`d` launcher · `Super`+`Shift`+`d` run · `Super`+`` ` ``
windows · `Super`+`e` emoji · `Super`+`Shift`+`e` power.
**Windows:** `Super`+`h/j/k/l` focus (or arrows) · `+Shift` move · `+Ctrl`
resize · `Super`+`a`/`Super`+`Shift`+`a` split · `Super`+`Shift`+`o` layout ·
`Super`+`m` fullscreen · `Super`+`space` float · `Super`+`Shift`+`q` close.
**Workspaces:** `Super`+`1..8` · `+Shift` send · `Super`+`Tab`/`Alt`+`Tab`.
**Modes (trigger, then bare letter; `Escape` exits):** open `Super`+`o`
(`p`/`m`/`b`/`a`/`w`) · swap `Super`+`Shift`+`s` (`h/j/k/l`) · scripts
`Super`+`Shift`+`g` (`b`/`t`/`w`/`x`) · bookmarks `Super`+`Shift`+`w`
(`m`/`Shift+m`/`n`/`c`) · notify `Super`+`Shift`+`m`.
**Hardware:** brightness `Super`+`F4/F3`; volume `Super`+`F7/F6/F5`; media
`Super`+`Shift`+arrows; `Print`/`Super`+`Print` screenshot.

## 12. Everyday how-to

Open any app → `Super`+`d`, type, Enter. Side by side → open one,
`Super`+`Shift`+`a`, open the second. Emoji → `Super`+`e` (search by name).
Screenshot+annotate → `Super`+`Print`. Wallpaper → drop into
`~/Pictures/backgrounds`, `Super`+`Shift`+`g` `w`. Lock/power →
`Super`+`Shift`+`x` / `Super`+`Shift`+`e`.

## 13. Software

`xi PKG` install · `up` update all · `search X` find · `xr PKG` remove ·
`xclean` clean · `list`. Flatpak: `flatpak install flathub <id>`.

## 14. runit vs systemd

runit is a tiny service supervisor. A service is `/etc/sv/NAME`; enable by
symlinking into `/var/service/`.

| Task | systemd | runit |
| --- | --- | --- |
| Enable+start | `systemctl enable --now NAME` | `sudo ln -s /etc/sv/NAME /var/service/` |
| Disable | `systemctl disable NAME` | `sudo rm /var/service/NAME` |
| Start/stop | `systemctl start/stop NAME` | `sudo sv up/down NAME` |
| Restart | `systemctl restart NAME` | `sudo sv restart NAME` |
| Status | `systemctl status NAME` | `sudo sv status NAME` |
| Logs | `journalctl -u NAME` | `tail -f /var/log/socklog/*/current` |

No journalctl (plain-file logs); no user units (PipeWire/swayidle run from Sway
autostart); no timers (use cron); logind = elogind (passwordless suspend, wired
into greetd's PAM by the installer). Service is `bluetoothd`, not `bluetooth`.

## 15. xbps

| Task | apt | xbps |
| --- | --- | --- |
| Update | `apt update && apt upgrade` | `xbps-install -Suy` |
| Install | `apt install PKG` | `xbps-install PKG` |
| Remove | `apt remove PKG` | `xbps-remove PKG` |
| Search | `apt search X` | `xbps-query -Rs X` |
| Owns file | `dpkg -S FILE` | `xbps-query -o FILE` |
| Clean | `apt clean` | `xbps-remove -Oo` |

Flags: `-S` sync · `-u` update · `-y` yes · `-R` remote · `-o` orphans ·
`-O` clean · `-f` force. Repos: nonfree (installer enables), multilib for 32-bit.
`sudo xmirror` for a faster mirror. Update weekly with `up`.

## 16. Sway

Tiling Wayland compositor (i3-compatible). Opening a window splits the focused
container (`Super`+`a`/`Super`+`Shift`+`a` sets direction). Config in
`~/.config/sway/`: variables, keymaps, workspaces, windowrules, lookAndFeel,
devices, autostart. Reload `Super`+`Shift`+`r`. `swaymsg -t get_outputs` lists
monitors; add `output NAME { mode ... pos X Y }` to devices.conf.

## 17. The Sway stack

Core: sway · wayland · xorg-server-xwayland · qt6-wayland. Bar/launcher/notify:
Waybar · wofi · mako. Lock/idle/wallpaper: swaylock · swayidle · swaybg.
Screenshots/clipboard: grim · slurp · swappy · wl-clipboard · wtype. Portals:
xdg-desktop-portal (+wlr, +gtk). Session/power: elogind · dbus · polkit+
mate-polkit · gnome-keyring. Look/input: lxappearance · wlsunset · brightnessctl
· playerctl. Fonts: nerd-fonts-ttf · noto/dejavu/terminus. Audio: pipewire ·
wireplumber (ships `wpctl`, used by the volume keys).

## 18. zsh + starship

bash-compatible shell + fast prompt. Gains: smart completion, `Ctrl+r` fuzzy
history, grey autosuggestions (`→` accepts), live syntax highlighting, vi mode
(`Esc`). Config: `~/.zshrc`, `~/.alias`, `~/.config/starship.toml`. bash back:
`chsh -s /bin/bash`.

## 19. Grimm Neovim

Modal editor. First launch downloads plugins (needs internet, ~1 min). Included:
lazy.nvim (`:Lazy`), Mason (`:Mason`), mini.files, Snacks.nvim, LSP+completion,
Gitsigns, Treesitter. Survival: `i`/`Esc`, `:w`, `:q`, `:wq`, `:q!`, `h/j/k/l`,
`/text`, `u`/`Ctrl+r`, `dd`/`yy`/`p`. Press `Space` for a shortcut popup. Run
`vimtutor` once.

## 20. Laptop power

Close lid → suspend; open → resume **locked**. Idle 5 min → lock; 10 → screen
off. Power button → suspend. Battery via **TLP** (`power` = `sudo tlp-stat -s`).
Thermal via **thermald**. Low-battery warnings 30%/20%. Brightness keys work
without root. Clock re-syncs on resume (chrony). Lid/power:
`/etc/elogind/logind.conf.d/10-grimoire.conf`.
> No `acpid` — elogind handles ACPI; both = double-suspend.

## 21. Sound

PipeWire starts with the session. Volume keys use **wpctl** (ships with
wireplumber). Mixer: `wiremix` or `pavucontrol`. Silent? `groups` has `audio`
and `pgrep -a pipewire`; log out/in after first install.

## 22. Customising

Packages: `install_scripts/package_lists/*.txt`. Display/touchpad:
`config/sway/devices.conf`. Launcher: `config/wofi/style.css`. Prompt:
`config/starship.toml`. Keys: `config/sway/keymaps.conf` then
`Super`+`Shift`+`r`. Battery: `/etc/tlp.conf`.

## 23. Troubleshooting

- **Resume flashes / no lock:** `pgrep -a swayidle`; swaylock uses `-f`.
- **Power menu asks a password / no seat:** confirm `pam_elogind` in
  `/etc/pam.d/greetd` and `dbus` enabled; log in via tuigreet.
- **Double-suspend:** acpid installed — disable it.
- **Brightness keys dead:** `groups | grep video`; log out/in.
- **No sound:** `pgrep -a pipewire`; `groups` has `audio`.
- **Volume keys do nothing:** `command -v wpctl` (ships with wireplumber).
- **No video accel:** `vainfo` should show `iHD`.
- **Keyring prompts:** confirm `pam_gnome_keyring` in `/etc/pam.d/greetd`.
- **Emoji picker empty first run:** it fetches once (needs network) or uses a
  seed; refresh with `rm ~/.cache/emoji-list.txt`.
- **Temp warning silent:** `lm_sensors` installed; `sudo sensors-detect --auto`.
- **Battery drains fast:** `sudo tlp-stat -s`.
- **Wi-Fi didn't reconnect:** `sudo sv restart NetworkManager`.
- **Keep healthy:** run `up` weekly.

## 24. App-by-app

Sway · Waybar · wofi · foot · PCManFM/lf · Firefox · Neovim · mako ·
swaylock/swayidle · grim/swappy · blueman · wiremix/pavucontrol · zathura ·
ristretto · mpv · cmus · btop · starship · TLP/thermald/elogind.

## 25. Cheat sheet

```
LAUNCH   Super+Return terminal   Super+d launcher   Super+b browser
         Super+`  window switch  Super+e emoji      Super+Shift+e power
WINDOWS  Super+h/j/k/l focus   +Shift move   +Ctrl resize
         Super+m fullscreen    Super+space float   Super+Shift+q close
WORKSPC  Super+1..8 switch     Super+Shift+1..8 send
MODES    Super+o open  Super+Shift+g scripts  Super+Shift+w bookmarks
         Super+Shift+s swap  Super+Shift+m notify
AUDIO    Super+F7/F6/F5 volume (wpctl)   Super+F4/F3 brightness
SYSTEM   Super+Shift+x lock   Print/Super+Print screenshot
         Super+Shift+r reload sway
SHELL    up update  xi PKG install  search X  bat  power
SERVICE  sudo sv status NAME   sudo ln -s /etc/sv/NAME /var/service/
```

## 26. Credits

Dotfiles and Sway design by **bibjaw99** (grimmstation). Void port
(grimoire-void) and install tooling adapted for the Dell Latitude 5490. Keymap
retuned for one-chord ergonomics; audio via wpctl; full-Unicode emoji picker;
elogind session + keyring wired into greetd PAM; launcher variables and waybar
module cleanly named.
