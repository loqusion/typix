{
  lib,
  linkLocalPathsHook,
  mkShell,
  typst,
}: args @ {
  extraShellHook ? "",
  localPaths ? [],
  packages ? [],
  ...
}: let
  inherit (builtins) removeAttrs;

  optionalLinkLocalPathsHook =
    if localPaths != []
    then linkLocalPathsHook localPaths
    else "";

  cleanedArgs = removeAttrs args [
    "extraShellHook"
    "localPaths"
  ];
in
  mkShell (cleanedArgs
    // {
      packages =
        [
          typst
        ]
        ++ packages;
      shellHook =
        args.shellHook
        or ''
          ${optionalLinkLocalPathsHook}
          ${extraShellHook}
        '';
    })
