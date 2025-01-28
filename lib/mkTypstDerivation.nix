{
  copyVirtualPathsHook,
  emojiFontPathFromString,
  lib,
  stdenvNoCC,
  typst,
  unsetSourceDateEpochHook,
}: args @ {
  buildPhaseTypstCommand,
  emojiFont ? "default",
  fontPaths ? [],
  installPhaseCommand ? "",
  virtualPaths ? [],
  ...
}: let
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
