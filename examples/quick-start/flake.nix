{
  description = "A Typst project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    typst-nix = {
      url = "github:loqusion/typst.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    typst-nix,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      inherit (pkgs) lib;

      typstNixLib = typst-nix.lib.${system};

      commonArgs = {
        src = ./.;
        typstProjectSource = "main.typ";
      };

      watch-drv = typstNixLib.watchTypstProject {
        inherit (commonArgs) typstProjectSource;
      };

      buildToRootDrv = output:
        pkgs.writeShellScriptBin "typst-build" ''
          nix_out_path=$(nix build .#default --no-link --print-out-paths)
          cp -L --no-preserve=mode "$nix_out_path" ${lib.strings.escapeShellArg output}
        '';
    in {
      packages.default = typstNixLib.buildTypstProject {
        inherit (commonArgs) src typstProjectSource;
      };

      apps = rec {
        default = watch;
        watch = flake-utils.lib.mkApp {
          drv = watch-drv;
        };
        build = flake-utils.lib.mkApp {
          drv = buildToRootDrv "main.pdf";
        };
      };

      devShells.default = typstNixLib.devShell {
        packages = [
          watch-drv
          (buildToRootDrv "main.pdf")
          # pkgs.typstfmt
        ];
      };
    });
}
