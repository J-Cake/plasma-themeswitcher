#!/bin/env nu

let options = open ~/.config/theme.json;

def desktop [theme: string] {
    ^((which plasma-apply-desktoptheme).path | first) $theme
}

def colour [colours: string] {
    ^((which plasma-apply-colorscheme).path | first) $colours
}

def applicationStyle [style: string] {
    # kwriteconfig5 --file kdeglobals --group KDE --key widgetStyle $style
    ^((which plasma-apply-style).path | first) -w $style
}

def light [] {
    desktop $options.light.plasmaStyle
    colour $options.light.colourScheme
    applicationStyle $options.light.applicationStyle

    kdialog --title "Switched to light theme" --passivepopup "Light theme was activated"
}

def dark [] {
    desktop $options.dark.plasmaStyle
    colour $options.dark.colourScheme
    applicationStyle $options.dark.applicationStyle

    kdialog --title "Switched to dark theme" --passivepopup "Dark theme was activated"
}

def main [
    theme?: string
] {
    if $theme != null {
        let theme = $theme | str downcase;

        if $theme != 'light' and $theme != 'dark' {
            error make {
                msg: $"Unrecognised theme ($theme)"
            }
        }

        if $theme == 'light' {
            light
        } else {
            dark
        }
    } else {
        schedule
    }
}

def schedule [] {
    let heliocron = (which heliocron).path | first;
    alias heliocron = ^$heliocron

    let manual = ^heliocron -l $options.coordinates.lat -o $options.coordinates.long report --json | from json;

    if ($manual | get $options.toDark | into datetime) > (date now) and ($manual | get $options.toLight | into datetime) <= (date now) {
        light
    } else {
        dark
    }

    do -i {
        heliocron wait --run-missed-event -e $options.toLight
        light
    }

    do -i {
        heliocron wait --run-missed-event -e $options.toDark
        dark
    }
}
