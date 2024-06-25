{ config, pkgs, ... }:
{
  config = {
    name = "list-env";
    envVars = {
      TEST1 = { value = [1 2 3]; };
      TEST2 = { value = ["a" "b" "c"]; combine = "prepend"; };
      TEST3 = { value = [1 "b" 3]; combine = "append"; };
    };
    nmt.script = ''
      actual=${config.wrapper}/bin/list-env
      expected=${
          pkgs.writeShellScriptBin "list-env-expected" ''
            export TEST1="1:2:3"
            export TEST2="a:b:c:$TEST2"
            export TEST3="$TEST3:1:b:3"
          ''
        }/bin/list-env-expected
      assertFileExists $actual
      assertFileContent $actual $expected
    '';
  };
  # test.stubs.wrappix = { };
}