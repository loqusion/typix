{
  cleanTypstSource,
  copyVirtualPathsHook,
  lib,
  linkFarmFromDrvs,
  linkVirtualPaths,
  pkgs,
}: let
  inherit (lib.attrsets) filterAttrs mapAttrsToList;
  inherit (lib.lists) all;
  inherit (lib.strings) toShellVars;

  copyVirtualPathsHookAssertion = args @ {
    virtualPaths,
    assertionCommand,
    ...
  }: let
    cleanedArgs = builtins.removeAttrs args [
      "virtualPaths"
      "assertionCommand"
    ];
  in
    pkgs.stdenv.mkDerivation (cleanedArgs
      // {
        src = cleanTypstSource ./simple;
        nativeBuildInputs = [
          (copyVirtualPathsHook virtualPaths)
        ];
        buildPhase = ''
          runHook preBuild
          runHook postBuild
        '';
        postBuild = ''
          set -euo pipefail

          assertionCommand() {
            ${assertionCommand}
          }

          if ! assertionCommand; then
            ${toShellVars {assertionText = assertionCommand;}}
            echo "assertion \`$assertionText\` failed"
            exit 1
          fi

          touch "$out"
        '';
      });

  linkVirtualPathsAssertion = args @ {
    virtualPaths,
    assertionCommand,
    ...
  }: let
    cleanedArgs = builtins.removeAttrs args [
      "virtualPaths"
      "assertionCommand"
    ];
  in
    pkgs.stdenv.mkDerivation (cleanedArgs
      // {
        src = cleanTypstSource ./simple;
        buildPhase = ''
          ${linkVirtualPaths {inherit virtualPaths;}}
          runHook postBuild
        '';
        postBuild = ''
          set -euo pipefail

          assertionCommand() {
            ${assertionCommand}
          }

          if ! assertionCommand; then
            ${toShellVars {assertionText = assertionCommand;}}
            echo "assertion \`$assertionText\` failed"
            exit 1
          fi

          touch "$out"
        '';
      });

  virtualPathsTestAttrs = {
    fileSource = {
      virtualPaths = ["${./fixtures/icons}/link.svg"];
      assertionCommand = ''[ -f ./link.svg ]'';
    };

    directorySource = {
      virtualPaths = [./fixtures/icons];
      assertionCommand = ''[ -f ./main.typ ] && [ -f ./link.svg ]'';
    };

    fileSourceWithDest = {
      virtualPaths = [
        {
          src = ./fixtures/icons/link.svg;
          dest = "link.svg";
        }
      ];
      assertionCommand = ''[ -f ./link.svg ]'';
    };

    directorySourceWithDest = {
      virtualPaths = [
        {
          src = ./fixtures/icons;
          dest = "icons";
        }
      ];
      assertionCommand = ''[ -d ./icons ] && [ -f ./icons/link.svg ]'';
    };

    fileSourceWithDeepDest = {
      virtualPaths = [
        {
          src = ./fixtures/icons/link.svg;
          dest = "assets/icons/link.svg";
        }
      ];
      assertionCommand = ''[ -d ./assets/icons ] && [ -f ./assets/icons/link.svg ]'';
    };

    directorySourceWithDeepDest = {
      virtualPaths = [
        {
          src = ./fixtures/icons;
          dest = "assets/icons";
        }
      ];
      assertionCommand = ''[ -d ./assets/icons ] && [ -f ./assets/icons/link.svg ]'';
    };

    mergedSources = {
      virtualPaths = [
        {
          src = ./fixtures/icons;
          dest = "icons";
        }
        {
          src = ./fixtures/more-icons;
          dest = "icons";
        }
      ];
      assertionCommand = ''[ -d ./icons ] && [ -f ./icons/link.svg ] && [ -f ./icons/another-link.svg ]'';
    };
  };

  skip = {
    copyVirtualPathsHook = [];
    linkVirtualPaths = [
      "fileSource"
      "fileSourceWithDeepDest"
      "directorySourceWithDeepDest"
    ];
  };
  filterSkip = skipNames:
    filterAttrs
    (name: _: all (skipName: name != skipName) skipNames);

  mapTestAttrs = f: skipAttrs: testGroupName:
    mapAttrsToList
    (name: attrs: f (attrs // {name = "${testGroupName}-${name}";}))
    (filterSkip skipAttrs virtualPathsTestAttrs);
in
  linkFarmFromDrvs "virtualPathsTests"
  (
    (mapTestAttrs copyVirtualPathsHookAssertion skip.copyVirtualPathsHook "copyVirtualPathsHook")
    ++ (mapTestAttrs linkVirtualPathsAssertion skip.linkVirtualPaths "linkVirtualPaths")
  )
