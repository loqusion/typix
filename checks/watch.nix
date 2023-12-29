{
  lib,
  pkgs,
  watchTypstProject,
}: runCommandDrvAttr: args: let
  cleanedArgs = builtins.removeAttrs args [
    "src"
  ];
  watch-drv = watchTypstProject ({
      name = "watch-check";
      # `typst watch` will never exit itself, but we can still check the exit status of `typst compile` for errors
      typstWatchCommand = "typst compile";
    }
    // cleanedArgs);
in
  pkgs.runCommand "watch" (runCommandDrvAttr
    // {
      nativeBuildInputs =
        (runCommandDrvAttr.nativeBuildInputs or [])
        ++ [
          watch-drv
        ];
    }) ''
    cp -RLT --no-preserve=mode ${args.src} .
    runHook preBuild
    ${lib.getExe watch-drv} "$out"
    runHook postBuild
  ''
