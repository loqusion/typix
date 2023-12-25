{
  copyLocalPathsHook,
  lib,
  mkTypstDerivation,
  prepareTypstEnvHook,
  typstOptsFromArgs,
}: args @ {
  typstCompileCommand ? "typst compile",
  typstProjectSource,
  ...
}: let
  inherit (builtins) isPath removeAttrs typeof;
  inherit (lib.asserts) assertMsg;
  inherit (lib.strings) escapeShellArg;

  # TODO: Experiment with exposing this to the user. If it doesn't write to the user's directory,
  # then just write to $out and use this attribute in a `pkgs.writeShellScriptBin` derivation
  # with something like:
  #     typstNixOutput=$(nix build .#default --no-link --print-out-paths)
  #     cp -L --no-preserve=mode "$typstNixOutput" ./${escapeShellArg typstProjectOutput}
  typstProjectOutput =
    if args ? typstProjectOutput
    then
      assertMsg
      (isPath args.typstProjectOutput) "typstProjectOutput must be a path; received ${typeof args.typstProjectOutput}"
      (escapeShellArg args.typstProjectOutput)
    else "$out";
  typstOpts = typstOptsFromArgs args;
  cleanedArgs = removeAttrs args [
    "typstProjectOutput"
    "typstProjectSource"
  ];
in
  mkTypstDerivation (cleanedArgs
    // {
      buildPhaseTypstCommand = ''
        ${typstCompileCommand} ${typstOpts} ${escapeShellArg typstProjectSource} ${typstProjectOutput}
      '';

      nativeBuildInputs = [
        copyLocalPathsHook
        prepareTypstEnvHook
      ];
    })
