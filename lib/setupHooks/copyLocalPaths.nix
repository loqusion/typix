{
  lib,
  makeSetupHook,
}: let
  inherit (builtins) isAttrs;
  inherit (lib.strings) concatMapStringsSep escapeShellArg isStringLike;

  coerceLocalPath = localPath:
    if isStringLike localPath
    then {
      src = escapeShellArg localPath;
      dest = ".";
    }
    else if isAttrs localPath
    then {
      src = escapeShellArg localPath.src;
      dest = escapeShellArg (localPath.dest or ".");
    }
    else throw "Invalid local path";
in
  localPaths:
    makeSetupHook {
      name = "copyLocalPaths";
      substitutions = {
        copyAllLocalPaths =
          concatMapStringsSep
          "\n" (localPath_: let
            localPath = coerceLocalPath localPath_;
          in ''
            mkdir -p ${localPath.dest}
            echo "Copying ${localPath.src} to ${localPath.dest}"
            cp -L --reflink=auto --no-preserve=mode -R ${localPath.src} -T ${localPath.dest}
            if [ ${localPath.dest} != "." ]; then
              rmdir --ignore-fail-on-non-empty ${localPath.dest}
            fi
          '')
          localPaths;
      };
    }
    ./copyLocalPathsHook.sh
