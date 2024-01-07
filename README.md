# typst.nix

## Getting Started

After [installing Nix](https://nixos.org/download#download-nix), you can
initialize a flake from the default template:

```bash
nix flake init -t github:loqusion/typst.nix
```

Here are some commands you can run from the default template:

- `nix run .#watch` — watch the input files and recompile on changes
- `nix run .#build` — compile and copy the output to the current directory

For more information, check out [the
docs](https://loqusion.github.io/typst.nix/).
