<!-- markdownlint-disable-file first-line-h1 -->

<!-- ANCHOR: buildlocaltypstproject_example -->

```nix
{
  outputs = { nixpkgs, typst-nix }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    packages.${system}.default = typst-nix.lib.${system}.buildLocalTypstProject {
      fontPaths = [
        "${pkgs.roboto}/share/fonts/truetype"
      ];
    };
  };
}
```

<!-- ANCHOR_END: buildlocaltypstproject_example -->

<!-- ANCHOR: buildtypstproject_example -->

```nix
{
  outputs = { nixpkgs, typst-nix }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    packages.${system}.default = typst-nix.lib.${system}.buildTypstProject {
      fontPaths = [
        "${pkgs.roboto}/share/fonts/truetype"
      ];
    };
  };
}
```

<!-- ANCHOR_END: buildtypstproject_example -->

<!-- ANCHOR: mktypstderivation_example -->

```nix
{
  outputs = { nixpkgs, typst-nix }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    packages.${system}.default = typst-nix.lib.${system}.mkTypstDerivation {
      fontPaths = [
        "${pkgs.roboto}/share/fonts/truetype"
      ];
    };
  };
}
```

<!-- ANCHOR_END: mktypstderivation_example -->

<!-- ANCHOR: watchtypstproject_example -->

```nix
{
  outputs = { nixpkgs, typst-nix }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    apps.${system}.default = typst-nix.lib.${system}.watchTypstProject {
      fontPaths = [
        "${pkgs.roboto}/share/fonts/truetype"
      ];
    };
  };
}
```

<!-- ANCHOR_END: watchtypstproject_example -->
