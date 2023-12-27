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
      src = myLib.cleanTypstSource ./simple;
    };

    devShell = myLib.devShell rec {
      checks = {
        simple = myLib.buildTypstProject {
          src = myLib.cleanTypstSource ./simple;
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
      src = myLib.cleanTypstSource ./simple;
    };
    simpleWithFonts = myLib.buildTypstProject {
      src = myLib.cleanTypstSource ./simple-with-fonts;
      fontPaths = [
        "${pkgs.roboto}/share/fonts/truetype"
      ];
    };
    simpleWithLocalPaths = myLib.buildTypstProject {
      src = myLib.cleanTypstSource ./simple-with-local-paths;
      localPaths = [
        {
          src = ./fixtures/icons;
          dest = "icons";
        }
      ];
    };

    watch = callPackage ./watch {};
  }))
