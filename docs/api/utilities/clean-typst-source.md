# cleanTypstSource

Filters a source tree to only contain files that are usually pertinent to a
Typst project.

<!-- markdownlint-disable heading-increment -->

#### Example

<!-- markdownlint-restore -->

```nix
{
  outputs = {
    nixpkgs,
    typix,
  }: let
    system = "x86_64-linux";
    typixLib = typix.lib.${system};
  in {
    packages.${system}.default = typixLib.mkTypstDerivation {
      src = typixLib.cleanTypstSource ./.;
    };
  };
}
```
