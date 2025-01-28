{
  emojiFontPathFromString,
  lib,
  linkVirtualPaths,
  mkShellNoCC,
  typst,
}: args @ {
  checks ? {},
  emojiFont ? "default",
  extraShellHook ? "",
  fontPaths ? [],
  forceVirtualPaths ? false,
  inputsFrom ? [],
  packages ? [],
  virtualPaths ? [],
  ...
}: let
  inherit (builtins) isNull removeAttrs;
  inherit (lib) lists optionalAttrs optionalString;
  inherit (lib.strings) concatStringsSep;

  emojiFontPath = emojiFontPathFromString emojiFont;
  allFontPaths = fontPaths ++ lists.optional (!isNull emojiFontPath) emojiFontPath;

  unsetSourceDateEpochScript = builtins.readFile ./setupHooks/unsetSourceDateEpochScript.sh;

  cleanedArgs = removeAttrs args [
    "checks"
    "emojiFont"
    "extraShellHook"
    "fontPaths"
    "forceVirtualPaths"
    "inputsFrom"
    "virtualPaths"
  ];
in
  mkShellNoCC (cleanedArgs
    // optionalAttrs (allFontPaths != []) {
      TYPST_FONT_PATHS = concatStringsSep ":" allFontPaths;
    }
    // {
      inputsFrom = builtins.attrValues checks ++ inputsFrom;

      packages =
        [
          typst
        ]
        ++ packages;

      shellHook =
        args.shellHook
        or (optionalString (virtualPaths != []) (linkVirtualPaths {
          inherit virtualPaths forceVirtualPaths;
        }))
        + ''
          ${unsetSourceDateEpochScript}
        ''
        + optionalString (extraShellHook != "") ''

          ${extraShellHook}
        '';
    })
