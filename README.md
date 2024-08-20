# plasma-themeswitcher
A set of scripts for switching plasma themes automatically

## Installation

The installation process is not strictly defined, but here is how I do it:

1. Install prerequisites:
    * [`nushell`](https://crates.io/crates/nu)
    * [`heliocron`](https://crates.io/crates/heliocron)
    I already have cargo installed, so it's an easy install:
    ```bash
    cargo install nu heliocron
    ```

2. Copy the script to where ever you put your scripts. I like mine in `~/.local/share/scripts`.
    ```nu
    git clone https://github.com/J-Cake/plasma-themeswitcher
    cd plasma-themeswitcher
    mkdir ~/.local/share/scripts
    cp theme.nu ~/.local/share/scripts
    ```

3. Copy `service` and `timer` files
    ```nu
    cp theme.service theme.timer ~/.config/systemd/user/
    ```

4. Enable:
    ```nu
    systemctl --user enable theme.timer
    systemctl --user enable theme.service
    ```

## Manual Usage

The script allows you to set your plasma theme manually:

```nu
./theme.nu [light|dark]
```

By invoking the script without arguments, you request it to wait until sunrise, then sunset. It will wait for both, then exit. 
If the sunrise was missed, the error thrown by `heliocron` will be ignored, and the script will wait for sunset.

## Configuration

The script reads from a config file located at `~/.config/theme.json` whose properties are enumerated below:

| Property | Function |
| -------- | -------- |
| `coordinates` | Specifies the location to query the sunset/sunrise coordinates from. A way to automate this is coming soon. |
| `toLight` | Specifies the event that triggers the switch to light theme. Can be any of `sunrise`, `dawn.nautical`, `dawn.civil`, `dawn.astronomical`, `sunset`, `dusk.nautical`, `dusk.civil`, `dusk.astronomical` |
| `toDark` | Specifies the event that triggers the switch to light dark. Can be any of `sunrise`, `dawn.nautical`, `dawn.civil`, `dawn.astronomical`, `sunset`, `dusk.nautical`, `dusk.civil`, `dusk.astronomical` |
| `light` | Sets the individual theme elements of the light mode. Currently understood settings are `plasmaStyle`, `colourScheme`, `applicationStyle` |
| `dark` | Sets the individual theme elements of the dark mode. Currently understood settings are `plasmaStyle`, `colourScheme`, `applicationStyle` |

> **Caution**: The theme values you choose to switch to should already be installed. I am unsure what happens when you attempt to set a theme which does not exist. This may also include misspelling it accidentally. Please beware of this. 

> **Note**: The ability to set custom actions is coming soon. 

