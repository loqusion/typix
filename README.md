<h1 align="center">
  <img
    src="https://raw.githubusercontent.com/loqusion/typix/main/.github/assets/logo_1544x1544.png"
    alt="Typix Logo"
    width="150"
  /><br />
  Typix
</h1>

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

For more information, check out [the docs](https://loqusion.github.io/typix/).
