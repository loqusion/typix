<!-- markdownlint-disable-file first-line-h1 -->

<!-- ANCHOR: buildtypstprojectlocal_example -->

```nix
{
  outputs = { nixpkgs, typix }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    inherit (pkgs) lib;

    build-script = typix.lib.${system}.buildTypstProjectLocal {
      fontPaths = [
        "${pkgs.roboto}/share/fonts/truetype"
      ];
    };
  in {
    apps.${system}.default = {
      type = "app";
      program = lib.getExe build-script;
    };
  };
}
```

<!-- ANCHOR_END: buildtypstprojectlocal_example -->

<!-- ANCHOR: buildtypstproject_example -->

```nix
{
  outputs = { nixpkgs, typix }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    packages.${system}.default = typix.lib.${system}.buildTypstProject {
      fontPaths = [
        "${pkgs.roboto}/share/fonts/truetype"
      ];
    };
  };
}
```

<!-- ANCHOR_END: buildtypstproject_example -->

<!-- ANCHOR: devshell_example -->

```nix
{
  outputs = { nixpkgs, typix }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    devShells.${system}.default = typix.lib.${system}.devShell {
      fontPaths = [
        "${pkgs.roboto}/share/fonts/truetype"
      ];
    };
  };
}
```

<!-- ANCHOR_END: devshell_example -->

<!-- ANCHOR: mktypstderivation_example -->

```nix
{
  outputs = { nixpkgs, typix }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    packages.${system}.default = typix.lib.${system}.mkTypstDerivation {
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
  outputs = { nixpkgs, typix }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    inherit (pkgs) lib;

    watch-script = typix.lib.${system}.watchTypstProject {
      fontPaths = [
        "${pkgs.roboto}/share/fonts/truetype"
      ];
    };
  in {
    apps.${system}.default = {
      type = "app";
      program = lib.getExe watch-script;
    };
  };
}
```

<!-- ANCHOR_END: watchtypstproject_example -->
