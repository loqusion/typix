{pkgs}:
pkgs.writeShellApplication {
  name = "github-release";

  runtimeInputs = with pkgs; [
    gh
    git
    nodePackages.semver
  ];

  text = ''
    VALID_INCREMENT_TYPES="major minor patch premajor preminor prepatch prerelease"
    increment=''${1:-patch}
    # shellcheck disable=SC2076
    if [[ ! " $VALID_INCREMENT_TYPES " =~ " $increment " ]]; then
      echo "Invalid increment type: $increment" >&2
      echo "Expected one of: ''${VALID_INCREMENT_TYPES// /, }" >&2
      exit 1
    fi

    current_version=$(git describe --tags --abbrev=0)
    next_version=$(semver --increment "$increment" "$current_version")

    gh release create --generate-notes "$next_version"
  '';
}
