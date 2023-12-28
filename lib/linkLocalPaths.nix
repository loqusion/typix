{
  coerceLocalPathAttr,
  lib,
  pkgs,
}: let
  inherit (builtins) toString;
  inherit (pkgs) symlinkJoin;
  inherit (lib) optionalString;
  inherit (lib.filesystem) pathIsDirectory;
  inherit (lib.strings) concatMapStringsSep;
in
  {
    localPaths,
    forceLocalPaths ? false,
  }:
    concatMapStringsSep
    "\n" (localPath_: let
      localPath = coerceLocalPathAttr localPath_;
      source =
        if !pathIsDirectory (toString localPath.src)
        then localPath.src
        else
          (symlinkJoin {
            name = "symlink" + optionalString (localPath ? dest) "-${localPath.dest}";
            paths = [localPath.src];
          });
      lnAdditionalOpts = optionalString forceLocalPaths "--force";
      cpAdditionalOpts =
        if forceLocalPaths
        then "--force"
        else "--no-clobber";
    in ''
      if [ ! -d ${source} ]; then
        echo "typst-nix: linking ${localPath.src} to ${localPath.dest}"
        ln ${lnAdditionalOpts} -sT ${source} ${localPath.dest}
      else
        echo "typst-nix: linking ${localPath.src} to ${localPath.dest} recursively"
        cp ${cpAdditionalOpts} -RT --no-dereference --no-preserve=mode ${source} ${localPath.dest}
      fi
    '')
    localPaths
