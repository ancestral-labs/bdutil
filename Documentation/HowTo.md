
# `bdutil` How-To Guide

Task-oriented recipes for `bdutil` (Boot Drive Utility), the macOS CLI for creating bootable USB media on Apple silicon — a native alternative to `wimlib imagex`, `dd`, Rufus, and balenaEtcher on macOS.

## How to install `bdutil`

With Homebrew:

```bash
brew install ancestral-labs/bdutil
```

Or download the latest signed installer package from the [GitHub release page](https://github.com/ancestral-labs/bdutil/releases) and copy the binary and resources into a directory in your `PATH` (for example `/usr/local`).

## How to upgrade `bdutil`

```bash
brew update ancestral-labs/bdutil
```

## How to uninstall `bdutil`

```bash
brew uninstall ancestral-labs/bdutil
```

For manual installations, delete the folder containing the binary and resource files (usually under `/usr/local`).

## How to list removable devices

```bash
bdutil list
```

Use this before every `create` operation to confirm the target device node (e.g. `disk4`).

## How to create a bootable Windows 10/11 USB on macOS

```bash
bdutil create dos ~/Downloads/Win11.iso disk4 --scheme gpt --file-system fat32
```

- Use `--scheme gpt` (default) for modern UEFI PCs; use `--scheme mbr` for legacy BIOS machines.
- Use `--file-system fat32` (default) for maximum compatibility; `exfat` is available but most BIOS firmware cannot boot from ExFAT.
- `bdutil` processes the Windows WIM image internally via WimKit, so large `install.wim` files (> 4 GB) work out of the box — no manual `wimlib imagex split` step is required, unlike manual FAT32 workflows.

## How to create a bootable Linux USB on macOS

```bash
bdutil create unix ~/Downloads/ubuntu.iso disk4
```

Works with standard ISO images from Fedora, Ubuntu, Debian, Arch, and similar distributions.

## How to create a bootable macOS installer USB

```bash
bdutil create macos /Applications/Install\ macOS\ Sequoia.app disk4
```

You can also pass a macOS DMG image path instead of the installer app.

## How to run silently (no completion beep)

Add the `--quiet` (`-q`) flag to any `create` subcommand:

```bash
bdutil create dos ~/Downloads/windows.iso disk4 --quiet
```

## How to get help and version information

```bash
bdutil --help
bdutil create --help
bdutil create dos --help
bdutil --version
```

## Troubleshooting

| Problem | Solution |
| --- | --- |
| `The device 'diskN' does not exists or is inaccessible` | Run `bdutil list` again; the device node changes when you replug the drive. |
| `The image file ... does not exist or is not readable` | Check the path and file permissions of the ISO/DMG/app. |
| Windows USB does not boot on an old PC | Recreate it with `--scheme mbr --file-system fat32`. |
| PC does not boot from an ExFAT drive | Recreate it with `--file-system fat32`; most BIOS firmware does not support ExFAT. |

## Next steps

- Follow the guided [Tutorial](./Tutorial.md).
- Read the [Technical Overview](./TechnicalOverview.md).
- Return to the [README](../README.md).

## Copyright

© 2023-2026 Ancestral Labs

All rights reserved
