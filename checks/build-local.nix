{
  lib,
  pkgs,
  buildLocalTypstProject,
}: runCommandDrvAttr: args: let
  build-local-drv = buildLocalTypstProject ({
      name = "build-local-check";
    }
    // args);
in
  pkgs.runCommand "build-local" (runCommandDrvAttr
    // {
      nativeBuildInputs =
        (runCommandDrvAttr.nativeBuildInputs or [])
        ++ [
          build-local-drv
        ];
    }) ''
    runHook preBuild
    ${lib.getExe build-local-drv} "$out"
    runHook postBuild
  ''
