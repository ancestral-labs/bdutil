
# `bdutil` Tutorial

A step-by-step guided tour of `bdutil` (Boot Drive Utility), the macOS command-line tool to create bootable USB media on Apple silicon. This tutorial shows how to list removable devices and create a bootable Windows (DOS), Linux (UNIX), and macOS installer drive — without needing `wimlib imagex`, `dd`, or third-party GUI tools like Rufus or balenaEtcher.

## What you will learn

- How to identify the correct target USB device with `bdutil list`.
- How to create a bootable Windows USB installer on macOS with `bdutil create dos`.
- How to create a bootable Linux USB installer on macOS with `bdutil create unix`.
- How to create a bootable macOS installer USB with `bdutil create macos`.
- How to verify the result and eject the device safely.

## Prerequisites

- An Apple silicon Mac (M1, M2, M3, M4 or newer).
- macOS 15 (Sequoia) or newer.
- `bdutil` installed via Homebrew (`brew trust ancestral-labs/tap && brew tap ancestral-labs/tap && brew install bdutil`) or the signed installer package from the [GitHub release page](https://github.com/ancestral-labs/bdutil/releases).
- A USB flash drive of at least 8 GB (16 GB recommended for Windows 11 images).
- A source image: a Windows ISO, a Linux ISO, or a macOS installer app / DMG.

> **Warning:** every `bdutil create` command erases the target device completely. Double-check the device identifier before continuing.

## Step 1 — Identify your USB device

Plug in your USB drive and list the available external devices:

```bash
bdutil list
```

The output shows the device node of each removable disk, for example `disk4`. Confirm the identifier by size and name — writing to the wrong disk destroys its data.

## Step 2 — Create a bootable Windows USB (DOS)

`bdutil create dos` builds a UEFI/BIOS-bootable Windows installer from a Windows ISO. It splits the WIM image internally through BootDriveKit, so you do **not** need to do it manually with `wimlib imagex split` or `wimlib-imagex apply` to work around the FAT32 4 GB file-size limit — a manual, error-prone step that frustrates many macOS users creating Windows bootable USB drives.

```bash
bdutil create dos /path/to/windows.iso disk4 --scheme gpt --file-system fat32
```

Options:

- `--scheme` (`-s`): partition scheme, `gpt` (default, for UEFI) or `mbr` (for legacy BIOS).
- `--file-system` (`-f`): `fat32` (default, most compatible) or `exfat`. Note that most BIOS firmware does not support ExFAT-formatted devices.
- `--quiet` (`-q`): skip the beep when the media creation finishes.

## Step 3 — Create a bootable Linux USB (UNIX)

`bdutil create unix` writes a Linux distribution ISO (Fedora, Ubuntu, Debian, etc.) to the device, making it bootable on both PCs and supported Macs:

```bash
bdutil create unix ~/Downloads/fedora.iso disk4
```

## Step 4 — Create a bootable macOS installer USB

`bdutil create macos` turns a macOS installer app or DMG into a bootable installer drive:

```bash
bdutil create macos /path/to/macos.dmg disk4
```

## Step 5 — Verify and eject

During creation, `bdutil` reports each stage: checking privileges, mounting the image, formatting the device, copying files, unmounting the image, and ejecting the volume. When the process finishes, the device is ejected automatically and is ready to boot your target machine.

## Next steps

- Learn advanced usage in the [How-To guide](./HowTo.md).
- Understand how `bdutil` works internally in the [Technical Overview](./TechnicalOverview.md).
- Return to the [README](../README.md).

## Copyright

© 2023-2026 Ancestral Labs

Licensed under the Apache License, Version 2.0.
