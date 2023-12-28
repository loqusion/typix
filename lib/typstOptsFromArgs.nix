{lib}: origArgs: let
  inherit (builtins) elem isBool isNull tail;
  inherit (lib) optionalAttrs optionalString;
  inherit (lib.attrsets) filterAttrs mapAttrsToList recursiveUpdate;
  inherit (lib.lists) last;
  inherit (lib.strings) concatStringsSep escapeShellArg splitString;

  pathExtension = path: let
    splitPathTail = tail (splitString "." path);
  in
    if (splitPathTail != [])
    then last splitPathTail
    else null;

  inferredFormatFromTypstProjectOutput =
    if ((origArgs ? typstOpts.format) || (! origArgs ? typstProjectOutput))
    then null
    else let
      inherit (origArgs) typstProjectOutput;
      supportedExtensions = ["pdf" "svg" "png"];
      extension = pathExtension typstProjectOutput;
    in
      if (elem extension supportedExtensions)
      then extension
      else null;

  inferredTypstOpts = optionalAttrs (!isNull inferredFormatFromTypstProjectOutput) {
    typstOpts = {
      format = inferredFormatFromTypstProjectOutput;
    };
  };
  defaultArgs = optionalAttrs (! origArgs ? typstProjectOutput) {
    typstOpts = {
      format = "pdf";
    };
  };

  args =
    recursiveUpdate (
      recursiveUpdate defaultArgs inferredTypstOpts
    )
    origArgs;
in
  concatStringsSep " " (
    mapAttrsToList
    (opt: value:
      "--${opt}"
      + optionalString (!isBool value) " ${escapeShellArg value}")
    (filterAttrs (_: v: v != false && !isNull v) args.typstOpts)
  )
