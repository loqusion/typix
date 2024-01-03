# Getting Started

First, [install Nix](https://nixos.org/download#download-nix):

```bash
bash <(curl -L https://nixos.org/nix/install)
```

Then, you can initialize a flake from the default template:

```bash
nix flake init -t github:loqusion/typst.nix
```

---

Here are some commands you can run from the default template:

- `nix run .#watch` — watch the input files and recompile on changes
- `nix run .#build` — compile and copy the output to the current directory

For more info, see [`nix run --help`](https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-run).
