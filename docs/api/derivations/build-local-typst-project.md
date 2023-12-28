# buildLocalTypstProject

A derivation for compiling a Typst project _and then_ copying the result to the
current directory.

<div class="warning">

Using this derivation requires
<a href="https://nixos.org/manual/nix/stable/command-ref/conf-file#conf-allow-import-from-derivation">
<code>allow-import-from-derivation</code></a>
to be <code>true</code>.

More info:
<a href="https://nixos.org/manual/nix/stable/language/import-from-derivation">
https://nixos.org/manual/nix/stable/language/import-from-derivation
</a>

</div>

## Parameters

> **TODO:** Copy parameters from [`buildTypstProject`](build-typst-project.md)

All parameters are passed to [`buildTypstProject`](build-typst-project.md);
hence, all required parameters for `buildTypstProject` are also required for
`buildLocalTypstProject`.

The only parameters recognized by `buildLocalTypstProject` are as follows:

### `typstProjectOutput` (optional)

Destination path for Typst output.

<!-- markdownlint-disable link-fragments -->

If omitted, will be inferred from [`typstProjectSource`](#typstprojectsource) —
for example, `page.typ` will become `page.pdf` for PDF output.

<!--markdownlint-restore -->

### `typstProjectSource` (optional)

(Also see [`buildTypstProject`](build-typst-project.md#typstprojectsource))

Source path for Typst input. Defaults to `main.typ`.

## Source

- [`buildLocalTypstProject`](https://github.com/loqusion/typst.nix/blob/main/lib/buildLocalTypstProject.nix)
