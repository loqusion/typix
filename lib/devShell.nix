{
  coerceLocalPathAttr,
  lib,
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
  inherit (lib.strings) concatMapStringsSep concatStringsSep;

  linkLocalPathsHook =
    concatMapStringsSep
    "\n" (localPath_: let
      localPath = coerceLocalPathAttr localPath_;
      linkCommand = ''
        echo "typst-nix: linking ${localPath.src} to ${localPath.dest}"
        ln -sfT ${localPath.src} ${localPath.dest}
      '';
    in
      if forceLocalPaths
      then ''
        if [ -e ${localPath.dest} ]; then
          echo "typst-nix: removing ${localPath.dest}"
          rm -rf ${localPath.dest}
        fi
        ${linkCommand}
      ''
      else ''
        if [ -e ${localPath.dest} ] && [ ! -L ${localPath.dest} ]; then
          echo "typst-nix: ${localPath.dest} already exists; skipping"
        else
          ${linkCommand}
        fi
      '')
    localPaths;

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
        or (optionalString (localPaths != []) linkLocalPathsHook)
        + optionalString (extraShellHook != "") ''

          ${extraShellHook}
        '';
    })
