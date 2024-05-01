{
  coerceVirtualPathAttr,
  lib,
  makeSetupHook,
}: virtualPaths: let
  inherit (lib.strings) concatMapStringsSep toShellVars;
  copyAllVirtualPaths =
    concatMapStringsSep
    "\n" (virtualPath_: let
      virtualPath = coerceVirtualPathAttr virtualPath_;
    in ''
      ${toShellVars {
        virtualPathSrc = virtualPath.src;
        virtualPathDest = virtualPath.dest;
      }}

      echo "Copying $virtualPathSrc to $virtualPathDest"

      _ensure_parent_exists "$virtualPathDest"

      if [ -f "$virtualPathSrc" ] && _same_path "." "$virtualPathDest"; then
        cp -Lv --reflink=auto --no-preserve=mode "$virtualPathSrc" "$virtualPathDest"
      else
        cp -LTRv --reflink=auto --no-preserve=mode "$virtualPathSrc" "$virtualPathDest"
      fi

      _cleanup_parent "$virtualPathDest"
    '')
    virtualPaths;
in
  makeSetupHook {
    name = "copyVirtualPaths";
    substitutions = {
      inherit copyAllVirtualPaths;
    };
  }
  ./copyVirtualPathsHook.sh
