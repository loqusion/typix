# Using Typst packages

> If none of the advice on this page works for you, and there are no [open
> issues][github-open-issues] related to your problem, feel free to [open an
> issue][github-new-issue].

[github-new-issue]: https://github.com/loqusion/typix/issues/new?assignees=&labels=typst+packages&projects=&template=3-typst_packages.md&title=%5BTypst+packages%5D%3A+
[github-open-issues]: https://github.com/loqusion/typix/issues?q=is%3Aissue+is%3Aopen+sort%3Aupdated-desc+label%3A%22typst+packages%22

> You can find a full working example using Typst packages [here][github-example].

[github-example]: https://github.com/loqusion/typix/blob/main/examples/typst-packages/flake.nix

[Typst packages][typst-packages] are still experimental, so Typix doesn't
provide direct support for them yet. However, there are ways you can get them to
work.

[typst-packages]: https://github.com/typst/packages

Typst packages _should_ work out of the box for:

- [`watchTypstProject`](../api/derivations/watch-typst-project.md)
- [`devShell`](../api/derivations/dev-shell.md)

For the other derivation constructors, see below.

## Providing the package cache

Typst [caches downloaded packages][typst-packages-cache] for a given `namespace`
in `{cache-dir}/typst/packages/{namespace}`.

[typst-packages-cache]: https://github.com/typst/packages?tab=readme-ov-file#downloads

With flake inputs defined like:

```nix
{
  inputs.typst-packages = {
    url = "github:typst/packages";
    flake = false;
  };

  # Contrived example of an additional package repository
  inputs.my-typst-packages = {
    url = "github:loqusion/my-typst-packages";
    flake = false;
  };
}
```

...we can provide them where Typst expects them:

```nix
let
  typstPackagesSrc = pkgs.symlinkJoin {
    name = "typst-packages-src";
    paths = [
      "${inputs.typst-packages}/packages"
      "${inputs.my-typst-packages}/..."
    ];
  };
  # You can use this if you only need to use official packages
  # typstPackagesSrc = "${inputs.typst-packages}/packages";

  typstPackagesCache = pkgs.stdenv.mkDerivation {
    name = "typst-packages-cache";
    src = typstPackagesSrc;
    dontBuild = true;
    installPhase = ''
      mkdir -p "$out/typst/packages"
      cp -LR --reflink=auto --no-preserve=mode -t "$out/typst/packages" "$src"/*
    '';
  };
in {
  build-drv = typixLib.buildTypstProject {
    XDG_CACHE_HOME = typstPackagesCache;
    # ...
  };

  build-script = typixLib.buildTypstProjectLocal {
    XDG_CACHE_HOME = typstPackagesCache;
    # ...
  };
}
```

Then, we can use them in a Typst file like so:

```typst
#import "@preview/example:0.1.0"
#import "@loqusion/my-package:0.2.1"
```
