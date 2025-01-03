{
  lib,
  linkVirtualPaths,
  mkShellNoCC,
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

  unsetSourceDateEpochScript = builtins.readFile ./setupHooks/unsetSourceDateEpochScript.sh;

  cleanedArgs = removeAttrs args [
    "checks"
    "extraShellHook"
    "fontPaths"
    "forceVirtualPaths"
    "inputsFrom"
    "virtualPaths"
  ];
in
  mkShellNoCC (cleanedArgs
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
        + ''
          ${unsetSourceDateEpochScript}
        ''
        + optionalString (extraShellHook != "") ''

          ${extraShellHook}
        '';
    })
