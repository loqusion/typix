{
  buildTypstProject,
  inferTypstProjectOutput,
  lib,
  pkgs,
  typst,
  typstOptsFromArgs,
}: args @ {typstSource ? "main.typ", ...}: let
  inherit (lib.strings) toShellVars;

  typstOptsString = typstOptsFromArgs args;
  typstOutput =
    args.typstOutput
    or (inferTypstProjectOutput (
      {inherit typstSource;} // args
    ));

  buildTypstProjectDerivation = buildTypstProject (
    args // {inherit typstOptsString typstSource;}
  );
  buildTypstProjectImport = builtins.path {path = buildTypstProjectDerivation;};
in
  pkgs.writeShellApplication {
    name = "typst-build";

    text = ''
      ${toShellVars {inherit typstOutput;}}
      out=''${1:-''${typstOutput:?not defined}}
      cp -LT --no-preserve=mode ${buildTypstProjectImport} "$out"
    '';
  }
