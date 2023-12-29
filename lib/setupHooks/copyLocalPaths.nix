{
  coerceLocalPathAttr,
  lib,
  makeSetupHook,
}: localPaths: let
  inherit (lib.strings) concatMapStringsSep;
  copyAllLocalPaths =
    concatMapStringsSep
    "\n" (localPath_: let
      localPath = coerceLocalPathAttr localPath_;
    in ''
      mkdir -p ${localPath.dest}
      echo "Copying ${localPath.src} to ${localPath.dest}"
      cp -LTR --reflink=auto --no-preserve=mode ${localPath.src} ${localPath.dest}
      if [ ${localPath.dest} != "." ]; then
        rmdir --ignore-fail-on-non-empty ${localPath.dest}
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
