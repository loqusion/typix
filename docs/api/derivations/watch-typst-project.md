# watchTypstProject

A derivation for a script that watches an input file and recompiles on changes.

This script is exposed to the user's environment, so expect the output to not be
reproducible.

## Parameters

**Note:** All parameters for [`writeShellApplication`][write-shell-application]
are also supported (besides `text`).

### `fontPaths` (optional) { #fontpaths }

### `forceLocalPaths` (optional) { #forcelocalpaths }

### `localPaths` (optional) { #localpaths }

### `typstOpts` (optional) { #typstopts }

### `typstProjectOutput` (optional) { #typstprojectoutput }

### `typstProjectSource` (optional) { #typstprojectsource }

### `typstWatchCommand` (optional) { #typstwatchcommand }

## Source

- [`watchTypstProject`](https://github.com/loqusion/typst.nix/blob/main/lib/watchTypstProject.nix)

[write-shell-application]: https://nixos.org/manual/nixpkgs/stable/#trivial-builder-writeShellApplication
