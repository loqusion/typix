# Declaring a shell environment

You can automatically pull your project's dependencies into your shell by
declaring a [shell environment][nix-dev-declarative-shell] and then activating
it with [`nix develop`][nix-ref-develop] or [`direnv`][direnv].

Here's an example in a flake using Typst.nix's
[`devShell`](../api/derivations/dev-shell.md):

```nix
{
  outputs = { typst-nix }: let
    system = "x86_64-linux";
    typstNixLib = typst-nix.lib.${system};

    watch-script = typstNixLib.watchTypstProject {/* ... */};
  in {
    # packages, apps, etc. omitted

    devShells.${system}.default = typstNixLib.devShell {
      fontPaths = [/* ... */];
      localPaths = [/* ... */];
      packages = [
        watch-script
      ];
    };
  };
}
```

What this example does does:

- Fonts added to [`fontPaths`](../api/derivations/dev-shell.md#fontpaths) will
  be made available to `typst` commands via the `TYPST_FONT_PATHS` environment
  variable.
- Files in [`localPaths`](../api/derivations/dev-shell.md#localpaths) will be
  recursively symlinked to the current directory (only overwriting existing
  files when
  [`forceLocalPaths`](../api/derivations/dev-shell.md#forcelocalpaths) is
  `true`).
- For convenience, the
  [`typst-watch`](../api/derivations/watch-typst-project.md#scriptname) script
  is added, which will run
  [`watchTypstProject`](../api/derivations/watch-typst-project.md).

[direnv]: https://direnv.net/
[nix-dev-declarative-shell]: https://nix.dev/tutorials/first-steps/declarative-shell
[nix-ref-develop]: https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-develop
[nix-ref-nixpkgs-mkshell--packages]: https://nixos.org/manual/nixpkgs/stable/#sec-pkgs-mkShell-attributes
