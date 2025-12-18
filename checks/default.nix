{
  pkgs,
  myLib,
}: let
  inherit (pkgs) lib;
  inherit (lib.strings) escapeShellArg concatMapStringsSep;
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
    unstable_typstPackages = [
      {
        name = "example";
        version = "0.1.0";
        hash = "sha256-R18Xv3AoZsTtMycRasczTsje5yIfiURIxtDICQ4mvho=";
      }
      {
        name = "cetz";
        version = "0.3.4";
        hash = "sha256-5w3UYRUSdi4hCvAjrp9HslzrUw7BhgDdeCiDRHGvqd4=";
      }
      {
        name = "polylux";
        version = "0.4.0";
        hash = "sha256-4owP2KiyaaASS1YZ0Hs58k6UEVAqsRR3YdGF26ikosk=";
      }
      # Required by cetz
      {
        name = "oxifmt";
        version = "0.2.1";
        hash = "sha256-8PNPa9TGFybMZ1uuJwb5ET0WGIInmIgg8h24BmdfxlU=";
      }
    ];
    nixpkgs_typstPackages = with pkgs.typstPackages; [example cetz polylux];
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
    buildLocalWithMultipleParameters = buildLocal {} {
      inherit typstSource;
      src = myLib.cleanTypstSource ./simple-with-multiple-parameters;
      typstOpts = {
        input = ["key1=value1" "key2=value2" "key3= --spaces-are-properly-escaped" "key4='quotes-are-properly-escaped\""];
      };
    };
    buildLocalWithTypstPackages = buildLocal {} {
      inherit typstSource;
      src = myLib.cleanTypstSource ./typst-packages;
      inherit unstable_typstPackages;
    };
    buildLocalWithReproducibleTypstPackages = buildLocal {} {
      inherit typstSource;
      src = myLib.cleanTypstSource ./typst-packages;
      inherit nixpkgs_typstPackages;
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

    checkEmojiScript = {
      inputs =
        (with pkgs; [
          python312
          python312Packages.emoji
        ])
        ++ (
          with pkgs.python312Packages; [
            # Referencing `emoji` doesn't work here because an attribute of that
            # name already exists in a recursive attribute set (`rec {...}`)
            pdfplumber
          ]
        );
      script = patterns: ''
        python3.12 ${./check-emojis.py} "$out" ${concatMapStringsSep " " escapeShellArg patterns}
      '';
    };

    emoji = {
      emojiFont,
      fontPaths ? [],
      patterns,
    }: (myLib.buildTypstProject ({
        inherit typstSource fontPaths;
        src = myLib.cleanTypstSource ./emoji;
        doCheck = true;
        nativeCheckInputs = checkEmojiScript.inputs;
        checkPhase = checkEmojiScript.script patterns;
      }
      // lib.optionalAttrs (emojiFont != "__OMIT__") {
        inherit emojiFont;
      }));
    emojiOmit = emoji {
      emojiFont = "__OMIT__";
      patterns = ["emoji"];
    };
    emojiTwemoji = emoji {
      emojiFont = "twemoji";
      patterns = ["emoji"];
    };
    emojiTwemojiCbdt = emoji {
      emojiFont = "twemoji-cbdt";
      patterns = ["emoji"];
    };
    emojiNoto = emoji {
      emojiFont = "noto";
      patterns = ["emoji"];
    };
    emojiNotoMonochrome = emoji {
      emojiFont = "noto-monochrome";
      patterns = ["emoji"];
    };
    # FIXME: https://github.com/loqusion/typix/issues/79
    # emojiEmojiOne = emoji {
    #   emojiFont = "emojione";
    #   patterns = ["emoji"];
    # };
    emojiFontOverride = emoji {
      emojiFont = null;
      fontPaths = ["${pkgs.noto-fonts-color-emoji}/share/fonts/noto"];
      patterns = ["emoji"];
    };

    emojiWatch = {
      emojiFont,
      fontPaths ? [],
      patterns,
    }: (watch {
        nativeBuildInputs = checkEmojiScript.inputs;
        postBuild = checkEmojiScript.script patterns;
      } ({
          inherit typstSource fontPaths;
          src = myLib.cleanTypstSource ./emoji;
        }
        // lib.optionalAttrs (emojiFont != "__OMIT__") {
          inherit emojiFont;
        }));
    emojiWatchOmit = emojiWatch {
      emojiFont = "__OMIT__";
      patterns = ["emoji"];
    };
    emojiWatchTwemoji = emojiWatch {
      emojiFont = "twemoji";
      patterns = ["emoji"];
    };
    emojiWatchTwemojiCbdt = emojiWatch {
      emojiFont = "twemoji-cbdt";
      patterns = ["emoji"];
    };
    emojiWatchNoto = emojiWatch {
      emojiFont = "noto";
      patterns = ["emoji"];
    };
    emojiWatchNotoMonochrome = emojiWatch {
      emojiFont = "noto-monochrome";
      patterns = ["emoji"];
    };
    # FIXME: https://github.com/loqusion/typix/issues/79
    # emojiWatchEmojiOne = emojiWatch {
    #   emojiFont = "emojione";
    #   patterns = ["emoji"];
    # };
    emojiWatchFontOverride = emojiWatch {
      emojiFont = null;
      fontPaths = ["${pkgs.noto-fonts-color-emoji}/share/fonts/noto"];
      patterns = ["emoji"];
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
    simpleWithMultipleParameters = myLib.buildTypstProject {
      inherit typstSource;
      src = myLib.cleanTypstSource ./simple-with-multiple-parameters;
      typstOpts = {
        input = ["key1=value1" "key2=value2" "key3= --spaces-are-properly-escaped" "key4='quotes-are-properly-escaped\""];
      };
    };
    simpleWithVirtualPaths = myLib.buildTypstProject {
      inherit virtualPaths typstSource;
      src = myLib.cleanTypstSource ./simple-with-virtual-paths;
    };

    withTypstPackages = myLib.buildTypstProject {
      inherit typstSource;
      src = myLib.cleanTypstSource ./typst-packages;
      inherit unstable_typstPackages;
    };

    withReproducibleTypstPackages = myLib.buildTypstProject {
      inherit typstSource;
      src = myLib.cleanTypstSource ./typst-packages;
      inherit nixpkgs_typstPackages;
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
    watchWithMultipleParameters = watch {} {
      inherit typstSource;
      src = myLib.cleanTypstSource ./simple-with-multiple-parameters;
      typstOpts = {
        input = ["key1=value1" "key2=value2" "key3= --spaces-are-properly-escaped" "key4='quotes-are-properly-escaped\""];
      };
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
