{ pkgs }:
let
  self = pkgs.lib.makeScope pkgs.newScope import ./packages.nix;
in
self
