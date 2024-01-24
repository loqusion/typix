# cleanTypstSource

Filters a source tree to only contain `*.typ` files and special files such as
[`typst.toml`][typst-blog-package-manager].

<!-- markdownlint-disable heading-increment -->

#### Example

<!-- markdownlint-restore -->

```nix
{
  outputs = { nixpkgs, typix }: let
    system = "x86_64-linux";
    typixLib = typix.lib.${system};
  in {
    packages.${system}.default = typixLib.mkTypstDerivation {
      src = typixLib.cleanTypstSource ./.;
    };
  };
}
```

[typst-blog-package-manager]: https://typst.app/blog/2023/package-manager/#package-format
