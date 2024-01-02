{
  buildTypstProject,
  inferTypstProjectOutput,
  lib,
  pkgs,
  typst,
  typstOptsFromArgs,
}: args @ {typstSource ? "main.typ", ...}: let
  inherit (builtins) removeAttrs;
  inherit (lib.strings) toShellVars;

  typstOptsString = typstOptsFromArgs args;
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
      cp -LT --no-preserve=mode ${buildTypstProjectImport} "$out"
    '';
  }
