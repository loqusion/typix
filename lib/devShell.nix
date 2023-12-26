{
  lib,
  mkShell,
  typst,
}: args @ {
  checks ? [],
  extraShellHook ? "",
  inputsFrom ? [],
  localPaths ? [],
  packages ? [],
  ...
}: let
  inherit (builtins) removeAttrs;

  # optionalLinkLocalPathsHook =
  #   if localPaths != []
  #   then linkLocalPathsHook localPaths
  #   else "";

  cleanedArgs = removeAttrs args [
    "checks"
    "extraShellHook"
    "inputsFrom"
    "localPaths"
  ];
in
  mkShell (cleanedArgs
    // {
      inputsFrom = builtins.attrValues checks ++ inputsFrom;

      packages =
        [
          typst
        ]
        ++ packages;

      shellHook =
        args.shellHook
        or ''
          ${extraShellHook}
        '';
    })
