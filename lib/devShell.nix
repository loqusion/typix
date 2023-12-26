{
  lib,
  linkLocalPathsHook,
  mkShell,
  typst,
}: args @ {
  checks ? {},
  extraShellHook ? "",
  fontPaths ? [],
  inputsFrom ? [],
  localPaths ? [],
  packages ? [],
  ...
}: let
  inherit (builtins) removeAttrs;
  inherit (lib) optionalAttrs;
  inherit (lib.strings) concatStringsSep;

  optionalLinkLocalPathsHook =
    if localPaths != []
    then linkLocalPathsHook localPaths
    else "";

  cleanedArgs = removeAttrs args [
    "checks"
    "extraShellHook"
    "fontPaths"
    "inputsFrom"
    "localPaths"
  ];
in
  mkShell (cleanedArgs
    // optionalAttrs (fontPaths != []) {
      TYPST_FONT_PATHS = concatStringsSep ":" fontPaths;
    }
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
          ${optionalLinkLocalPathsHook}
          ${extraShellHook}
        '';
    })
