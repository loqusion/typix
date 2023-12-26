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
        typstOpts = {format = "pdf";};
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
    typstOpts = {format = "pdf";};
  };
  simpleWithFonts = myLib.buildTypstProject {
    src = ./simple-with-fonts;
    typstOpts = {format = "pdf";};
    fontPaths = [
      "${pkgs.roboto}/share/fonts/truetype"
    ];
  };
  simpleWithLocalPaths = myLib.buildTypstProject {
    src = ./simple-with-local-paths;
    typstOpts = {format = "pdf";};
    localPaths = [
      {
        src = ./fixtures/icons;
        dest = "icons";
      }
    ];
  };
}
