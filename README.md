# Tekitou

A lightweight macOS menubar app that adds black rounded corners and menubar to your screen, matching macOS Tahoe's window aesthetic.

## Why Tekitou?

macOS Tahoe introduced aggressively rounded window corners, but the screen edges remain sharp. Tekitou draws subtle black overlays at the corners and menubar area, creating visual harmony between your windows and screen edges.

### Tekitou vs Gaffer

Tekitou is a complete rewrite of [Gaffer](https://github.com/jaamesd/Gaffer), taking a fundamentally different approach:

| | Gaffer | Tekitou |
|---|--------|---------|
| **Approach** | Modifies wallpaper images | Draws overlay windows |
| **Speed** | Slow (image processing) | Instant |
| **Complexity** | ~1500 lines | ~250 lines |
| **CPU usage** | High during processing | Negligible |
| **Persistence** | Survives app quit | Requires app running |
| **Dynamic wallpapers** | Complex HEIC handling | Just works |

**Why overlay is better:**
- No image processing = instant response
- No cache management = simpler code
- No wallpaper modification = cleaner approach
- Works with any wallpaper automatically

## Features

- **Corner styles**: Match different Tahoe window types
  - Square Corners (0px) - menubar only
  - Titlebar (16px) - Terminal-style windows
  - Compact Toolbar (21px) - compact toolbar windows
  - Toolbar (26px) - Finder/Safari-style windows
- **Continuous curvature**: Uses Apple's squircle math, not simple arcs
- **Multi-display**: Each screen gets its own overlay
- **All Spaces**: Works across all virtual desktops
- **Login Item**: Optional start at login

## Installation

1. Download `Tekitou.app` from Releases
2. Move to `/Applications`
3. Launch from Applications folder

## Building from source

```bash
./build-app.sh
open Tekitou.app
```

## Requirements

- macOS 13.0 (Ventura) or later

## How it works

Tekitou creates transparent, click-through overlay windows positioned just above the desktop but below your app windows. Each overlay draws:
1. A black menubar strip at the top
2. Black corner shapes using Apple's continuous curvature bezier curves

The overlays use `NSWindow.Level` positioning to stay above the wallpaper but below normal windows, so your apps appear naturally on top.

## License

MIT
