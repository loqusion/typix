{
  coerceLocalPathAttr,
  lib,
  makeSetupHook,
}: let
  inherit (lib.strings) concatMapStringsSep;
in
  localPaths:
    makeSetupHook {
      name = "copyLocalPaths";
      substitutions = {
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
      };
    }
    ./copyLocalPathsHook.sh
