{
  inferTypstProjectOutput,
  lib,
  linkLocalPaths,
  pkgs,
  typst,
  typstOptsFromArgs,
}: args @ {
  fontPaths ? [],
  forceLocalPaths ? false,
  localPaths ? [],
  typstSource ? "main.typ",
  typstWatchCommand ? "typst watch",
  ...
}: let
  inherit (builtins) removeAttrs;
  inherit (lib) optionalString;
  inherit (lib.strings) concatStringsSep toShellVars;

  typstOptsString = args.typstOptsString or (typstOptsFromArgs args);
  typstOutput =
    args.typstOutput
    or (inferTypstProjectOutput (
      {inherit typstSource;} // args
    ));

  cleanedArgs = removeAttrs args [
    "fontPaths"
    "forceLocalPaths"
    "localPaths"
    "scriptName"
    "text"
    "typstOpts"
    "typstOptsString"
    "typstOutput"
    "typstSource"
    "typstWatchCommand"
  ];
in
  pkgs.writeShellApplication (cleanedArgs
    // {
      name = args.name or args.scriptName or "typst-watch";

      runtimeInputs =
        (args.runtimeInputs or [])
        ++ [
          typst
        ];

      text =
        optionalString (fontPaths != []) ''
          export TYPST_FONT_PATHS=${concatStringsSep ":" fontPaths}
        ''
        + optionalString (localPaths != []) (linkLocalPaths {
          inherit localPaths forceLocalPaths;
        })
        + ''

          ${toShellVars {inherit typstOutput typstSource;}}
          out=''${1:-''${typstOutput:?not defined}}
          ${typstWatchCommand} ${typstOptsString} "$typstSource" "$out"
        '';
    })
