{lib}: args_: let
  inherit (lib.attrsets) filterAttrs mapAttrsToList recursiveUpdate;
  inherit (lib.strings) concatStringsSep escapeShellArg;

  defaultArgs = {
    typstOpts = {
      format = "pdf";
    };
  };
  args = recursiveUpdate defaultArgs args_;
in
  concatStringsSep " " (
    mapAttrsToList
    (opt: value: "--${opt} ${escapeShellArg value}")
    (filterAttrs (_: v: !isNull v) args.typstOpts)
  )
