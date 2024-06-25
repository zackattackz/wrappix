{ config, pkgs, ... }:
{
  config = {
    name = "export-env";
    envVars = {
      TEST1 = { export = false; value = 1; };
      TEST2 = { export = false; value = 2; };
      TEST3 = { value = 3; };
    };
    nmt.script = ''
      actual=${config.wrapper}/bin/export-env
      expected=${
          pkgs.writeShellScriptBin "export-env-expected" ''
            TEST1="1"
            TEST2="2"
            export TEST3="3"
          ''
        }/bin/export-env-expected
      assertFileExists $actual
      assertFileContent $actual $expected
    '';
  };
  # test.stubs.wrappix = { };
}