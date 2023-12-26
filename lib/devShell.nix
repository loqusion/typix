{
  coerceLocalPathAttr,
  lib,
  linkLocalPaths,
  mkShell,
  typst,
}: args @ {
  checks ? {},
  extraShellHook ? "",
  fontPaths ? [],
  forceLocalPaths ? false,
  inputsFrom ? [],
  localPaths ? [],
  packages ? [],
  ...
}: let
  inherit (builtins) removeAttrs;
  inherit (lib) optionalAttrs optionalString;
  inherit (lib.strings) concatStringsSep;

  cleanedArgs = removeAttrs args [
    "checks"
    "extraShellHook"
    "fontPaths"
    "forceLocalPaths"
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
        or (optionalString (localPaths != []) (linkLocalPaths {
          inherit localPaths forceLocalPaths;
        }))
        + optionalString (extraShellHook != "") ''

          ${extraShellHook}
        '';
    })
