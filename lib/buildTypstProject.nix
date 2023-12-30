{
  lib,
  mkTypstDerivation,
  typstOptsFromArgs,
}: args @ {
  typstCompileCommand ? "typst compile",
  typstSource ? "main.typ",
  ...
}: let
  inherit (builtins) removeAttrs;
  inherit (lib.strings) escapeShellArg;

  typstOptsString = args.typstOptsString or (typstOptsFromArgs args);
  cleanedArgs = removeAttrs args [
    "typstCompileCommand"
    "typstOpts"
    "typstOptsString"
    "typstOutput"
    "typstSource"
  ];
in
  mkTypstDerivation (cleanedArgs
    // {
      buildPhaseTypstCommand =
        args.buildPhaseTypstCommand
        or ''
          ${typstCompileCommand} ${typstOptsString} ${escapeShellArg typstSource} "$out"
        '';
    })
