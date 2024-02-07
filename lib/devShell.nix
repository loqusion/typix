{
  lib,
  linkVirtualPaths,
  mkShell,
  typst,
}: args @ {
  checks ? {},
  extraShellHook ? "",
  fontPaths ? [],
  forceVirtualPaths ? false,
  inputsFrom ? [],
  packages ? [],
  virtualPaths ? [],
  ...
}: let
  inherit (builtins) removeAttrs;
  inherit (lib) optionalAttrs optionalString;
  inherit (lib.strings) concatStringsSep;

  cleanedArgs = removeAttrs args [
    "checks"
    "extraShellHook"
    "fontPaths"
    "forceVirtualPaths"
    "inputsFrom"
    "virtualPaths"
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
        or (optionalString (virtualPaths != []) (linkVirtualPaths {
          inherit virtualPaths forceVirtualPaths;
        }))
        + optionalString (extraShellHook != "") ''

          ${extraShellHook}
        '';
    })
