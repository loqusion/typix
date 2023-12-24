{
  lib,
  stdenv,
  typst,
  ...
}: let
  inherit (builtins) all isAttrs isList isNull isString;
  inherit (lib.asserts) assertMsg;
  inherit (lib.attrsets) filterAttrs mapAttrsToList;
  inherit (lib.strings) concatMapStringsSep concatStringsSep escapeShellArg isStringLike;
  inherit (stdenv) mkDerivation;

  mkErr = msg: "typst.nix: ${msg}";
  validate = assertion: msg: v:
    if assertMsg (assertion v) msg
    then v
    else null;

  isFontPaths = fontPaths: (isList fontPaths) && all isString fontPaths;
  validateFontPaths = fontPaths:
    validate isFontPaths (mkErr "fontPaths must be an array of strings") fontPaths;
  convertFontPaths = fontPaths: concatStringsSep ":" (validateFontPaths fontPaths);

  _mkLocalPathCmd = {
    dest ? ".",
    src,
  }: "cp -L --reflink=auto --no-preserve=mode -R ${escapeShellArg src} -T ${escapeShellArg dest}";
  mkLocalPathCmd = localPath:
    _mkLocalPathCmd (
      if isStringLike localPath
      then {src = localPath;}
      else if isAttrs localPath
      then localPath
      else throw (mkErr "localPath must be a string or attrset")
    );
  mkLocalPathsCmds = concatMapStringsSep "\n" mkLocalPathCmd;

  mkShellOpts = attrs:
    concatStringsSep " " (
      mapAttrsToList
      (name: value: "--${escapeShellArg name} ${escapeShellArg value}")
      (filterAttrs (n: v: !isNull v) attrs)
    );
in
  {
    src,
    entry,
    out,
    version ? null,
    format ? "pdf",
    fontPaths ? [],
    localPaths ? [],
    dontInstall ? false,
  }: let
    typstCompileCommand = "typst compile";
    typstOptionAttrs = {inherit format;};
    copyLocalPathsCommand = mkLocalPathsCmds localPaths;
    exportFontPathsCommand = let
      fontPathsString = convertFontPaths fontPaths;
    in
      if fontPathsString == ""
      then ""
      else ''
        export TYPST_FONT_PATHS=${fontPathsString}
      '';
    buildPhaseCommand = ''
      ${copyLocalPathsCommand}
      ${exportFontPathsCommand}
      ${typstCompileCommand} ${mkShellOpts typstOptionAttrs} ${escapeShellArg entry} "$out"
    '';
    installPhaseCommand = ''
      echo "$out"
    '';
    nameAttrs =
      if version == null
      then {name = out;}
      else {
        pname = out;
        inherit version;
      };
  in
    mkDerivation (nameAttrs
      // {
        inherit src dontInstall;

        buildInputs = [
          typst
        ];

        buildPhase = ''
          runHook preBuild
          ${buildPhaseCommand}
          runHook postBuild
        '';

        installPhase = ''
          runHook preInstall
          ${installPhaseCommand}
          runHook postInstall
        '';
      })
