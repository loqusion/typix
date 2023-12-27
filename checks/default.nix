{
  pkgs,
  myLib,
}: let
  inherit (pkgs) lib;
  onlyDrvs = lib.filterAttrs (_: lib.isDerivation);
in
  onlyDrvs (lib.makeScope myLib.newScope (self: let
    callPackage = self.newScope {};
  in {
    buildLocal = myLib.buildLocalTypstProject {
      src = ./simple;
    };

    devShell = myLib.devShell rec {
      checks = {
        simple = myLib.buildTypstProject {
          src = ./simple;
          inherit localPaths;
        };
      };
      localPaths = [
        {
          src = ./fixtures/icons;
          dest = "icons";
        }
      ];
    };

    simple = myLib.buildTypstProject {
      src = ./simple;
    };
    simpleWithFonts = myLib.buildTypstProject {
      src = ./simple-with-fonts;
      fontPaths = [
        "${pkgs.roboto}/share/fonts/truetype"
      ];
    };
    simpleWithLocalPaths = myLib.buildTypstProject {
      src = ./simple-with-local-paths;
      localPaths = [
        {
          src = ./fixtures/icons;
          dest = "icons";
        }
      ];
    };

    watch = callPackage ./watch {};
  }))
