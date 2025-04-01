<!-- markdownlint-disable first-line-h1 -->

<!-- ANCHOR: body -->

<div class="warning">

This is an **unstable** feature. Its API does not follow Semantic Versioning, and
derivations relying on this feature may break at any time, even if you don't
update Typst or Typix.

When this feature reaches stability, it will be renamed to `typstPackages`.
(The old name will be kept as an undocumented alias, to avoid unnecessary
breakage.)

</div>

List of [Typst packages] to use in your Typst project, fetched from the
official Typst packages CDN at `https://packages.typst.org`.

Each element of the list is an attribute set with the following keys:

- `name`: the package's identifier in its namespace
- `version`: the package's version as a full major-minor-patch triple
- `namespace` _(optional)_: the package's namespace (defaults to `preview`)
- `hash`: hash of the downloaded package tarball

`hash` must be manually updated to match the hash of the package tarball downloaded
from the registry, using the "fake hash method". See [Updating source hashes][fetchers-hash]
for how to do this.

Sometimes, you might encounter an error that looks like this:

```text
> help: error occurred while importing this module
>   ┌─ @preview/cetz:0.3.4/src/canvas.typ:3:8
>   │
> 3 │ #import "util.typ"
>   │         ^^^^^^^^^^
> help: error occurred while importing this module
>   ┌─ @preview/cetz:0.3.4/src/lib.typ:3:8
>   │
> 3 │ #import "canvas.typ": canvas
>   │         ^^^^^^^^^^^^
> help: error occurred while importing this module
>   ┌─ main.typ:1:8
>   │
> 1 │ #import "@preview/cetz:0.3.4"
>   │         ^^^^^^^^^^^^^^^^^^^^^
>
For full logs, run 'nix log /nix/store/6jhjxbl7glmy4adpr5wzfgn9jvsyyipf-typst.drv'.
```

In this example, Nix is hiding too much output for us to diagnose the issue.
Run the command again with the [`-L` flag] (in our case, `nix run .#build -L`):

[`-L` flag]: https://nix.dev/manual/nix/2.18/command-ref/new-cli/nix3-run#opt-print-build-logs

```text
> downloading @preview/oxifmt:0.2.1
> error: failed to download package (Network Error: OpenSSL error)
>   ┌─ @preview/cetz:0.3.4/src/deps.typ:1:8
>   │
> 1 │ #import "@preview/oxifmt:0.2.1"
>   │         ^^^^^^^^^^^^^^^^^^^^^^^
> help: error occurred while importing this module
>   ┌─ @preview/cetz:0.3.4/src/util.typ:1:8
>   │
> 1 │ #import "deps.typ"
>   │         ^^^^^^^^^^
> help: error occurred while importing this module
>   ┌─ @preview/cetz:0.3.4/src/canvas.typ:3:8
>   │
> 3 │ #import "util.typ"
>   │         ^^^^^^^^^^
> help: error occurred while importing this module
>   ┌─ @preview/cetz:0.3.4/src/lib.typ:3:8
>   │
> 3 │ #import "canvas.typ": canvas
>   │         ^^^^^^^^^^^^
> help: error occurred while importing this module
>   ┌─ main.typ:1:8
>   │
> 1 │ #import "@preview/cetz:0.3.4"
>   │         ^^^^^^^^^^^^^^^^^^^^^
```

We can see that `cetz` is trying to import `oxifmt` 0.2.1, but Typst can't
download it because Nix derivations are (by design) not run in an environment
which supports networking. To fix this, add `oxifmt` 0.2.1 to
`unstable_typstPackages` alongside your direct dependencies.
(Make sure to match the exact version!!)

There is currently no official support for [unpublished Typst packages].
However, there is a [workaround].

[Typst packages]: https://github.com/typst/packages
[fetchers-hash]: https://nixos.org/manual/nixpkgs/stable/#sec-pkgs-fetchers-updating-source-hashes
[unpublished Typst packages]: https://github.com/typst/packages#local-packages
[workaround]: ../../recipes/using-typst-packages.md#unpublished-typst-packages

<!-- ANCHOR_END: body -->

<!-- ANCHOR: example_buildtypstproject -->

```nix
{
  outputs = { typix }: let
    system = "x86_64-linux";
  in {
    packages.${system}.default = typix.lib.${system}.buildTypstProject {
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
    };
  };
}
```

<!-- ANCHOR_END: example_buildtypstproject -->

<!-- ANCHOR: example_buildtypstprojectlocal -->

```nix
{
  outputs = { nixpkgs, typix }: let
    inherit (nixpkgs) lib;
    system = "x86_64-linux";

    build-script = typix.lib.${system}.buildTypstProjectLocal {
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
    };
  in {
    apps.${system}.default = {
      type = "app";
      program = lib.getExe build-script;
    };
  };
}
```

<!-- ANCHOR_END: example_buildtypstprojectlocal -->

<!-- ANCHOR: example_mktypstderivation -->

```nix
{
  outputs = { typix }: let
    system = "x86_64-linux";
  in {
    packages.${system}.default = typix.lib.${system}.mkTypstDerivation {
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
    };
  };
}
```

<!-- ANCHOR_END: example_mktypstderivation -->

<!-- ANCHOR: example_typst -->

Then you can import and use the package in Typst:

```typst
#import "@preview/cetz:0.3.4"

#cetz.canvas({
  import cetz.draw: *

  circle((0, 0))
  line((0, 0), (2, 1))
})
```

<!-- ANCHOR_END: example_typst -->
