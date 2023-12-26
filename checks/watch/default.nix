{
  pkgs,
  watchTypstProject,
}:
watchTypstProject {
  fontPaths = [
    "${pkgs.roboto}/share/fonts/truetype"
  ];
  localPaths = [
    {
      src = ../fixtures/icons;
      dest = "icons";
    }
  ];
}
