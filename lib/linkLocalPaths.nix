{
  lib,
  coerceLocalPathAttr,
}: let
  inherit (lib.strings) concatMapStringsSep;
in
  {
    localPaths,
    forceLocalPaths ? false,
  }:
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
    localPaths
