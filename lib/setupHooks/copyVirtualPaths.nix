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
      mkdir -p "$virtualPathDest"
      echo "Copying $virtualPathSrc to $virtualPathDest"
      cp -LTR --reflink=auto --no-preserve=mode "$virtualPathSrc" "$virtualPathDest"
      if [ "$virtualPathDest" != "." ]; then
        rmdir --ignore-fail-on-non-empty "$virtualPathDest"
      fi
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
