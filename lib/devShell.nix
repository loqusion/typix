{
  mkShell,
  typst,
}: args @ {packages ? [], ...}:
mkShell (args
  // {
    packages =
      [
        typst
      ]
      ++ packages;
  })
