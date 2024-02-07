{
  buildTypstProject,
  inferTypstProjectOutput,
  lib,
  pkgs,
  typstOptsFromArgs,
}: args @ {typstSource ? "main.typ", ...}: let
  inherit (builtins) removeAttrs;
  inherit (lib.strings) toShellVars;

  typstOptsString = args.typstOptsString or (typstOptsFromArgs args);
  typstOutput =
    args.typstOutput
    or (inferTypstProjectOutput (
      {inherit typstSource;} // args
    ));

  buildTypstProjectDerivation = buildTypstProject (
    cleanedArgs // {inherit typstOptsString typstSource;}
  );
  buildTypstProjectImport = builtins.path {path = buildTypstProjectDerivation;};

  cleanedArgs = removeAttrs args [
    "scriptName"
  ];
in
  pkgs.writeShellApplication {
    name = args.scriptName or "typst-build";

    text = ''
      ${toShellVars {inherit typstOutput;}}
      out=''${1:-''${typstOutput:?not defined}}
      mkdir -p "$(dirname "$out")"
      cp -LT --no-preserve=mode ${buildTypstProjectImport} "$out"
    '';
  }
