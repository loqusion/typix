{lib}: args_: let
  args =
    if builtins.isString args_
    then {typstProjectSource = args_;}
    else args_;
  supportedFormats = ["pdf" "svg" "png"];
  format = ({format = "pdf";} // args.typstOpts or {}).format;
  name = lib.strings.removeSuffix ".typ" (builtins.baseNameOf args.typstProjectSource);
  extension =
    if builtins.elem format supportedFormats
    then format
    else
      lib.flip lib.trivial.warn "" ''
        typst.nix could not infer the typst output extension since ${format} is not supported
        to silence this warning consider one of the following:
        - set the format option to one of: pdf, svg, png
        - set `typstProjectOutput` explicitly
      '';
in
  name + lib.optionalString (extension != "") ".${extension}"
