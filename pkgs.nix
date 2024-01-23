{pkgs}: {
  docs = let
    inherit (pkgs) lib;
    root = ./.;
    rootPrefix = builtins.toString root;
    src = lib.sources.cleanSourceWith {
      src = root;
      filter = path: _: let
        relativePath = lib.strings.removePrefix rootPrefix path;
      in
        builtins.any ((lib.flip lib.strings.hasPrefix) relativePath) [
          "/docs"
          "/README.md"
        ];
    };
  in
    pkgs.stdenv.mkDerivation {
      name = "typix-mdbook";

      inherit src;

      nativeBuildInputs = with pkgs; [mdbook];

      buildPhase = ''
        mdbook build docs --dest-dir "$out"
      '';
    };
}
