{lib}: origArgs: let
  inherit (builtins) elem isBool tail;
  inherit (lib) optionalAttrs optionalString;
  inherit (lib.attrsets) filterAttrs mapAttrsToList recursiveUpdate;
  inherit (lib.lists) last;
  inherit (lib.strings) concatStringsSep escapeShellArg splitString;

  inferredFormatFromTypstProjectOutput = optionalString (! origArgs ? typstOpts.format) (let
    supportedExtensions = ["pdf" "svg" "png"];
    typstProjectOutputExt = optionalString (origArgs ? typstProjectOutput) (let
      splitTypstProjectOutput = splitString "." origArgs.typstProjectOutput;
    in
      optionalString (tail splitTypstProjectOutput != []) (
        last splitTypstProjectOutput
      ));
  in
    optionalString (elem typstProjectOutputExt supportedExtensions)
    typstProjectOutputExt);

  defaultArgs = {
    typstOpts = {
      format = "pdf";
    };
  };
  args =
    recursiveUpdate (
      recursiveUpdate defaultArgs (optionalAttrs
        (inferredFormatFromTypstProjectOutput != "") {
          typstOpts = {
            format = inferredFormatFromTypstProjectOutput;
          };
        })
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
