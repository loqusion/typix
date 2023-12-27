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
  buildTypstProjectDerivation = buildTypstProject (
    args // {inherit typstProjectOutput typstProjectSource;}
  );
in
  pkgs.writeShellApplication {
    name = "typst-build";

    text = ''
      symlink=$(mktemp -d -t tmp.XXXXXXXXXX)/result
      nix build ${buildTypstProjectDerivation} -o "$symlink" && {
        cp -LT --no-preserve=mode "$symlink" ${escapeShellArg typstProjectOutput}
      }
      [ -L "$symlink" ] && rm "$symlink"
    '';
  }
