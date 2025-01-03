{
  pkgs,
  myLib,
}: let
  inherit (pkgs) lib;
  onlyDrvs = lib.filterAttrs (_: lib.isDerivation);
in
  onlyDrvs (lib.makeScope myLib.newScope (self: let
    callPackage = self.newScope {};
    typstSource = "main.typ";
    fontPaths = [
      "${pkgs.roboto}/share/fonts/truetype"
    ];
    virtualPaths = [
      {
        src = ./fixtures/icons;
        dest = "icons";
      }
    ];
  in rec {
    buildLocal = callPackage ./build-local.nix {};
    buildLocalSimple = buildLocal {} {
      inherit typstSource;
      src = myLib.cleanTypstSource ./simple;
    };
    buildLocalSimpleWithFonts = buildLocal {} {
      inherit fontPaths typstSource;
      src = myLib.cleanTypstSource ./simple-with-fonts;
    };
    buildLocalSimpleWithVirtualPaths = buildLocal {} {
      inherit virtualPaths typstSource;
      src = myLib.cleanTypstSource ./simple-with-virtual-paths;
    };

    clean = myLib.mkTypstDerivation {
      src = myLib.cleanTypstSource ./clean;
      EXPECTED_SRC = ./clean-expected;
      buildPhaseTypstCommand = ''
        diff -r "$src" "$EXPECTED_SRC"
        touch $out
      '';
    };

    date = myLib.buildTypstProject {
      inherit typstSource;
      src = myLib.cleanTypstSource ./date;
    };
    dateWatch = watch {} {
      inherit typstSource;
      src = myLib.cleanTypstSource ./date;
    };

    devShell = myLib.devShell {
      inherit virtualPaths;
      checks = {
        simple = myLib.buildTypstProject {
          inherit virtualPaths typstSource;
          src = myLib.cleanTypstSource ./simple;
        };
      };
    };

    overlappingVirtualPaths = isInvariant: util: file:
      util (let
        op =
          if isInvariant
          then "!="
          else "=";
        errorMsg =
          if isInvariant
          then ''$FILE_TO_CHECK was overwritten\; it should stay the same when forceVirtualPaths is false''
          else ''$FILE_TO_CHECK was not overwritten\; it should be overwritten when forceVirtualPaths is true'';
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
        inherit virtualPaths typstSource;
        src = ./overlapping-virtual-paths;
        forceVirtualPaths = !isInvariant;
      };
    overlappingVirtualPathsInvariant = overlappingVirtualPaths true;
    overlappingVirtualPathsForce = overlappingVirtualPaths false;

    simple = myLib.buildTypstProject {
      inherit typstSource;
      src = myLib.cleanTypstSource ./simple;
    };
    simpleWithFonts = myLib.buildTypstProject {
      inherit fontPaths typstSource;
      src = myLib.cleanTypstSource ./simple-with-fonts;
    };
    # TODO: add support for typst packages
    # simpleWithTypstPackages = myLib.buildTypstProject {
    #   inherit typstSource;
    #   src = myLib.cleanTypstSource ./simple-with-typst-packages;
    # };
    simpleWithVirtualPaths = myLib.buildTypstProject {
      inherit virtualPaths typstSource;
      src = myLib.cleanTypstSource ./simple-with-virtual-paths;
    };

    virtualPathsChecks = callPackage ./virtual-paths.nix {};

    watch = callPackage ./watch.nix {};
    watchSimple = watch {} {
      inherit typstSource;
      src = myLib.cleanTypstSource ./simple;
    };
    watchSimpleWithFonts = watch {} {
      inherit fontPaths typstSource;
      src = myLib.cleanTypstSource ./simple-with-fonts;
    };
    # TODO: see above
    # watchSimpleWithTypstPackages = watch {} {
    #   inherit typstSource;
    #   src = myLib.cleanTypstSource ./simple-with-typst-packages;
    # };
    watchSimpleWithVirtualPaths = watch {} {
      inherit virtualPaths typstSource;
      src = myLib.cleanTypstSource ./simple-with-virtual-paths;
    };

    watchOverlappingVirtualPaths = overlappingVirtualPathsInvariant watch "icons/link.svg";
    watchOverlappingVirtualPathsForce = overlappingVirtualPathsForce watch "icons/link.svg";
  }))
