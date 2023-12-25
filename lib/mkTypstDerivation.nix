{
  stdenv,
  typst,
}: args @ {
  buildPhaseTypstCommand,
  installPhaseCommand ? "",
  ...
}: let
  inherit (builtins) baseNameOf getEnv removeAttrs;

  cleanedArgs = removeAttrs args [
    "buildPhaseTypstCommand"
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
