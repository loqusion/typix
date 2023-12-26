{lib}: let
  inherit (builtins) isAttrs;
  inherit (lib.strings) escapeShellArg isStringLike;
in
  localPath:
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
    else throw "Invalid local path"
