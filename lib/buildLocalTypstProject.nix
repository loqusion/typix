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
    name = "typst-build";

    text = ''
      symlink=$(mktemp -d)/result
      nix build ${buildTypstProject args} -o "$symlink" && {
        cp -L --no-preserve=mode "$(readlink -e "$symlink")" ${escapeShellArg typstProjectOutput}
      }
      [ -L "$symlink" ] && rm "$symlink"
    '';
  }
