{
  lib,
  newScope,
}:
lib.makeScope newScope (self: let
  inherit (self) callPackage;
in {
  buildTypstProject = callPackage ./buildTypstProject.nix {};
  coerceLocalPathAttr = callPackage ./coerceLocalPathAttr.nix {};
  copyLocalPathsHook = callPackage ./setupHooks/copyLocalPaths.nix {};
  devShell = callPackage ./devShell.nix {};
  mkTypstDerivation = callPackage ./mkTypstDerivation.nix {};
  typstOptsFromArgs = callPackage ./typstOptsFromArgs.nix {};
  watchTypstProject = callPackage ./watchTypstProject.nix {};
})
