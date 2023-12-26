{
  coerceLocalPathAttr,
  lib,
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
  inherit (lib.strings) concatMapStringsSep concatStringsSep;

  linkLocalPathsHook = localPaths:
    concatMapStringsSep
    "\n" (localPath_: let
      localPath = coerceLocalPathAttr localPath_;
    in ''
      echo "typst-nix: linking ${localPath.src} to ${localPath.dest}"
      ln -sfT ${localPath.src} ${localPath.dest}
    '')
    localPaths;
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
