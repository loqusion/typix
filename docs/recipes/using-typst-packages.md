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

TODO

[`buildTypstProjectLocal`]: ../api/derivations/build-typst-project-local.md#typstpackages
[`buildTypstProject`]: ../api/derivations/build-typst-project.md#typstpackages
[`devShell`]: ../api/derivations/dev-shell.md
[`mkTypstDerivation`]: ../api/derivations/mk-typst-derivation.md#typstpackages
[`watchTypstProject`]: ../api/derivations/watch-typst-project.md
