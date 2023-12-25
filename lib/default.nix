{
  lib,
  newScope,
}:
lib.makeScope newScope (self: let
  inherit (self) callPackage;
in {
  buildTypstProject = callPackage ./buildTypstProject.nix {};
  copyLocalPathsHook = callPackage ./setupHooks/copyLocalPaths.nix {};
  mkTypstDerivation = callPackage ./mkTypstDerivation.nix {};
  prepareTypstEnvHook = callPackage ./setupHooks/prepareTypstEnv.nix {};
  typstOptsFromArgs = callPackage ./typstOptsFromArgs.nix {};
  watchTypstProject = callPackage ./watchTypstProject.nix {};
})
