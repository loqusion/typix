{
  copyVirtualPathsHook,
  lib,
  stdenvNoCC,
  typst,
  unsetSourceDateEpoch,
}: args @ {
  buildPhaseTypstCommand,
  fontPaths ? [],
  installPhaseCommand ? "",
  virtualPaths ? [],
  ...
}: let
  inherit (builtins) baseNameOf getEnv removeAttrs;
  inherit (lib) optionalAttrs;
  inherit (lib.strings) concatStringsSep;

  cleanedArgs = removeAttrs args [
    "buildPhaseTypstCommand"
    "fontPaths"
    "installPhaseCommand"
    "virtualPaths"
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
    // optionalAttrs (fontPaths != []) {
      TYPST_FONT_PATHS = concatStringsSep ":" fontPaths;
    }
    // {
      nativeBuildInputs =
        (args.nativeBuildInputs or [])
        ++ [
          typst
          (copyVirtualPathsHook virtualPaths)
          unsetSourceDateEpoch
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
