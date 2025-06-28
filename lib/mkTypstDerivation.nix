{
  copyVirtualPathsHook,
  emojiFontPathFromString,
  lib,
  stdenvNoCC,
  typst,
  unsetSourceDateEpochHook,
  fetchTypstPackages,
}: args @ {
  buildPhaseTypstCommand,
  emojiFont ? "default",
  fontPaths ? [],
  installPhaseCommand ? "",
  virtualPaths ? [],
  unstable_typstPackages ? [],
  nixpkgs_typstPackages ? [],
  ...
}:
assert lib.assertMsg (!(builtins.hasAttr "unstableTypstPackages" args)) ''
  `unstableTypstPackages` has been renamed to `unstable_typstPackages`.
''; let
  inherit (builtins) baseNameOf getEnv isNull removeAttrs;
  inherit (lib) lists optionalAttrs;
  inherit (lib.strings) concatStringsSep;

  emojiFontPath = emojiFontPathFromString emojiFont;
  allFontPaths = fontPaths ++ lists.optional (!isNull emojiFontPath) emojiFontPath;

  cleanedArgs = removeAttrs args [
    "buildPhaseTypstCommand"
    "emojiFont"
    "fontPaths"
    "installPhaseCommand"
    "virtualPaths"
    "unstable_typstPackages"
    "nixpkgs_typstPackages"
  ];

  name =
    args.name
    or (let
      pwd = getEnv "PWD";
    in
      if pwd != ""
      then baseNameOf pwd
      else "typst");
  nameArgs =
    if args ? version
    then {
      pname = args.pname or name;
      inherit (args) version;
    }
    else {inherit name;};
in
  stdenvNoCC.mkDerivation (cleanedArgs
    // nameArgs
    // optionalAttrs (allFontPaths != []) {
      TYPST_FONT_PATHS = concatStringsSep ":" allFontPaths;
    }
    // optionalAttrs (unstable_typstPackages != [] || nixpkgs_typstPackages != []) {
      TYPST_PACKAGE_CACHE_PATH =
        (fetchTypstPackages unstable_typstPackages)
          .overrideAttrs (_: super: {
            paths = super.paths
                    ++ (lib.map
                      (p: p.overrideAttrs (oldAttrs: {
                        postInstall = ''
                          mv $out/lib/typst-packages $out/preview; rmdir $out/lib
                        '';
                      }))
                      (lib.foldl'
                        (acc: p: acc ++ lib.singleton p ++ p.propagatedBuildInputs)
                        [ ]
                        nixpkgs_typstPackages)
                    );
          })
      ;
    }
    // {
      nativeBuildInputs =
        (args.nativeBuildInputs or [])
        ++ [
          typst
          (copyVirtualPathsHook virtualPaths)
          unsetSourceDateEpochHook
        ];

      buildPhase =
        args.buildPhase
        or ''
          runHook preBuild
          ${buildPhaseTypstCommand}
          runHook postBuild
        '';

      installPhase =
        args.installPhase
        or ''
          runHook preInstall
          ${installPhaseCommand}
          runHook postInstall
        '';
    })
