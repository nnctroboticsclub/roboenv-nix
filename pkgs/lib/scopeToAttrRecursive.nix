{ lib }:
let
  isAttrs = lib.isAttrs;
  isDerivation = lib.isDerivation;
  attrNames = lib.attrNames;

  scopeAttrs = [
    "callPackage"
    "newScope"
    "overrideScope"
    "packages"
    "override"
  ];

  cleanupAttrs =
    attrs:
    let
      nonAttrKeys = (builtins.filter (k: !isAttrs attrs.${k}) (attrNames attrs));
      removeKeys = nonAttrKeys ++ scopeAttrs;
    in
    builtins.removeAttrs attrs removeKeys;

  scopeToAttrRecursive =
    v:
    if isDerivation v then
      v
    else if isAttrs v then
      builtins.mapAttrs (k: v: scopeToAttrRecursive v) (cleanupAttrs v)
    else
      v;
in
scopeToAttrRecursive
