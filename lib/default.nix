{
  lib,
  newScope,
}:
lib.makeScope newScope (self: let
  inherit (self) callPackage;
in {
  buildTypstProject = callPackage ./buildTypstProject.nix {};
  copyLocalPathsHook = callPackage ./setupHooks/copyLocalPaths.nix {};
  prepareTypstEnvHook = callPackage ./setupHooks/prepareTypstEnv.nix {};
})
