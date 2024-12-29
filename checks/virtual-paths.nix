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

  cleanArgs = args:
    builtins.removeAttrs args [
      "virtualPaths"
      "assertionCommand"
      "linkAssertionCommnad"
    ];

  copyVirtualPathsHookAssertion = args @ {
    virtualPaths,
    assertionCommand,
    ...
  }:
    pkgs.stdenvNoCC.mkDerivation ((cleanArgs args)
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
    linkAssertionCommand ? "true",
    ...
  }:
    pkgs.stdenvNoCC.mkDerivation ((cleanArgs args)
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

          linkAssertionCommand() {
            ${linkAssertionCommand}
          }

          if ! assertionCommand; then
            ${toShellVars {assertionText = assertionCommand;}}
            echo "assertion \`$assertionText\` failed"
            exit 1
          fi
          if ! linkAssertionCommand; then
            ${toShellVars {assertionText = linkAssertionCommand;}}
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
      linkAssertionCommand = ''[ -L ./link.svg ]'';
    };

    directorySource = {
      virtualPaths = [./fixtures/icons];
      assertionCommand = ''[ -f ./main.typ ] && [ -f ./link.svg ]'';
      linkAssertionCommand = ''[ -L ./link.svg ]'';
    };

    fileSourceWithDest = {
      virtualPaths = [
        {
          src = ./fixtures/icons/link.svg;
          dest = "link.svg";
        }
      ];
      assertionCommand = ''[ -f ./link.svg ]'';
      linkAssertionCommand = ''[ -L ./link.svg ]'';
    };

    directorySourceWithDest = {
      virtualPaths = [
        {
          src = ./fixtures/icons;
          dest = "icons";
        }
      ];
      assertionCommand = ''[ -d ./icons ] && [ -f ./icons/link.svg ]'';
      linkAssertionCommand = ''[ ! -L ./icons ] && [ -L ./icons/link.svg ]'';
    };

    fileSourceWithDeepDest = {
      virtualPaths = [
        {
          src = ./fixtures/icons/link.svg;
          dest = "assets/icons/link.svg";
        }
      ];
      assertionCommand = ''[ -d ./assets/icons ] && [ -f ./assets/icons/link.svg ]'';
      linkAssertionCommand = ''[ ! -L ./assets ] && [ ! -L ./assets/icons ] && [ -L ./assets/icons/link.svg ]'';
    };

    directorySourceWithDeepDest = {
      virtualPaths = [
        {
          src = ./fixtures/icons;
          dest = "assets/icons";
        }
      ];
      assertionCommand = ''[ -d ./assets/icons ] && [ -f ./assets/icons/link.svg ]'';
      linkAssertionCommand = ''[ ! -L ./assets ] && [ ! -L ./assets/icons ] && [ -L ./assets/icons/link.svg ]'';
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
      linkAssertionCommand = ''[ ! -L ./icons ] && [ -L ./icons/link.svg ] && [ -L ./icons/another-link.svg ]'';
    };
  };

  skip = {
    copyVirtualPathsHook = [];
    linkVirtualPaths = [];
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
