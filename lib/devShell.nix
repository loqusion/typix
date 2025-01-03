{
  lib,
  linkVirtualPaths,
  mkShellNoCC,
  typst,
  unsetSourceDateEpoch,
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

  unsetSourceDateEpochHook = builtins.readFile "${unsetSourceDateEpoch}/nix-support/setup-hook";

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
          unset SOURCE_DATE_EPOCH
        ''
        + optionalString (extraShellHook != "") ''

          ${extraShellHook}
        '';
    })
