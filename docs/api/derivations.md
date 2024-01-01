# Derivations

As paraphrased from [the Nix Reference Manual][nix-ref-derivations]:

> A derivation is a specification for running an executable on precisely defined
> input files to repeatably produce output files at uniquely determined file
> system paths.

The derivations defined in Typst.nix extend this behavior by running `typst
compile`/`typst watch` in a context where all the dependencies of your Typst
project (fonts, images, etc.) will be made available to the Typst compiler,
regardless of if they're already present on the system it runs on.

- [`buildLocalTypstProject`](derivations/build-local-typst-project.md) — A
  derivation for compiling a Typst project and copying the output to the current
  directory.
- [`buildTypstProject`](derivations/build-typst-project.md) — A derivation for
  compiling a Typst project.
- [`devShell`](derivations/dev-shell.md) — **TODO**
- [`mkTypstDerivation`](derivations/mk-typst-derivation.md) — A generic
  derivation for running Typst commands.
- [`watchTypstDerivation`](derivations/watch-typst-project.md) — A derivation
  for a script that watches an input file and recompiles on changes.

[nix-ref-derivations]: https://nixos.org/manual/nix/stable/language/derivations.html
