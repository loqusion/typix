<!-- markdownlint-disable-file first-line-h1 -->

List of sources that will be made virtually available to your Typst project.
Useful for projects which rely on remote resources, such as
[images][typst-ref-image] or [data][typst-ref-data-loading].

Each element of the list is an attribute set with the following keys:

- `src`: path to source directory
- `dest` (optional): path where files will be made available (defaults to `.`)

Instead of an attrset, you may use a path which will be interpreted the same as
if you had specified an attrset with just `src`.

[typst-ref-data-loading]: https://typst.app/docs/reference/data-loading/
[typst-ref-image]: https://typst.app/docs/reference/visualize/image/
