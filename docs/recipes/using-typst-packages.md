# Using Typst packages

> TL;DR: Use [this example][published-example] as a template:
>
> ```bash
> nix flake init --refresh -t 'github:loqusion/typix#with-typst-packages'
> ```
>
> [published-example]: https://github.com/loqusion/typix/blob/main/examples/typst-packages/flake.nix

<div class="warning">

Typst packages are considered experimental at the time of writing, and the
methods documented here may become outdated at any point if breaking changes are
made upstream.

If you experience any unexpected errors or bugs, and there are no [open issues]
related to your problem, feel free to [open an issue].

[open issues]: https://github.com/loqusion/typix/issues?q=is%3Aissue+is%3Aopen+sort%3Aupdated-desc+label%3A%22typst+packages%22
[open an issue]: https://github.com/loqusion/typix/issues/new?assignees=&labels=typst+packages&projects=&template=3-typst_packages.md&title=%5BTypst+packages%5D%3A+

</div>

There are two types of [Typst packages][typst-packages]: _published_ and _unpublished_:

- [_Published_ packages](#published-typst-packages) are those submitted to the
  [Typst Packages repository][typst-packages] and can be browsed on [Typst Universe].
- [_Unpublished_ packages](#unpublished-typst-packages) are packages that are
  only available from unofficial sources.
  They can be stored locally on your system, on a GitHub repository, or elsewhere.
  ("Unpublished" can also refer to unpublished versions of a package which has
  published versions.)

[Typst Universe]: https://typst.app/universe/

The method to get Typst packages working differs depending on whether they are
published or unpublished.

## Published Typst packages

Published Typst packages work out of the box for for [`watchTypstProject`] and
commands executed while [`devShell`] is active.

For [`buildTypstProject`], [`buildTypstProjectLocal`], and [`mkTypstDerivation`],
there are two methods:

<!-- markdownlint-disable link-fragments -->

- [`unstable_typstPackages`](#the-typstpackages-attribute) (recommended)
- [`TYPST_PACKAGE_CACHE_PATH`](#the-typst_package_cache_path-environment-variable)

<!-- markdownlint-enable link-fragments -->

It is recommended to use `unstable_typstPackages`, as it is faster and consumes
less disk space.

### The `unstable_typstPackages` attribute { #the-typstpackages-attribute }

The `unstable_typstPackages` attribute is used to fetch packages from the official
Typst packages CDN at `https://packages.typst.org`.

For more information, see the respective documentation for the attribute on
[`buildTypstProject`], [`buildTypstProjectLocal`], and [`mkTypstDerivation`].

```nix
{
  outputs = {
    nixpkgs,
    typix,
  }: let
    inherit (nixpkgs) lib;
    system = "x86_64-linux";

    unstable_typstPackages = [
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
      inherit unstable_typstPackages;
      # ...
    };

    build-script = typix.lib.${system}.buildTypstProjectLocal {
      inherit unstable_typstPackages;
      # ...
    };
  in {
    packages.${system}.default = build-drv;
    apps.${system}.default = {
      type = "app";
      program = lib.getExe build-script;
    };
  };
}
```

### The `TYPST_PACKAGE_CACHE_PATH` environment variable

This method downloads the _entire_ contents of the [Typst Packages repository][typst-packages],
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
    inherit (nixpkgs) lib;
    system = "x86_64-linux";

    build-drv = typix.lib.${system}.buildTypstProject {
      TYPST_PACKAGE_CACHE_PATH = "${typst-packages}/packages";
      # ...
    };

    build-script = typix.lib.${system}.buildTypstProjectLocal {
      TYPST_PACKAGE_CACHE_PATH = "${typst-packages}/packages";
      # ...
    };
  in {
    packages.${system}.default = build-drv;
    apps.${system}.default = {
      type = "app";
      program = lib.getExe build-script;
    };
  };
}
```

## Unpublished Typst packages

If the Typst package you want to use is stored locally — in the same repository
as your flake — all you have to do is directly [import] the entrypoint module:

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

Add the GitHub repository containing the unpublished Typst package to [flake inputs]:

[flake inputs]: https://nix.dev/manual/nix/2.24/command-ref/new-cli/nix3-flake#flake-references

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
    inherit (lib.strings) escapeShellArg;

    mkTypstPackagesDrv = name: entries: let
      linkFarmEntries =
        lib.foldl (set: {
          name,
          version,
          namespace,
          input,
        }:
          set
          // {
            "${namespace}/${name}/${version}" = input;
          })
        {}
        entries;
    in
      pkgs.linkFarm name linkFarmEntries;

    unpublishedTypstPackages = mkTypstPackagesDrv "unpublished-typst-packages" [
      # Unpublished packages can be added here
      {
        name = "my-typst-package";
        version = "0.1.0";
        namespace = "local";
        input = my-typst-package;
      }
    ];

    # Any transitive dependencies on published packages must be added here
    unstable_typstPackages = [
      {
        name = "oxifmt";
        version = "0.2.1";
        hash = "sha256-8PNPa9TGFybMZ1uuJwb5ET0WGIInmIgg8h24BmdfxlU=";
      }
    ];

    build-drv = typix.lib.${system}.buildTypstProject {
      inherit unstable_typstPackages;
      TYPST_PACKAGE_PATH = unpublishedTypstPackages;
      # ...
    };

    build-script = typix.lib.${system}.buildTypstProjectLocal {
      inherit unstable_typstPackages;
      TYPST_PACKAGE_PATH = unpublishedTypstPackages;
      # ...
    };

    watch-script = typix.lib.${system}.watchTypstProject {
      # `watchTypstProject` can already access published packages, so
      # `unstable_typstPackages` is not needed here
      typstWatchCommand = "TYPST_PACKAGE_PATH=${escapeShellArg unpublishedTypstPackages} typst watch";
      # ...
    };
  in {
    packages.${system}.default = build-drv;
    apps.${system}.default = {
      type = "app";
      program = lib.getExe build-script;
    };
    apps.${system}.watch = {
      type = "app";
      program = lib.getExe watch-script;
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

[typst-packages]: https://github.com/typst/packages
[`buildTypstProjectLocal`]: ../api/derivations/build-typst-project-local.md#typstpackages
[`buildTypstProject`]: ../api/derivations/build-typst-project.md#typstpackages
[`devShell`]: ../api/derivations/dev-shell.md
[`mkTypstDerivation`]: ../api/derivations/mk-typst-derivation.md#typstpackages
[`watchTypstProject`]: ../api/derivations/watch-typst-project.md
