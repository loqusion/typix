# buildTypstProject

A derivation for compiling a Typst project.

If you want to build to the project directory, use
[`buildLocalTypstProject`](build-local-typst-project.md) instead.

## Parameters

All parameters accepted by
[`mkTypstDerivation`](mk-typst-derivation.md#parameters) are also accepted by
`buildTypstProject` (except for
[`buildPhaseTypstCommand`](mk-typst-derivation.md#buildphasetypstcommand), which
is constructed from the below parameters).

### `typstCompileCommand` (optional) { #typstcompilecommand }

Base Typst command to run to compile the project. `buildTypstProject` will
append other arguments based on the other parameters you supply. Default is
`typst compile`.

### `typstOpts` (optional) { #typstopts }

<!-- markdownlint-disable link-fragments -->

Attrset specifying command-line options to pass to `typstCompileCommand`, in
addition to any that you manually pass in
[`typstCompileCommand`](#typstcompilecommand).

<!-- markdownlint-restore -->

Default:

```nix
{
  format = "pdf";
}
```

#### Example { #typstopts-example }

```nix
{
  format = "png";
  ppi = 300;
}
```

...will result in a command like:

```sh
typst compile --format png --ppi 300 <source> <output>
```

### `typstProjectSource` (optional) { #typstprojectsource }

Typst input file to compile. Default is `main.typ`.

## Source

- [`buildTypstProject`](https://github.com/loqusion/typst.nix/blob/main/lib/buildTypstProject.nix)
