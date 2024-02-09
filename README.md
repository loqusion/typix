<h1 align="center">
  <img
    src="https://raw.githubusercontent.com/loqusion/typix/main/.github/assets/logo_1544x1544.png"
    alt="Typix Logo"
    width="150"
  /><br />
  Typix
</h1>

Typix aims to make it easier to use [Nix](https://nixos.org/) in
[Typst](https://github.com/typst/typst) projects.

- **Dependency management**: supports arbitrary dependencies including fonts,
  images, and data
- **Reproducible**: via a hermetically sealed build environment

## Features

- Automatically fetch dependencies and compile in a single command (`nix run
.#build`)
- Watch input files and recompile on changes (`nix run .#watch`)
- Set up a shell environment with all dependencies made available via
  environment variables and symlinks
- Extensible via
  [`mkTypstDerivation`](https://loqusion.github.io/typix/api/derivations/mk-typst-derivation.html)
- Support for dependencies such as:
  - [fonts](https://typst.app/docs/reference/text/text/#parameters-font)
  - [images](https://typst.app/docs/reference/visualize/image/)
  - [data](https://typst.app/docs/reference/data-loading/)

[Typst packages](https://typst.app/docs/packages/) are currently unsupported,
however there is a
[workaround](https://loqusion.github.io/typix/recipes/using-typst-packages.html).

## Getting Started

After [installing Nix](https://nixos.org/download#download-nix) and [enabling
flakes](https://nixos.wiki/wiki/Flakes#Enable_flakes_permanently_in_NixOS), you
can initialize a flake from the default template:

```bash
nix flake init -t github:loqusion/typix
```

Here are some commands you can run from the default template:

- `nix run .#watch` — watch the input files and recompile on changes
- `nix run .#build` — compile and copy the output to the current directory

---

For more information, check out [the docs](https://loqusion.github.io/typix/).
