<!-- markdownlint-disable-file first-line-h1 -->

<!-- ANCHOR: head -->

```nix
{
  format = "png";
  ppi = 300;
  input = ["key1=value1" "key2=value2"];
}
```

...will result in a command like:

<!-- ANCHOR_END: head -->

<!-- ANCHOR: buildtypstproject -->

```nix
{
  outputs = { typix }: let
    system = "x86_64-linux";
  in {
    packages.${system}.default = typix.lib.${system}.buildTypstProject {
      typstOpts = {
        format = "png";
        ppi = 300;
        input = ["key1=value1" "key2=value2"];
      };
    };
  };
}
```

...will result in a command like:

<!-- ANCHOR_END: buildtypstproject -->

<!-- ANCHOR: buildtypstprojectlocal -->

```nix
{
  outputs = { typix }: let
    system = "x86_64-linux";
    inherit (nixpkgs) lib;

    build-script = typix.lib.${system}.buildTypstProjectLocal {
      typstOpts = {
        format = "png";
        ppi = 300;
        input = ["key1=value1" "key2=value2"];
      };
    };
  in {
    apps.${system}.default = {
      type = "app";
      program = lib.getExe build-script;
    };
  };
}
```

...will result in a command like:

<!-- ANCHOR_END: buildtypstprojectlocal -->

<!-- ANCHOR: watchtypstproject -->

```nix
{
  outputs = { typix }: let
    system = "x86_64-linux";
    inherit (nixpkgs) lib;

    watch-script = typix.lib.${system}.watchTypstProject {
      typstOpts = {
        format = "png";
        ppi = 300;
        input = ["key1=value1" "key2=value2"];
      };
    };
  in {
    apps.${system}.default = {
      type = "app";
      program = lib.getExe watch-script;
    };
  };
}
```

...will result in a command like:

<!-- ANCHOR_END: watchtypstproject -->

<!-- ANCHOR: typstcompile -->

```sh
typst compile --format png --ppi 300 --input key1=value1 --input key2=value2 <source> <output>
```

<!-- ANCHOR_END: typstcompile -->

<!-- ANCHOR: typstwatch -->

```sh
typst watch --format png --ppi 300 --input key1=value1 --input key2=value2 <source> <output>
```

<!-- ANCHOR_END: typstwatch -->
