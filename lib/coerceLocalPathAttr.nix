{lib}: let
  inherit (builtins) isAttrs;
  inherit (lib.strings) isStringLike;
in
  localPath:
    if isStringLike localPath
    then {
      src = "${localPath}";
      dest = ".";
    }
    else if isAttrs localPath
    then {
      src = "${localPath.src}";
      dest = localPath.dest or ".";
    }
    else throw "Invalid local path"
