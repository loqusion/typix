{
  lib,
  pkgs,
  buildLocalTypstProject,
}: args: let
  build-local-drv = buildLocalTypstProject ({
      name = "build-local-check";
    }
    // args);
in
  pkgs.runCommand "build-local" {
    nativeBuildInputs = [
      build-local-drv
    ];
  } ''
    ${lib.getExe build-local-drv} "$out"
  ''
