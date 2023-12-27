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
        src = typstNixLib.cleanTypstSource ./.;
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

      build-script = typstNixLib.buildLocalTypstProject {
        inherit (commonArgs) src typstProjectSource fontPaths localPaths;
      };

      watch-script = typstNixLib.watchTypstProject {
        inherit (commonArgs) typstProjectSource fontPaths localPaths;
      };
    in {
      packages.default = typstNixLib.buildTypstProject {
        inherit (commonArgs) src typstProjectSource fontPaths localPaths;
      };

      apps = rec {
        default = watch;
        build = flake-utils.lib.mkApp {
          drv = build-script;
        };
        watch = flake-utils.lib.mkApp {
          drv = watch-script;
        };
      };

      devShells.default = typstNixLib.devShell {
        inherit (commonArgs) fontPaths localPaths;
        packages = [
          build-script
          watch-script
          # pkgs.typstfmt
        ];
      };
    });
}
