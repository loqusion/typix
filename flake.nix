{
  description = "";

  nixConfig = {
    extra-substituters = ["https://typst-nix.cachix.org"];
    extra-trusted-public-keys = ["typst-nix.cachix.org-1:OzDUMt0nd4wlI1AHucBPnchl4utWXeFTtUFt8XZ3DbA="];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {nixpkgs, ...}: let
    inherit (nixpkgs) lib;

    linux32BitSystems = ["i686-linux"];
    linux64BitSystems = ["x86_64-linux" "aarch64-linux"];
    linuxSystems = linux32BitSystems ++ linux64BitSystems;
    darwinSystems = ["x86_64-darwin" "aarch64-darwin"];
    systems = linuxSystems ++ darwinSystems;

    forAllSystems = lib.genAttrs systems;

    pkgsFor = lib.genAttrs systems (system: nixpkgs.legacyPackages.${system});

    mkLib = pkgs:
      import ./lib {
        inherit (pkgs) lib newScope;
      };

    mkReleaseScript = pkgs:
      import ./release.nix {
        inherit pkgs;
      };
  in {
    inherit mkLib;

    overlays.default = _final: _prev: {};

    templates = rec {
      default = quick-start;
      quick-start = {
        description = "A Typst project";
        path = ./examples/quick-start;
      };
    };

    checks = forAllSystems (system: let
      pkgs = pkgsFor.${system};
    in (pkgs.callPackages ./checks {
      inherit pkgs;
      myLib = mkLib pkgs;
    }));

    lib = forAllSystems (system: mkLib pkgsFor.${system});

    packages = forAllSystems (system: (
      import ./pkgs.nix {pkgs = pkgsFor.${system};}
    ));

    apps = forAllSystems (system: {
      release = {
        type = "app";
        program = lib.getExe (mkReleaseScript pkgsFor.${system});
      };
    });

    formatter = forAllSystems (system: pkgsFor.${system}.alejandra);

    devShells = forAllSystems (system: let
      pkgs = pkgsFor.${system};
    in {
      default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          alejandra
          markdownlint-cli
          mdbook
          nodePackages.prettier
        ];
      };
    });
  };
}
