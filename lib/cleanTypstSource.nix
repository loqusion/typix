{lib}: src:
lib.cleanSourceWith {
  src = lib.cleanSource src;
  filter = path: type: let
    isTypstSource = lib.hasSuffix ".typ" path;
    isSpecialFile = builtins.elem path [
      "typst.toml"
    ];
  in
    type == "directory" || isTypstSource || isSpecialFile;
}
