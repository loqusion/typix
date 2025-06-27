<!-- markdownlint-disable-file first-line-h1 -->

<!-- ANCHOR: head -->

```nix
{
  format = "png";
  ppi = 300;
  input = ["key1=value1" "key2=value2"];
}
```

...will result in a command like:

<!-- ANCHOR_END: head -->

<!-- ANCHOR: typstcompile -->

```sh
typst compile --format png --ppi 300 --input key1=value1 --input key2=value2 <source> <output>
```

<!-- ANCHOR_END: typstcompile -->

<!-- ANCHOR: typstwatch -->

```sh
typst watch --format png --ppi 300 --input key1=value1 --input key2=value2 <source> <output>
```

<!-- ANCHOR_END: typstwatch -->
