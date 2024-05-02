{
  coerceVirtualPathAttr,
  lib,
  pkgs,
}: let
  inherit (builtins) toString;
  inherit (pkgs) symlinkJoin;
  inherit (lib) optionalString;
  inherit (lib.filesystem) pathIsDirectory;
  inherit (lib.strings) concatMapStringsSep toShellVars;

  shellUtils = ''
    _same_path() {
      [ "$(realpath "$1")" = "$(realpath "$2")" ]
    }

    _ensure_parent_exists() {
      mkdir -p "$(dirname "$1")"
    }

    _cleanup_parent() {
      local parent
      parent=$(dirname "$1")
      if ! _same_path "." "$1" && ! _same_path "." "$parent"; then
        rmdir -p --ignore-fail-on-non-empty "$parent"
      fi
    }
  '';
in
  {
    forceVirtualPaths ? false,
    virtualPaths,
  }:
    shellUtils
    + "\n"
    + (concatMapStringsSep
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
          ${toShellVars {
            virtualPathSrc = source;
            virtualPathDest = virtualPath.dest;
          }}

          _ensure_parent_exists "$virtualPathDest"

          if [ -f "$virtualPathSrc" ]; then
            echo "typix: linking ${virtualPath.src} to $virtualPathDest"
            if _same_path "." "$virtualPathDest"; then
              ln ${lnAdditionalOpts} -sv "$virtualPathSrc" "$virtualPathDest" ||
                true
            else
              ln ${lnAdditionalOpts} -sTv "$virtualPathSrc" "$virtualPathDest" ||
                true
            fi
          else
            echo "typix: linking ${virtualPath.src} to $virtualPathDest recursively"
            cp ${cpAdditionalOpts} -RTv --no-dereference --no-preserve=mode "$virtualPathSrc" "$virtualPathDest" ||
              true
          fi

          _cleanup_parent "$virtualPathDest"
        '')
      virtualPaths)
