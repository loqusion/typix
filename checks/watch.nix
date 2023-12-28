{
  lib,
  pkgs,
  watchTypstProject,
}: args: let
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
  pkgs.runCommand "watch" {
    nativeBuildInputs = [
      watch-drv
    ];
  } ''
    cp -RLT ${args.src} .
    ${lib.getExe watch-drv} "$out"
  ''
