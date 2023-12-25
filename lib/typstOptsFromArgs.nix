{lib}: args: let
  inherit (lib.attrsets) filterAttrs mapAttrsToList;
  inherit (lib.strings) concatStringsSep escapeShellArg;
in
  concatStringsSep " " (
    mapAttrsToList
    (opt: value: "--${opt} ${escapeShellArg value}")
    (filterAttrs (_: v: !isNull v) args)
  )
