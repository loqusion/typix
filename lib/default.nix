{
  lib,
  newScope,
}:
lib.makeScope newScope (self: let
  inherit (self) callPackage;
in {
  buildTypstProject = callPackage ./buildTypstProject.nix {};
})
