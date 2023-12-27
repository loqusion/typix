{
  lib,
  newScope,
}:
lib.makeScope newScope (self: let
  inherit (self) callPackage;
in {
  buildLocalTypstProject = callPackage ./buildLocalTypstProject.nix {};
  buildTypstProject = callPackage ./buildTypstProject.nix {};
  coerceLocalPathAttr = callPackage ./coerceLocalPathAttr.nix {};
  copyLocalPathsHook = callPackage ./setupHooks/copyLocalPaths.nix {};
  devShell = callPackage ./devShell.nix {};
  inferTypstProjectOutput = callPackage ./inferTypstProjectOutput.nix {};
  linkLocalPaths = callPackage ./linkLocalPaths.nix {};
  mkTypstDerivation = callPackage ./mkTypstDerivation.nix {};
  typstOptsFromArgs = callPackage ./typstOptsFromArgs.nix {};
  watchTypstProject = callPackage ./watchTypstProject.nix {};
})
