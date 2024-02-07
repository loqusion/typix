{lib}: let
  inherit (builtins) isAttrs;
  inherit (lib.strings) isStringLike;
in
  virtualPath:
    if isStringLike virtualPath
    then {
      src = "${virtualPath}";
      dest = ".";
    }
    else if isAttrs virtualPath
    then {
      src = "${virtualPath.src}";
      dest = virtualPath.dest or ".";
    }
    else throw "Invalid virtualPath: must be string or attrset"
