{
  coerceLocalPathAttr,
  lib,
  makeSetupHook,
}: let
  inherit (lib.strings) concatMapStringsSep;
in
  localPaths:
    makeSetupHook {
      name = "linkLocalPaths";
      substitutions = {
        linkAllLocalPaths =
          concatMapStringsSep
          "\n" (localPath_: let
            localPath = coerceLocalPathAttr localPath_;
          in ''
            echo "Linking ${localPath.src} to ${localPath.dest}"
            ln -sfT ${localPath.src} ${localPath.dest}
          '')
          localPaths;
      };
    }
    ./linkLocalPathsHook.sh
