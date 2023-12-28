{
  buildTypstProject,
  inferTypstProjectOutput,
  lib,
  pkgs,
  typst,
  typstOptsFromArgs,
}: args @ {typstProjectSource ? "main.typ", ...}: let
  inherit (lib.strings) escapeShellArg;

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
      cp -LT --no-preserve=mode ${buildTypstProjectImport} ${escapeShellArg typstProjectOutput}
    '';
  }
