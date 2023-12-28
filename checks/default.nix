{
  pkgs,
  myLib,
}: let
  inherit (pkgs) lib;
  onlyDrvs = lib.filterAttrs (_: lib.isDerivation);
in
  onlyDrvs (lib.makeScope myLib.newScope (self: let
    callPackage = self.newScope {};
    typstProjectSource = "main.typ";
    fontPaths = [
      "${pkgs.roboto}/share/fonts/truetype"
    ];
    localPaths = [
      {
        src = ./fixtures/icons;
        dest = "icons";
      }
    ];
  in rec {
    buildLocal = callPackage ./build-local.nix {};
    buildLocalSimple = buildLocal {
      inherit typstProjectSource;
      src = myLib.cleanTypstSource ./simple;
    };
    buildLocalSimpleWithFonts = buildLocal {
      inherit fontPaths typstProjectSource;
      src = myLib.cleanTypstSource ./simple-with-fonts;
    };
    buildLocalSimpleWithLocalPaths = buildLocal {
      inherit localPaths typstProjectSource;
      src = myLib.cleanTypstSource ./simple-with-local-paths;
    };

    devShell = myLib.devShell rec {
      inherit localPaths;
      checks = {
        simple = myLib.buildTypstProject {
          inherit localPaths typstProjectSource;
          src = myLib.cleanTypstSource ./simple;
        };
      };
    };

    simple = myLib.buildTypstProject {
      inherit typstProjectSource;
      src = myLib.cleanTypstSource ./simple;
    };
    simpleWithFonts = myLib.buildTypstProject {
      inherit fontPaths typstProjectSource;
      src = myLib.cleanTypstSource ./simple-with-fonts;
    };
    simpleWithLocalPaths = myLib.buildTypstProject {
      inherit localPaths typstProjectSource;
      src = myLib.cleanTypstSource ./simple-with-local-paths;
    };

    watch = callPackage ./watch.nix {};
    watchSimple = watch {
      inherit typstProjectSource;
      src = myLib.cleanTypstSource ./simple;
    };
    watchSimpleWithFonts = watch {
      inherit fontPaths typstProjectSource;
      src = myLib.cleanTypstSource ./simple-with-fonts;
    };
    watchSimpleWithLocalPaths = watch {
      inherit localPaths typstProjectSource;
      src = myLib.cleanTypstSource ./simple-with-local-paths;
    };
  }))
