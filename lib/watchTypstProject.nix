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
  typstProjectSource ? "main.typ",
  typstWatchCommand ? "typst watch",
  ...
}: let
  inherit (builtins) removeAttrs;
  inherit (lib) optionalString;
  inherit (lib.strings) concatStringsSep escapeShellArg;

  typstOpts = typstOptsFromArgs (args.typstOpts or {});
  typstProjectOutput =
    args.typstProjectOutput
    or (inferTypstProjectOutput (
      {inherit typstProjectSource;} // args
    ));

  cleanedArgs = removeAttrs args [
    "fontPaths"
    "forceLocalPaths"
    "localPaths"
    "text"
    "typstOpts"
    "typstProjectOutput"
    "typstProjectSource"
    "typstWatchCommand"
  ];
in
  pkgs.writeShellApplication (cleanedArgs
    // {
      name = args.name or "typst-watch";

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

          ${typstWatchCommand} ${typstOpts} ${escapeShellArg typstProjectSource} ${escapeShellArg typstProjectOutput}
        '';
    })
