{
  coerceLocalPathAttr,
  lib,
  makeSetupHook,
}: localPaths: let
  inherit (lib.strings) concatMapStringsSep toShellVars;
  copyAllLocalPaths =
    concatMapStringsSep
    "\n" (localPath_: let
      localPath = coerceLocalPathAttr localPath_;
    in ''
      ${toShellVars {
        localPathSrc = localPath.src;
        localPathDest = localPath.dest;
      }}
      mkdir -p "$localPathDest"
      echo "Copying $localPathSrc to $localPathDest"
      cp -LTR --reflink=auto --no-preserve=mode "$localPathSrc" "$localPathDest"
      if [ "$localPathDest" != "." ]; then
        rmdir --ignore-fail-on-non-empty "$localPathDest"
      fi
    '')
    localPaths;
in
  makeSetupHook {
    name = "copyLocalPaths";
    substitutions = {
      inherit copyAllLocalPaths;
    };
  }
  ./copyLocalPathsHook.sh
