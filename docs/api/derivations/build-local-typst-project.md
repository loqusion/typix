# buildLocalTypstProject

A derivation for building a Typst project _and then_ copying the result to the
current directory.

## Parameters

> **TODO:** Copy parameters from [`buildTypstProject`](build-typst-project.md)

All parameters are passed to [`buildTypstProject`](build-typst-project.md);
hence, all required parameters for `buildTypstProject` are also required for
`buildLocalTypstProject`.

The only parameters recognized by `buildLocalTypstProject` are as follows:

### `typstProjectOutput` (optional)

Destination path for Typst output.

If omitted, will be inferred from [`typstProjectSource`](#typstprojectsource) —
for example, `page.typ` will become `page.pdf` for PDF output.

### `typstProjectSource` (optional)

(Also see [`buildTypstProject`](build-typst-project.md#typstprojectsource))

Source path for Typst input. Defaults to `main.typ`.

## Source

- [`buildLocalTypstProject`](https://github.com/loqusion/typst.nix/blob/main/lib/buildLocalTypstProject.nix)
