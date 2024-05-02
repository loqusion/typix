<!-- markdownlint-disable-file first-line-h1 -->

List of sources that will be made virtually available to your Typst project.
Useful for projects which rely on remote resources, such as
[images][typst-ref-image] or [data][typst-ref-data-loading].

Each element of the list is an attribute set with the following keys:

- `src`: path to source file or directory
- `dest` (optional): path where file(s) will be made available (defaults to `.`)
  - If `src` is a directory, `dest` will be a directory containing those files.
    - Specifying the same `dest` for multiple `src` directories will merge them.
  - If `src` is a file, `dest` will be a copy of that file.

Instead of an attrset, you may use a path which will be interpreted the same as
if you had specified an attrset with just `src`.

[typst-ref-data-loading]: https://typst.app/docs/reference/data-loading/
[typst-ref-image]: https://typst.app/docs/reference/visualize/image/
