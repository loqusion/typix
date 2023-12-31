<!-- markdownlint-disable-file first-line-h1 -->

<!-- ANCHOR: head -->

You can specify dependencies in your flake input, and then use them in your
project with something like:

<!-- ANCHOR_END: head -->

<!-- ANCHOR: buildlocaltypstproject_example -->

```nix
{
  inputs = {
    font-awesome = {
      url = "github:FortAwesome/Font-Awesome";
      flake = false;
    };
  };

  outputs = { typst-nix, font-awesome }: let
    system = "x86_64-linux";
  in {
    apps.${system}.default = typst-nix.lib.${system}.buildLocalTypstProject {
      localPaths = [
        {
          dest = "icons";
          src = "${font-awesome}/svgs/regular";
        }
      ];
    };
  };
}
```

<!-- ANCHOR_END: buildlocaltypstproject_example -->

<!-- ANCHOR: buildtypstproject_example -->

```nix
{
  inputs = {
    font-awesome = {
      url = "github:FortAwesome/Font-Awesome";
      flake = false;
    };
  };

  outputs = { typst-nix, font-awesome }: let
    system = "x86_64-linux";
  in {
    packages.${system}.default = typst-nix.lib.${system}.buildTypstProject {
      localPaths = [
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

<!-- ANCHOR: mktypstderivation_example -->

```nix
{
  inputs = {
    font-awesome = {
      url = "github:FortAwesome/Font-Awesome";
      flake = false;
    };
  };

  outputs = { typst-nix, font-awesome }: let
    system = "x86_64-linux";
  in {
    packages.${system}.default = typst-nix.lib.${system}.mkTypstDerivation {
      localPaths = [
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

  outputs = { typst-nix, font-awesome }: let
    system = "x86_64-linux";
  in {
    apps.${system}.default = typst-nix.lib.${system}.watchTypstProject {
      localPaths = [
        {
          dest = "icons";
          src = "${font-awesome}/svgs/regular";
        }
      ];
    };
  };
}
```

<!-- ANCHOR_END: watchtypstproject_example -->

<!-- ANCHOR: tail -->

Then, reference the files in Typst:

```typst
#image("icons/heart.svg")
```

<!-- ANCHOR_END: tail -->
