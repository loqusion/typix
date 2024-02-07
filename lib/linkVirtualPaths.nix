{
  coerceVirtualPathAttr,
  lib,
  pkgs,
}: let
  inherit (builtins) toString;
  inherit (pkgs) symlinkJoin;
  inherit (lib) optionalString;
  inherit (lib.filesystem) pathIsDirectory;
  inherit (lib.strings) concatMapStringsSep escapeShellArg;
in
  {
    forceVirtualPaths ? false,
    virtualPaths,
  }:
    concatMapStringsSep
    "\n" (virtualPath_: let
      virtualPath = coerceVirtualPathAttr virtualPath_;
      source =
        if !pathIsDirectory (toString virtualPath.src)
        then virtualPath.src
        else
          (symlinkJoin {
            name = "symlink" + optionalString (virtualPath ? dest) "-${virtualPath.dest}";
            paths = [virtualPath.src];
          });
      lnAdditionalOpts = optionalString forceVirtualPaths "--force";
      cpAdditionalOpts =
        if forceVirtualPaths
        then "--force"
        else "--no-clobber";
    in
      # We don't want a refusal to overwrite existing files to cause nix to fail, so we add `|| true`
      # to the commands this applies to
      ''
        if [ ! -d ${escapeShellArg source} ]; then
          echo "typix: linking ${virtualPath.src} to ${virtualPath.dest}"
          ln ${lnAdditionalOpts} -sT ${escapeShellArg source} ${escapeShellArg virtualPath.dest} ||
            true
        else
          echo "typix: linking ${virtualPath.src} to ${virtualPath.dest} recursively"
          cp ${cpAdditionalOpts} -RT --no-dereference --no-preserve=mode ${escapeShellArg source} ${escapeShellArg virtualPath.dest} ||
            true
        fi
      '')
    virtualPaths
