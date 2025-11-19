{ lib }:
let
  isDerivation = lib.isDerivation;
  flatAttr =
    prefix: obj:
    builtins.foldl' (
      acc: key:
      let
        val = obj.${key};
        newPrefix = if prefix == "" then key else "${prefix}.${key}";
      in
      acc
      // (
        if isDerivation val then
          { "${newPrefix}" = val; }
        else if builtins.isAttrs val then
          (flatAttr newPrefix val)
        else
          { "${newPrefix}" = val; }
      )
    ) { } (builtins.attrNames obj);
in
flatAttr ""
