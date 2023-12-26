{
  pkgs,
  myLib,
}: let
  inherit (pkgs) lib;
in {
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
}
