
# `bclt`

BootKit Command Line Tool, aka `bclt`, is a CLI for create bootable media devices on your Mac. It's written in Swift, and optimized for Apple silicon.

The tool uses the BootKit library that depends on the WimKit library licensed under the LGPL License. At the moment, only WimKit is open source and the only repository that can be distributed with the terms of its license. 

`bclt` is under the EULA terms specified in the [LICENSE](LICENSE.md) file.

`bclt` uses the [BootKit](https://github.com/ancestral-labs/BootKit) Swift package for low level bootable media creation, process, and process management.

```bash
bclt create dos /path/to/windows.iso /dev/disk4 --scheme gpt --file-system fat32
bclt create unix /path/to/linux.iso /dev/disk4
bclt create unix /path/to/macos.dmg /dev/disk4
bclt --help
bclt --version
```

## Get started

### Requirements

You need an Apple silicon Mac to run `bclt`.

`bclt` code relies on the new features and enhancements present in the macOS 15. It is because of that to build and install `bclt` is only compatible with macOS 15 or newer.

### Install or upgrade

If you're installing or upgrading automatically, see the [HomeBrew](https://formulae.brew.sh/ancestral-labs/bclt#default) documentation, searching for `bclt`:

```bash
brew install ancestral-labs/bclt
```
```bash
brew update ancestral-labs/bclt
```

Install manually the latest signed installer package for `bclt` from the [GitHub release page](https://github.com/ancestral-labs/bclt/releases).

To install the tool, copy the binary and resources in a directory included in the global path of macOS. Enter your administrator password when prompted, to give the brew formula permission to place the installed files under `/usr/local` or updating the path.

### Uninstall

Use the `uninstall-bclt.sh` script to remove `bclt` from your system. To remove your user data along with the tool, run:

```bash
brew uninstall ancestral-labs/bclt
```

To uninstall `bclt` manually, erase the folder where is located the binary and the resources files, usually on manual installations it is located on `/usr/local`.

## Next steps

- Take [a guided tour of `bclt`](./Documentation/Tutorial.md) by building, running, and publishing a simple web server image.
- Learn how to [use various `bclt` features](./Documentation/HowTo.md).
- Read a brief description and [technical overview](./Documentation/TechnicalOverview.md) of `bclt`.
- View the project [API documentation](https://ancestral-labs.github.io/bclt/Documentation/).

## Contributing

Contributions to `bclt` are welcomed and encouraged.

## Project Status

The `bclt` project is currently under active development. Its stability, both for consuming the project as a Swift package and the `bclt` tool, is only guaranteed within minor versions, such as between 0.1.1 and 0.1.2. Minor version number releases may include breaking changes until we achieve a 1.0.0 release.

## Copyright

© 2023-2025 Ancestral Labs

All rights reserved
