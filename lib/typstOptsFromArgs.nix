{lib}: args: let
  inherit (lib.attrsets) filterAttrs mapAttrsToList;
  inherit (lib.strings) concatMapStringsSep escapeShellArg;
in
  concatMapStringsSep " " (
    mapAttrsToList
    (opt: value: "--${opt} ${escapeShellArg value}")
    (filterAttrs (_: v: !isNull v) args)
  )
