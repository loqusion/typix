{lib}: args_: let
  inherit (lib.attrsets) filterAttrs mapAttrsToList;
  inherit (lib.strings) concatStringsSep escapeShellArg;

  defaultArgs = {format = "pdf";};
  args = defaultArgs // args_;
in
  concatStringsSep " " (
    mapAttrsToList
    (opt: value: "--${opt} ${escapeShellArg value}")
    (filterAttrs (_: v: !isNull v) args)
  )
