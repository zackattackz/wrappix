{ config, pkgs, ... }:
{
  config = {
    name = "two-env";
    envVars = {
      TEST1 = { value = 1; };
      TEST2 = { value = 2; };
    };
    nmt.script = ''
      actual=${config.wrapper}/bin/two-env
      expected=${
          pkgs.writeShellScriptBin "two-env-expected" ''
            export TEST1="1"
            export TEST2="2"
          ''
        }/bin/two-env-expected
      assertFileExists $actual
      assertFileContent $actual $expected
    '';
  };
  # test.stubs.wrappix = { };
}