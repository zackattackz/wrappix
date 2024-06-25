{ config, pkgs, ... }:
{
  config = {
    name = "non-list-env";
    envVars = {
      FLOAT = { value = 1.2; };
      INT = { value = 1; };
      STR = { value = "hello"; };
      PATH = { value = /some/path; };
    };
    nmt.script = ''
      actual=${config.wrapper}/bin/non-list-env
      expected=${
          pkgs.writeShellScriptBin "non-list-env-expected" ''
            export FLOAT="1.200000"
            export INT="1"
            export PATH="/some/path"
            export STR="hello"
          ''
        }/bin/non-list-env-expected
      assertFileExists $actual
      assertFileContent $actual $expected
    '';
  };
  # test.stubs.wrappix = { };
}