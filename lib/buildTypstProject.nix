{
  lib,
  mkTypstDerivation,
  typstOptsFromArgs,
}: args @ {
  typstCompileCommand ? "typst compile",
  typstProjectSource ? "main.typ",
  ...
}: let
  inherit (builtins) removeAttrs;
  inherit (lib.strings) escapeShellArg;

  typstOptsString = args.typstOptsString or (typstOptsFromArgs args);
  cleanedArgs = removeAttrs args [
    "typstCompileCommand"
    "typstOpts"
    "typstOptsString"
    "typstProjectOutput"
    "typstProjectSource"
  ];
in
  mkTypstDerivation (cleanedArgs
    // {
      buildPhaseTypstCommand = ''
        ${typstCompileCommand} ${typstOptsString} ${escapeShellArg typstProjectSource} "$out"
      '';
    })
