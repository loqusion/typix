{
  description = "A Typst project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    typst-nix = {
      url = "github:loqusion/typst.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";

    # Example of downloading icons from a non-flake source
    # font-awesome = {
    #   url = "github:FortAwesome/Font-Awesome";
    #   flake = false;
    # };
  };

  outputs = inputs @ {
    nixpkgs,
    typst-nix,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      inherit (pkgs) lib;

      typstNixLib = typst-nix.lib.${system};

      typstProjectSource = "main.typ";
      commonArgs = {
        src = ./.;
        inherit typstProjectSource;

        fontPaths = [
          # Add paths to fonts here
          # "${pkgs.roboto}/share/fonts/truetype"
        ];

        localPaths = [
          # Add paths that must be locally accessible to typst here
          # {
          #   dest = "icons";
          #   src = "${inputs.font-awesome}/svgs/regular";
          # }
        ];
      };

      watch-drv = typstNixLib.watchTypstProject {
        inherit (commonArgs) typstProjectSource fontPaths localPaths;
      };

      buildToRootDrv = output:
        pkgs.writeShellScriptBin "typst-build" ''
          nix_out_path=$(nix build .#default --no-link --print-out-paths)
          cp -L --no-preserve=mode "$nix_out_path" ${lib.strings.escapeShellArg output}
        '';
    in {
      packages.default = typstNixLib.buildTypstProject {
        inherit (commonArgs) src typstProjectSource fontPaths localPaths;
      };

      apps = rec {
        default = watch;
        watch = flake-utils.lib.mkApp {
          drv = watch-drv;
        };
        build = flake-utils.lib.mkApp {
          drv = buildToRootDrv (typstNixLib.inferTypstProjectOutput typstProjectSource);
        };
      };

      devShells.default = typstNixLib.devShell {
        packages = [
          watch-drv
          (buildToRootDrv (typstNixLib.inferTypstProjectOutput typstProjectSource))
          # pkgs.typstfmt
        ];
      };
    });
}
