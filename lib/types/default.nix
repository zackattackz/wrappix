{lib, ...}:

with lib;

{
  envVar = types.submodule {
    options = {
      export = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to add an \"export\" to the variable's definition";
      };
      combine = mkOption {
        type = with types; nullOr (enum ["prepend" "append"]);
        default = null;
        description = "Whether to prepend or append `options.value` to the existing environment variable's value. Only valid for list type `options.value`s";
      };
      # Similar to enviroment.variables of NixOS
      value = mkOption {
        type = with types; oneOf [ (listOf (oneOf [ float int str path ])) float int str path ];
        description = "Value to be assigned to the bash variable. Lists are interpreted as colon separated values";
      };
      order = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = "Determines the order multiple env vars should appear relative to each other in wrapper script. Null is default and should appear after those with defined order";
      };
    };
  };
}