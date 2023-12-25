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
  name = args.name or baseNameOf (getEnv "PWD");
  nameArgs =
    if args.version == null
    then {inherit name;}
    else {
      pname = name;
      inherit (args) version;
    };
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

      buildPhase =
        args.buildPhase
        or ''
          runHook preBuild
          ${buildPhaseTypstCommand}
          runHook postBuild
        '';

      installPhase =
        args.buildPhase
        or ''
          runHook preInstall
          ${installPhaseCommand}
          runHook postInstall
        '';
    })
