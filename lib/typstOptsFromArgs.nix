{lib}: origArgs: let
  inherit (builtins) elem isBool isNull tail;
  inherit (lib) optionalAttrs optionalString;
  inherit (lib.attrsets) filterAttrs mapAttrsToList recursiveUpdate;
  inherit (lib.lists) last;
  inherit (lib.strings) concatStringsSep concatMapStringsSep escapeShellArg splitString;

  pathExtension = path: let
    splitPathTail = tail (splitString "." path);
  in
    if (splitPathTail != [])
    then last splitPathTail
    else null;

  inferredFormatFromTypstProjectOutput =
    if ((origArgs ? typstOpts.format) || (! origArgs ? typstOutput))
    then null
    else let
      inherit (origArgs) typstOutput;
      supportedExtensions = ["pdf" "svg" "png" "html"];
      extension = pathExtension typstOutput;
    in
      if (elem extension supportedExtensions)
      then extension
      else null;

  inferredTypstOpts = optionalAttrs (!isNull inferredFormatFromTypstProjectOutput) {
    typstOpts.format = inferredFormatFromTypstProjectOutput;
  };
  defaultArgs = optionalAttrs (! origArgs ? typstOutput) {
    typstOpts.format = "pdf";
  };

  args =
    recursiveUpdate (
      recursiveUpdate defaultArgs inferredTypstOpts
    )
    origArgs;

  parametersFrom = opt: value:
    "--${opt}"
    + optionalString (!isBool value) " ${escapeShellArg value}";
in
  concatStringsSep " " (
    mapAttrsToList
    (opt: value:
      if builtins.isList value
      then (concatMapStringsSep " " (parametersFrom opt) value)
      else (parametersFrom opt value)
    )
    (filterAttrs (_: v: v != false && !isNull v) args.typstOpts)
  )
