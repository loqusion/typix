<!-- markdownlint-disable first-line-h1 -->

<!-- ANCHOR: body -->

<div class="warning">

This is an **unstable** feature. Its API does not follow Semantic Versioning, and
derivations relying on this feature may break at any time, even if you don't
update Typst or Typix.

When this feature reaches stability, it will be renamed to `typstPackages`.

</div>

List of [Typst packages] to use in your Typst project.

Each element of the list is an attribute set with the following keys:

- `name`: the package's identifier in its namespace
- `version`: the package's version as a full major-minor-patch triple
- `namespace` (optional): the package's namespace (defaults to `preview`)
- `hash`: hash of the downloaded package tarball

`hash` must be manually updated to match the hash of the package tarball downloaded
from the registry, using the "fake hash method". See [Updating source hashes][fetchers-hash]
for how to do this.

Note that if a package depends on other packages, you must also specify the exact
version of each of those packages.

There is currently no official support for [Local Typst packages].

[Typst packages]: https://github.com/typst/packages
[fetchers-hash]: https://nixos.org/manual/nixpkgs/stable/#sec-pkgs-fetchers-updating-source-hashes
[Local Typst packages]: https://github.com/typst/packages#local-packages

<!-- ANCHOR_END: body -->

<!-- ANCHOR: example_buildtypstproject -->

```nix
{
  outputs = { typix }: let
    system = "x86_64-linux";
  in {
    packages.${system}.default = typix.lib.${system}.buildTypstProject {
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
    };
  };
}
```

<!-- ANCHOR_END: example_buildtypstproject -->

<!-- ANCHOR: example_buildtypstprojectlocal -->

```nix
{
  outputs = { nixpkgs, typix }: let
    inherit (nixpkgs.lib) getExe;
    system = "x86_64-linux";
    build-script = typix.lib.${system}.buildTypstProjectLocal {
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
    };
  in {
    apps.${system}.default = {
      type = "app";
      program = getExe build-script;
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
