{lib}: src:
lib.cleanSourceWith {
  src = lib.cleanSource src;
  filter = path: type: type == "directory" || (lib.hasSuffix ".typ" path);
}
