{
  copyLocalPathsHook,
  lib,
  mkTypstDerivation,
  typstOptsFromArgs,
}: args @ {
  localPaths ? [],
  typstCompileCommand ? "typst compile",
  typstProjectSource ? "main.typ",
  ...
}: let
  inherit (builtins) removeAttrs;
  inherit (lib.strings) escapeShellArg;

  typstOpts = typstOptsFromArgs (args.typstOpts or {});
  cleanedArgs = removeAttrs args [
    "localPaths"
    "typstOpts"
    "typstProjectOutput"
    "typstProjectSource"
  ];
in
  mkTypstDerivation (cleanedArgs
    // {
      buildPhaseTypstCommand = ''
        ${typstCompileCommand} ${typstOpts} ${escapeShellArg typstProjectSource} "$out"
      '';

      nativeBuildInputs = [
        (copyLocalPathsHook localPaths)
      ];
    })
