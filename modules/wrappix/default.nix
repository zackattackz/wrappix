{pkgs, lib, config, ...}:

with lib;

let
  wrappix-types = import ../../lib/types { inherit lib; };
  envVarsToList = envVarsAttrs: map ({name, value}: {inherit name;} // value) (attrsToList envVarsAttrs);
  envVarsSortFn = a: b:
    if isNull a.order then false
    else if isNull b.order then true
    else a.order < b.order;
  envVarLine = {name, export, combine, value, ...}:
    let 
      exportStr = if export then "export " else "";
      combineFunc =
        if isNull combine then id
        else if combine == "prepend" then value: "${value}:\$${name}"
        else value: "\$${name}:${value}";
      valueStr =
        if !isList value && !isNull combine then throw "Error when evaluating env var ${name}: `combine` must not be set when env var has non-list value:"
        else if isList value
        then combineFunc (concatMapStringsSep ":" toString value)
        else toString value;
    in
      "${exportStr}${name}=\"${valueStr}\"";
  envVarLines = envVars: (concatLines (map envVarLine envVars));
in
{
  options = {
    name = mkOption {
      type = types.nonEmptyStr;
      description = "Name of generated wrapper script file";
    };
    envVars = mkOption {
      type = types.attrsOf wrappix-types.envVar;
      default = {};
      description = "All environment variables to define in the wrapper";
    };
    wrapper = mkOption {
      type = types.package;
      description = "The final evaluated wrapper shell script";
    };
  };
  config = {
    wrapper = pkgs.writeShellScriptBin config.name (
      (envVarLines (sort envVarsSortFn (envVarsToList config.envVars)))
    );
  };
}