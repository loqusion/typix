{
  buildTypstProject,
  inferTypstProjectOutput,
  lib,
  pkgs,
  typst,
}: args @ {typstProjectSource ? "main.typ", ...}: let
  inherit (lib.strings) escapeShellArg;

  typstProjectOutput =
    args.typstProjectOutput
    or (
      inferTypstProjectOutput (
        {inherit typstProjectSource;} // args
      )
    );
in
  pkgs.writeShellApplication {
    name = "typst-build-local";

    text = ''
      nix_out_path=$(nix build ${buildTypstProject args} --print-out-paths)
      cp -L --no-preserve=mode "$nix_out_path" ${escapeShellArg typstProjectOutput}
    '';
  }
