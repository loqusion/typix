{lib}: src:
lib.cleanSourceWith {
  src = lib.cleanSource src;
  filter = path: type: let
    hasAcceptedSuffix = builtins.any (lib.flip lib.hasSuffix path) [
      ".typ" # Typst files
      ".bib" # BibLaTeX files
      ".yaml" # Hayagriva files
      ".yml" # Hayagriva files
    ];
    isSpecialFile = builtins.elem (builtins.baseNameOf path) [
      "typst.toml"
      "metadata.toml"
    ];
  in
    builtins.any lib.id [
      (type == "directory")
      hasAcceptedSuffix
      isSpecialFile
    ];
}
