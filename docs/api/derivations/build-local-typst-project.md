# buildLocalTypstProject

A derivation for compiling a Typst project and copying the output to the current
directory.

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
`buildLocalTypstProject`. They are repeated below for convenience.

### `fontPaths` (optional) { #fontpaths }

{{#include common/font-paths.md}}

#### Example { #fontpaths-example }

{{#include common/font-paths-example.md:buildlocaltypstproject_example}}

### `installPhaseCommand` (optional) { #installphasecommand }

{{#include common/install-phase-command.md}}

### `localPaths` (optional) { #localpaths }

{{#include common/local-paths.md}}

#### Example { #localpaths-example }

{{#include common/local-paths-example.md:head}}
{{#include common/local-paths-example.md:buildlocaltypstproject_example}}
{{#include common/local-paths-example.md:tail}}

### `typstCompileCommand` (optional) { #typstcompilecommand }

{{#include common/typst-compile-command.md}}

### `typstOpts` (optional) { #typstopts }

{{#include common/typst-opts.md:head}}

<!-- markdownlint-disable link-fragments -->

These are in addition to any options you manually pass in
[`typstCompileCommand`](#typstcompilecommand).

<!-- markdownlint-restore -->

{{#include common/typst-opts.md:tail}}

#### Example { #typstopts-example }

{{#include common/typst-opts-example.md:head}}
{{#include common/typst-opts-example.md:typstcompile}}

### `typstOutput` (optional) { #typstoutput }

{{#include common/typst-project-output.md:head}}
{{#include common/typst-project-output.md:buildlocaltypstproject}}

### `typstSource` (optional) { #typstsource }

{{#include common/typst-project-source.md}}

## Source

- [`buildLocalTypstProject`](https://github.com/loqusion/typst.nix/blob/main/lib/buildLocalTypstProject.nix)
