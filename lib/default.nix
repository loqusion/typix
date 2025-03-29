{
  lib,
  newScope,
}:
lib.makeScope newScope (self: let
  inherit (self) callPackage;
in {
  buildTypstProjectLocal = callPackage ./buildTypstProjectLocal.nix {};
  buildTypstProject = callPackage ./buildTypstProject.nix {};
  cleanTypstSource = callPackage ./cleanTypstSource.nix {};
  coerceVirtualPathAttr = callPackage ./coerceVirtualPathAttr.nix {};
  copyVirtualPathsHook = callPackage ./setupHooks/copyVirtualPaths.nix {};
  devShell = callPackage ./devShell.nix {};
  emojiFontPathFromString = callPackage ./emojiFontPathFromString.nix {};
  inferTypstProjectOutput = callPackage ./inferTypstProjectOutput.nix {};
  linkVirtualPaths = callPackage ./linkVirtualPaths.nix {};
  mkTypstDerivation = callPackage ./mkTypstDerivation.nix {};
  typstOptsFromArgs = callPackage ./typstOptsFromArgs.nix {};
  unsetSourceDateEpochHook = callPackage ./setupHooks/unsetSourceDateEpoch.nix {};
  watchTypstProject = callPackage ./watchTypstProject.nix {};
  fetchTypstPackages = callPackage ./fetchTypstPackages.nix {};
})
