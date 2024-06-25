{ config, pkgs, ... }:
{
  config = {
    name = "order-env";
    envVars = {
      X_TEST = { value = 1; };
      Y_TEST = { value = 1; };
      C_TEST = { value = 1; order = 1; };
      B_TEST = { value = 1; order = -1; };
      A_TEST = { value = 1; order = 0; };
    };
    nmt.script = ''
      actual=${config.wrapper}/bin/order-env
      expected=${
          pkgs.writeShellScriptBin "order-env-expected" ''
            export B_TEST="1"
            export A_TEST="1"
            export C_TEST="1"
            export X_TEST="1"
            export Y_TEST="1"
          ''
        }/bin/order-env-expected
      assertFileExists $actual
      assertFileContent $actual $expected
    '';
  };
  # test.stubs.wrappix = { };
}