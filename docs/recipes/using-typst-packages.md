# Using Typst packages

> TL;DR: Use [this example][typst-packages-example] as a template:
>
> ```bash
> nix flake init --refresh -t 'github:loqusion/typix#with-typst-packages'
> ```
>
> [typst-packages-example]: https://github.com/loqusion/typix/blob/main/examples/typst-packages/flake.nix

<div class="warning">

Typst packages are considered experimental at the time of writing, and the
methods documented here may become outdated at any point if breaking changes are
made upstream.

If you experience any unexpected errors or bugs, and there are no [open issues]
related to your problem, feel free to [open an issue].

[open issues]: https://github.com/loqusion/typix/issues?q=is%3Aissue+is%3Aopen+sort%3Aupdated-desc+label%3A%22typst+packages%22
[open an issue]: https://github.com/loqusion/typix/issues/new?assignees=&labels=typst+packages&projects=&template=3-typst_packages.md&title=%5BTypst+packages%5D%3A+

</div>

There are two types of Typst packages: _published_ and _unpublished_:

- [_Published_ packages](#published-typst-packages) are those submitted to the
  [Typst Packages repository] and can be browsed on [Typst Universe].
- [_Unpublished_ packages](#unpublished-typst-packages) are packages that are
  only available from unofficial sources.
  They can be stored locally on your system, on a GitHub repository, or elsewhere.
  ("Unpublished" can also refer to unpublished versions of a package which has
  published versions.)

[Typst Packages repository]: https://github.com/typst/packages
[Typst Universe]: https://typst.app/universe/

The method to get Typst packages working differs depending on whether they are
published or unpublished.

## Published Typst packages

Published Typst packages work out of the box for for [`watchTypstProject`] and
commands executed while [`devShell`] is active.

For [`buildTypstProject`], [`buildTypstProjectLocal`], and [`mkTypstDerivation`],
there are two methods:

<!-- markdownlint-disable link-fragments -->

- [`unstableTypstPackages`](#the-typstpackages-attribute) (recommended)
- [`TYPST_PACKAGE_CACHE_PATH`](#the-typst_package_cache_path-environment-variable)

<!-- markdownlint-enable link-fragments -->

It is recommended to use `unstableTypstPackages`, as it is faster and consumes
less disk space.

### The `unstableTypstPackages` attribute { #the-typstpackages-attribute }

The `unstableTypstPackages` attribute is used to fetch packages from the official
Typst packages CDN at `https://packages.typst.org`.

For more information, see the respective documentation for the attribute on
[`buildTypstProject`], [`buildTypstProjectLocal`], and [`mkTypstDerivation`].

```nix
{
  outputs = {
    nixpkgs,
    typix,
  }: let
    inherit (nixpkgs.lib) getExe;
    system = "x86_64-linux";

    unstableTypstPackages = [
      {
        name = "cetz";
        version = "0.3.4";
        hash = "sha256-5w3UYRUSdi4hCvAjrp9HslzrUw7BhgDdeCiDRHGvqd4=";
      }
      # Transitive dependencies must be manually specified
      # `oxifmt` is required by `cetz`
      {
        name = "oxifmt";
        version = "0.2.1";
        hash = "sha256-8PNPa9TGFybMZ1uuJwb5ET0WGIInmIgg8h24BmdfxlU=";
      }
    ];

    build-drv = typix.lib.${system}.buildTypstProject {
      inherit unstableTypstPackages;
      # ...
    };

    build-script = typix.lib.${system}.buildTypstProjectLocal {
      inherit unstableTypstPackages;
      # ...
    };
  in {
    packages.${system}.default = build-drv;
    apps.${system}.default = {
      type = "app";
      program = getExe build-script;
    };
  };
}
```

### The `TYPST_PACKAGE_CACHE_PATH` environment variable

This method downloads the _entire_ contents of the [Typst Packages repository],
making all packages available in your Typst project.

First, add the repository to flake inputs:

```nix
{
  inputs.typst-packages = {
    url = "github:typst/packages";
    flake = false;
  };
}
```

Then, use it in flake outputs:

```nix
{
  outputs = {
    nixpkgs,
    typix,
    typst-packages,
  }: let
    inherit (nixpkgs.lib) getExe;
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    typstPackagesCache = pkgs.stdenvNoCC.mkDerivation {
      name = "typst-packages-cache";
      src = "${typst-packages}/packages";
      dontBuild = true;
      installPhase = ''
        mkdir -p "$out/typst/packages"
        cp -LR --reflink=auto --no-preserve=mode -t "$out/typst/packages" "$src"/*
      '';
    };

    build-drv = typix.lib.${system}.buildTypstProject {
      TYPST_PACKAGE_CACHE_PATH = typstPackagesCache;
      # ...
    };

    build-script = typix.lib.${system}.buildTypstProjectLocal {
      TYPST_PACKAGE_CACHE_PATH = typstPackagesCache;
      # ...
    };
  in {
    packages.${system}.default = build-drv;
    apps.${system}.default = {
      type = "app";
      program = getExe build-script;
    };
  };
}
```

## Unpublished Typst packages

If the Typst package you want to use is stored locally, in the same repository
as your flake, all you have to do is directly [import] the entrypoint module:

[import]: https://typst.app/docs/reference/foundations/module/

```typst
#import "my-typst-package/src/lib.typ": my-item

#my-item
```

You may want to [expand the source tree] or [filter certain files].

[expand the source tree]: ../recipes/specifying-sources.md#expanding-a-source-tree
[filter certain files]: ../recipes/specifying-sources.md#source-filtering

If you need to fetch an unpublished Typst package from a GitHub repository instead,
see below.

### Fetching from a GitHub repository

> You can use [this example][unpublished-example] as a template:
>
> ```bash
> nix flake init --refresh -t 'github:loqusion/typix#with-typst-packages-unpublished'
> ```
>
> [unpublished-example]: https://github.com/loqusion/typix/blob/main/examples/typst-packages-unpublished/flake.nix

Add the GitHub repository containing the unpublished Typst package to flake inputs:

```nix
{
  inputs = {
    my-typst-package = {
      url = "github:loqusion/my-typst-package";
      flake = false;
    };
  };
}
```

Then, create a derivation containing the inputs and pass it to Typst with
the `TYPST_PACKAGE_PATH` environment variable:

<!-- markdownlint-disable line-length -->

```nix
{
  outputs = {
    nixpkgs,
    typix,
    my-typst-package,
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    inherit (pkgs) lib;
    inherit (lib) getExe;
    inherit (lib.strings) escapeShellArg toShellVars;

    mkTypstPackageDrv = {
      name,
      version,
      namespace,
      input,
      subdir ? "",
    }: let
      outSubdir = "${namespace}/${name}/${version}";
    in
      pkgs.stdenvNoCC.mkDerivation {
        inherit name;
        src = input;
        dontBuild = true;
        installPhase = ''
          ${toShellVars {inherit subdir outSubdir;}}
          mkdir -p $out/$outSubdir
          if [ -n "$subdir" ]; then
            if [ ! -e "$src/$subdir" ]; then
              echo "error: subdir '$subdir' does not exist in $src" >&2
              echo "contents of $src:" >&2
              ls "$src" >&2
              exit 1
            fi
            cp -r "$src/$subdir"/* -t $out/$outSubdir
          else
            cp -r $src/* -t $out/$outSubdir
          fi
        '';
      };

    unpublishedTypstPackages = pkgs.symlinkJoin {
      name = "unpublished-typst-packages";
      paths = map mkTypstPackageDrv [
        # Unpublished packages can be added here
        {
          name = "my-typst-package";
          version = "0.1.0";
          namespace = "local";
          input = my-typst-package;
          # If `typst.toml` is not in the repository's root directory,
          # `subdir` must point to its parent directory
          # subdir = "path/to/dir";
        }
      ];
    };

    # Any transitive dependencies must be added here
    unstableTypstPackages = [
      {
        name = "oxifmt";
        version = "0.2.1";
        hash = "sha256-8PNPa9TGFybMZ1uuJwb5ET0WGIInmIgg8h24BmdfxlU=";
      }
    ];

    build-drv = typix.lib.${system}.buildTypstProject {
      inherit unstableTypstPackages;
      TYPST_PACKAGE_PATH = unpublishedTypstPackages;
      # ...
    };

    build-script = typix.lib.${system}.buildTypstProjectLocal {
      inherit unstableTypstPackages;
      TYPST_PACKAGE_PATH = unpublishedTypstPackages;
      # ...
    };

    watch-script = typix.lib.${system}.watchTypstProject {
      # `watchTypstProject` can already access published packages, so
      # `unstableTypstPackages` is not needed here
      typstWatchCommand = "TYPST_PACKAGE_PATH=${escapeShellArg unpublishedTypstPackages} typst watch";
      # ...
    };
  in {
    packages.${system}.default = build-drv;
    apps.${system}.default = {
      type = "app";
      program = getExe build-script;
    };
    apps.${system}.watch = {
      type = "app";
      program = getExe watch-script;
    };
  };
}
```

Finally, you can use the package in a Typst file:

```typst
#import "@local/my-typst-package:0.1.0": *

#nothing
```

<!-- markdownlint-enable line-length -->

[`buildTypstProjectLocal`]: ../api/derivations/build-typst-project-local.md#typstpackages
[`buildTypstProject`]: ../api/derivations/build-typst-project.md#typstpackages
[`devShell`]: ../api/derivations/dev-shell.md
[`mkTypstDerivation`]: ../api/derivations/mk-typst-derivation.md#typstpackages
[`watchTypstProject`]: ../api/derivations/watch-typst-project.md
