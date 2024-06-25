{ pkgs ? import <nixpkgs> { }}:

let
  lib = pkgs.lib;
  nmtSrc = fetchTarball {
    url = "https://git.sr.ht/~rycee/nmt/archive/v0.5.1.tar.gz";
    sha256 = "0qhn7nnwdwzh910ss78ga2d00v42b0lspfd7ybl61mpfgz3lmdcj";
  };

  modules = [
    ../modules/wrappix
    # For some reason, need this for nmt
    ( {...}: {
      config = {
        _module.args.pkgs = lib.mkDefault pkgs;
        #_module.args.pkgsPath = pkgs.path;
      };
    })
  ];

in
  import nmtSrc {
    inherit pkgs lib modules;
    testedAttrPath = [ "wrapper" ];
    tests = lib.foldl' (a: b: a // (import b)) { } ([
      ./modules/wrappix
    ]);
  }