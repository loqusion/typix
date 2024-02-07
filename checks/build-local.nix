{
  lib,
  pkgs,
  buildTypstProjectLocal,
}: runCommandDrvAttr: args: let
  build-local-drv = buildTypstProjectLocal ({
      name = "build-local-check";
    }
    // args
    // runCommandDrvAttr);
in
  pkgs.runCommand "build-local" (runCommandDrvAttr
    // {
      nativeBuildInputs =
        (runCommandDrvAttr.nativeBuildInputs or [])
        ++ [
          build-local-drv
        ];
    }) ''
    ${lib.getExe build-local-drv} "$out"
  ''
