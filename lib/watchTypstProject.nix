{
  emojiFontPathFromString,
  inferTypstProjectOutput,
  lib,
  linkVirtualPaths,
  pkgs,
  typst,
  typstOptsFromArgs,
}: args @ {
  emojiFont ? "default",
  fontPaths ? [],
  forceVirtualPaths ? false,
  typstSource ? "main.typ",
  typstWatchCommand ? "typst watch",
  virtualPaths ? [],
  ...
}: let
  inherit (builtins) isNull removeAttrs;
  inherit (lib) lists optionalString;
  inherit (lib.strings) concatStringsSep toShellVars;

  emojiFontPath = emojiFontPathFromString emojiFont;
  allFontPaths = fontPaths ++ lists.optional (!isNull emojiFontPath) emojiFontPath;
  typstOptsString = args.typstOptsString or (typstOptsFromArgs args);
  typstOutput =
    args.typstOutput
    or (inferTypstProjectOutput (
      {inherit typstSource;} // args
    ));

  unsetSourceDateEpochScript = builtins.readFile ./setupHooks/unsetSourceDateEpochScript.sh;

  cleanedArgs = removeAttrs args [
    "emojiFont"
    "fontPaths"
    "forceVirtualPaths"
    "scriptName"
    "text"
    "typstOpts"
    "typstOptsString"
    "typstOutput"
    "typstSource"
    "typstWatchCommand"
    "virtualPaths"
  ];
in
  pkgs.writeShellApplication (cleanedArgs
    // {
      name = args.scriptName or args.name or "typst-watch";

      runtimeInputs =
        (args.runtimeInputs or [])
        ++ [
          pkgs.coreutils
          typst
        ];

      text =
        optionalString (allFontPaths != []) ''
          export TYPST_FONT_PATHS=${concatStringsSep ":" allFontPaths}
        ''
        + optionalString (virtualPaths != []) (linkVirtualPaths {
          inherit virtualPaths forceVirtualPaths;
        })
        + ''

          ${toShellVars {inherit typstOutput typstSource;}}
          out=''${1:-''${typstOutput:?not defined}}
          mkdir -p "$(dirname "$out")"

          ${unsetSourceDateEpochScript}

          ${typstWatchCommand} ${typstOptsString} "$typstSource" "$out"
        '';
    })
