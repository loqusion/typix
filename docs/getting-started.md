# Getting Started

First, [install Nix][install-nix]:

[install-nix]: https://github.com/DeterminateSystems/nix-installer

<!-- markdownlint-disable MD013 -->

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

<!-- markdownlint-enable MD013 -->

Make sure `nix-command` and `flakes` are enabled:

`~/.config/nix/nix.conf`

```ini
experimental-features = nix-command flakes
```

Finally, you can initialize a flake from the default template:

```bash
nix flake init --refresh -t github:loqusion/typix
```

> Alternatively, you can use a template demonstrating [Typst packages] usage:
>
> ```bash
> nix flake init --refresh -t 'github:loqusion/typix#with-typst-packages'
> ```
>
> [Typst packages]: ./recipes/using-typst-packages.md

---

Here are some commands you can run from any template:

- `nix run .#watch` — watch the input files and recompile on changes
- `nix run .#build` — compile and copy the output to the current directory

For more info, see [`nix run --help`](https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-run).
