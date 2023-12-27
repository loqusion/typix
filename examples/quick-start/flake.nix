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

      commonArgs = {
        src = ./.;
        typstProjectSource = "main.typ";

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

      build-local = typstNixLib.buildLocalTypstProject {
        inherit (commonArgs) src typstProjectSource fontPaths localPaths;
      };

      watch-drv = typstNixLib.watchTypstProject {
        inherit (commonArgs) typstProjectSource fontPaths localPaths;
      };
    in {
      packages.default = typstNixLib.buildTypstProject {
        inherit (commonArgs) src typstProjectSource fontPaths localPaths;
      };

      apps = rec {
        default = watch;
        build = flake-utils.lib.mkApp {
          drv = build-local;
        };
        watch = flake-utils.lib.mkApp {
          drv = watch-drv;
        };
      };

      devShells.default = typstNixLib.devShell {
        packages = [
          build-local
          watch-drv
          # pkgs.typstfmt
        ];
      };
    });
}
