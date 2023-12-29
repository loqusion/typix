# buildLocalTypstProject

A derivation for compiling a Typst project _and then_ copying the result to the
current directory.

This is essentially a script which wraps
[`buildTypstProject`](build-typst-project.md).

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

All parameters accepted by
[`buildTypstProject`](build-typst-project.md#parameters) are also accepted by
`buildLocalTypstProject`.

### `typstProjectOutput` (optional) { #typstprojectoutput }

Destination path for Typst output.

If omitted, it will be inferred from
[`typstProjectSource`](build-typst-project.md#typstprojectsource) — for example,
`page.typ` will become `page.pdf` for PDF output.

## Source

- [`buildLocalTypstProject`](https://github.com/loqusion/typst.nix/blob/main/lib/buildLocalTypstProject.nix)
