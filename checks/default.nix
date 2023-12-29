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

    devShell = myLib.devShell rec {
      inherit localPaths;
      checks = {
        simple = myLib.buildTypstProject {
          inherit localPaths typstProjectSource;
          src = myLib.cleanTypstSource ./simple;
        };
      };
    };

    overlappingLocalPaths = isInvariant: util: file:
      util (let
        op =
          if isInvariant
          then "!="
          else "=";
        errorMsg =
          if isInvariant
          then ''$FILE_TO_CHECK was overwritten\; it should stay the same when forceLocalPaths is false''
          else ''$FILE_TO_CHECK was not overwritten\; it should be overwritten when forceLocalPaths is true'';
      in {
        FILE_TO_CHECK = file;
        preBuild = ''
          if [ ! -e "$FILE_TO_CHECK" ]; then
            echo "$FILE_TO_CHECK does not exist; unable to run check"
            exit 1
          fi
          hash=$(sha256sum "$FILE_TO_CHECK" | awk '{ print $1 }')
          if [ -z "$hash" ]; then
            echo "unable to obtain hash for $FILE_TO_CHECK"
            exit 1
          fi
        '';
        postBuild = ''
          hash=''${hash:?not defined}
          new_hash=$(sha256sum "$FILE_TO_CHECK" | awk '{ print $1 }')
          if [ -z "$new_hash" ]; then
            echo "unable to obtain hash for $FILE_TO_CHECK"
            exit 1
          fi
          if [ "$hash" ${op} "$new_hash" ]; then
            echo ${errorMsg}
            echo
            echo "old hash: $hash"
            echo "new hash: $new_hash"
            exit 1
          fi
        '';
      }) {
        inherit localPaths typstProjectSource;
        src = ./overlapping-local-paths;
        forceLocalPaths = !isInvariant;
      };
    overlappingLocalPathsInvariant = overlappingLocalPaths true;
    overlappingLocalPathsForce = overlappingLocalPaths false;

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

    watchOverlappingLocalPaths = overlappingLocalPathsInvariant watch "icons/link.svg";
  }))
