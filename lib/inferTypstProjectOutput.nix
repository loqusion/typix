{lib}: args_: let
  args =
    if builtins.isString args_
    then {typstSource = args_;}
    else args_;
  supportedFormats = ["pdf" "svg" "png"];
  format = ({format = "pdf";} // args.typstOpts or {}).format;
  name = lib.strings.removeSuffix ".typ" (builtins.baseNameOf args.typstSource);
  extension =
    if builtins.elem format supportedFormats
    then format
    else
      lib.flip lib.trivial.warn "" ''
        typix could not infer the typst output extension since ${format} is unsupported
        to silence this warning consider one of the following:
        - set the format option to one of: pdf, svg, png
        - set `typstOutput` explicitly
        - if ${format} is supported by typst but not by typix, please open a
          PR at https://github.com/loqusion/typix
      '';
in
  name + lib.optionalString (extension != "") ".${extension}"
