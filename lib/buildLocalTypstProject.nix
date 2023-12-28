{
  buildTypstProject,
  inferTypstProjectOutput,
  lib,
  pkgs,
  typst,
  typstOptsFromArgs,
}: args @ {typstProjectSource ? "main.typ", ...}: let
  inherit (lib.strings) toShellVars;

  typstOptsString = typstOptsFromArgs args;
  typstProjectOutput =
    args.typstProjectOutput
    or (inferTypstProjectOutput (
      {inherit typstProjectSource;} // args
    ));

  buildTypstProjectDerivation = buildTypstProject (
    args // {inherit typstOptsString typstProjectSource;}
  );
  buildTypstProjectImport = builtins.path {path = buildTypstProjectDerivation;};
in
  pkgs.writeShellApplication {
    name = "typst-build";

    text = ''
      ${toShellVars {inherit typstProjectOutput;}}
      out=''${1:-''${typstProjectOutput:?not defined}}
      cp -LT --no-preserve=mode ${buildTypstProjectImport} "$out"
    '';
  }
