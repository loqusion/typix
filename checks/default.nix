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
    buildLocalSimple = buildLocal {} {
      inherit typstProjectSource;
      src = myLib.cleanTypstSource ./simple;
    };
    buildLocalSimpleWithFonts = buildLocal {} {
      inherit fontPaths typstProjectSource;
      src = myLib.cleanTypstSource ./simple-with-fonts;
    };
    buildLocalSimpleWithLocalPaths = buildLocal {} {
      inherit localPaths typstProjectSource;
      src = myLib.cleanTypstSource ./simple-with-local-paths;
    };

    buildLocalOverlappingLocalPaths = overlappingLocalPaths buildLocal "icons/link.svg";

    devShell = myLib.devShell rec {
      inherit localPaths;
      checks = {
        simple = myLib.buildTypstProject {
          inherit localPaths typstProjectSource;
          src = myLib.cleanTypstSource ./simple;
        };
      };
    };

    overlappingLocalPaths = util: invariantFile:
      util {
        INVARIANT_FILE = invariantFile;
        preBuild = ''
          hash=$(sha256sum "$INVARIANT_FILE" | awk '{ print $1 }')
        '';
        postBuild = ''
          hash=''${hash:?not defined}
          new_hash=$(sha256sum "$INVARIANT_FILE" | awk '{ print $1 }')
          if [ "$hash" != "$new_hash" ]; then
            echo "$INVARIANT_FILE has been overwritten by watchTypstProject when it should have stayed the same"
            echo
            echo "old hash: $hash"
            echo "new hash: $new_hash"
            exit 1
          fi
        '';
      } {
        inherit localPaths typstProjectSource;
        src = ./overlapping-local-paths;
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
    watchSimple = watch {} {
      inherit typstProjectSource;
      src = myLib.cleanTypstSource ./simple;
    };
    watchSimpleWithFonts = watch {} {
      inherit fontPaths typstProjectSource;
      src = myLib.cleanTypstSource ./simple-with-fonts;
    };
    watchSimpleWithLocalPaths = watch {} {
      inherit localPaths typstProjectSource;
      src = myLib.cleanTypstSource ./simple-with-local-paths;
    };

    watchOverlappingLocalPaths = overlappingLocalPaths watch "icons/link.svg";
  }))
