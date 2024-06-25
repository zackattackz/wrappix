{ config, pkgs, ... }:
{
  config = {
    name = "one-env";
    envVars = {
      TEST1 = { value = 1; };
    };
    nmt.script = ''
      actual=${config.wrapper}/bin/one-env
      expected=${
          pkgs.writeShellScriptBin "one-env-expected" ''
            export TEST1="1"
          ''
        }/bin/one-env-expected
      assertFileExists $actual
      assertFileContent $actual $expected
    '';
  };
  # test.stubs.wrappix = { };
}