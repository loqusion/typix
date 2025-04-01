<!-- markdownlint-disable-file first-line-h1 -->

<!-- ANCHOR: head -->

You can specify dependencies in your flake input, and then use them in your
project with something like:

<!-- ANCHOR_END: head -->

<!-- ANCHOR: buildtypstprojectlocal_example -->

```nix
{
  inputs = {
    font-awesome = {
      url = "github:FortAwesome/Font-Awesome";
      flake = false;
    };
  };

  outputs = { nixpkgs, typix, font-awesome }: let
    system = "x86_64-linux";
    inherit (nixpkgs) lib;

    build-script = typix.lib.${system}.buildTypstProjectLocal {
      virtualPaths = [
        {
          dest = "icons";
          src = "${font-awesome}/svgs/regular";
        }
      ];
    };
  in {
    apps.${system}.default = {
      type = "app";
      program = lib.getExe build-script;
    };
  };
}
```

<!-- ANCHOR_END: buildtypstprojectlocal_example -->

<!-- ANCHOR: buildtypstproject_example -->

```nix
{
  inputs = {
    font-awesome = {
      url = "github:FortAwesome/Font-Awesome";
      flake = false;
    };
  };

  outputs = { typix, font-awesome }: let
    system = "x86_64-linux";
  in {
    packages.${system}.default = typix.lib.${system}.buildTypstProject {
      virtualPaths = [
        {
          dest = "icons";
          src = "${font-awesome}/svgs/regular";
        }
      ];
    };
  };
}
```

<!-- ANCHOR_END: buildtypstproject_example -->

<!-- ANCHOR: devshell_example -->

```nix
{
  inputs = {
    font-awesome = {
      url = "github:FortAwesome/Font-Awesome";
      flake = false;
    };
  };

  outputs = { typix, font-awesome }: let
    system = "x86_64-linux";
  in {
    devShells.${system}.default = typix.lib.${system}.devShell {
      virtualPaths = [
        {
          dest = "icons";
          src = "${font-awesome}/svgs/regular";
        }
      ];
    };
  };
}
```

<!-- ANCHOR_END: devshell_example -->

<!-- ANCHOR: mktypstderivation_example -->

```nix
{
  inputs = {
    font-awesome = {
      url = "github:FortAwesome/Font-Awesome";
      flake = false;
    };
  };

  outputs = { typix, font-awesome }: let
    system = "x86_64-linux";
  in {
    packages.${system}.default = typix.lib.${system}.mkTypstDerivation {
      virtualPaths = [
        {
          dest = "icons";
          src = "${font-awesome}/svgs/regular";
        }
      ];
    };
  };
}
```

<!-- ANCHOR_END: mktypstderivation_example -->

<!-- ANCHOR: watchtypstproject_example -->

```nix
{
  inputs = {
    font-awesome = {
      url = "github:FortAwesome/Font-Awesome";
      flake = false;
    };
  };

  outputs = { nixpkgs, typix, font-awesome }: let
    system = "x86_64-linux";
    inherit (nixpkgs) lib;

    watch-script = typix.lib.${system}.watchTypstProject {
      virtualPaths = [
        {
          dest = "icons";
          src = "${font-awesome}/svgs/regular";
        }
      ];
    };
  in {
    apps.${system}.default = {
      type = "app";
      program = lib.getExe watch-script;
    };
  };
}
```

<!-- ANCHOR_END: watchtypstproject_example -->

<!-- ANCHOR: typst_example -->

```typst
#image("icons/heart.svg")
```

<!-- ANCHOR_END: typst_example -->

<!-- ANCHOR: tail -->

Then, reference the files in Typst:

```typst
#image("icons/heart.svg")
```

<!-- ANCHOR_END: tail -->
