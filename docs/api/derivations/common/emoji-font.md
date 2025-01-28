Specify which emoji font to use. If `emojiFont` is `null`, no emoji font will
be included.

May be any of the following:

- [`"twemoji"`](https://search.nixos.org/packages?channel=unstable&show=twemoji-color-font) (default)
- [`"twemoji-cbdt"`](https://search.nixos.org/packages?channel=unstable&show=twitter-color-emoji)
- [`"noto"`](https://search.nixos.org/packages?channel=unstable&show=noto-fonts-color-emoji)
- [`"noto-monochrome"`](https://search.nixos.org/packages?channel=unstable&show=noto-fonts-monochrome-emoji)
- [`"emojione"`](https://search.nixos.org/packages?channel=unstable&show=emojione)
- `null` — Don't include any emoji font (e.g. so you can include your own)

<details>
<summary>Note about difference between <code>"twemoji"</code> and <code>"twemoji-cbdt"</code></summary>

The default Twemoji font displays color emojis using the SVG [font format],
which may not be supported by some systems. If emojis aren't displaying
properly, using `"twemoji-cbdt"` may fix it.

[font format]: https://www.colorfonts.wtf/

</details>
