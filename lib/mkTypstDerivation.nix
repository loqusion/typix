{
  lib,
  stdenv,
  typst,
}: args @ {
  buildPhaseTypstCommand,
  fontPaths ? [],
  installPhaseCommand ? "",
  ...
}: let
  inherit (builtins) baseNameOf getEnv removeAttrs;
  inherit (lib) optionalAttrs;
  inherit (lib.strings) concatStringsSep;

  cleanedArgs = removeAttrs args [
    "buildPhaseTypstCommand"
    "fontPaths"
    "installPhaseCommand"
  ];
  name = args.name or (baseNameOf (getEnv "PWD"));
  nameArgs =
    if args ? version
    then {
      pname = name;
      inherit (args) version;
    }
    else {inherit name;};
in
  stdenv.mkDerivation (cleanedArgs
    // nameArgs
    // optionalAttrs (fontPaths != []) {
      TYPST_FONT_PATHS =
        concatStringsSep ":"
        fontPaths;
    }
    // {
      nativeBuildInputs =
        (args.nativeBuildInputs or [])
        ++ [
          typst
        ];

      buildPhase = args.buildPhase or ''
        runHook preBuild
        ${buildPhaseTypstCommand}
        runHook postBuild
      '';

      installPhase = args.installPhase or ''
        runHook preInstall
        ${installPhaseCommand}
        runHook postInstall
      '';
    })
