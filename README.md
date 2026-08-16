
# `bdutil`

Boot Drive Utility, aka `bdutil`, is a command-line tool for create bootable media devices on your Mac. It's written in Swift, and optimized for Apple silicon.

The tool uses the [BootDriveKit](https://github.com/ancestral-labs/BootDriveKit) Swift package for low level bootable media creation, process, and process management. BootDriveKit is a proprietary component of Ancestral Labs, licensed under its own End User License Agreement (EULA), and is not distributed as part of this project.

`bdutil` is licensed under the [Apache License, Version 2.0](LICENSE).

```bash
bdutil list
bdutil create dos ~/Downloads/windows.iso disk4 --scheme gpt --file-system fat32
bdutil create unix ~/Downloads/fedora.iso disk4
bdutil create macos "/Applications/macOS Sequoia (v15).app" disk4
bdutil --help
bdutil --version
```

## Get started

### Requirements

You need an Apple silicon Mac to run `bdutil`.

`bdutil` code relies on the new features and enhancements present in the macOS 15. It is because of that to build and install `bdutil` is only compatible with macOS 15 or newer.

### Install or upgrade

If you're installing or upgrading automatically, see the [HomeBrew](https://formulae.brew.sh/ancestral-labs/bdutil#default) documentation, searching for `bdutil`:

```bash
brew trust ancestral-labs/tap
brew tap ancestral-labs/tap
brew install bdutil
```
```bash
brew upgrade bdutil
```

Install manually the latest signed installer package for `bdutil` from the [GitHub release page](https://github.com/ancestral-labs/bdutil/releases).

To install the tool, copy the binary and resources in a directory included in the global path of macOS. Enter your administrator password when prompted, to give the brew formula permission to place the installed files under `/usr/local` or updating the path.

### Uninstall

Use the `uninstall-bdutil.sh` script to remove `bdutil` from your system. To remove your user data along with the tool, run:

```bash
brew uninstall bdutil
```

To uninstall `bdutil` manually, erase the folder where is located the binary and the resources files, usually on manual installations it is located on `/usr/local`.

## Next steps

- Take [a guided tour of `bdutil`](./Documentation/Tutorial.md) by building, running, and publishing a simple web server image.
- Learn how to [use various `bdutil` features](./Documentation/HowTo.md).
- Read a brief description and [technical overview](./Documentation/TechnicalOverview.md) of `bdutil`.
- View the project [API documentation](https://ancestral-labs.github.io/bdutil/Documentation/).

## Contributing

Contributions to `bdutil` are welcomed and encouraged. Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on how to get started.

## Project Status

The `bdutil` project is currently under active development. Its stability, both for consuming the project as a Swift package and the `bdutil` tool, is only guaranteed within minor versions, such as between 0.1.1 and 0.1.2. Minor version number releases may include breaking changes until we achieve a 1.0.0 release.

## Copyright

© 2023-2026 Ancestral Labs

Licensed under the Apache License, Version 2.0.
