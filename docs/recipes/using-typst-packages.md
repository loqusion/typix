# Using Typst packages

Typst packages aren't currently supported, but as a workaround you can run Typst
commands in a [dev shell](declaring-a-shell-environment.md). (This sacrifices
some of Nix's reproducibility guarantees.)

<!-- markdownlint-disable heading-increment -->

### Interactively

```bash
nix develop # or use direnv
typst compile main.typ main.pdf
```

### In a script

```bash
nix develop --command typst compile main.typ main.pdf
```
