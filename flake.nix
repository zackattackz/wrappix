
{
  description = "Build extensible wrapper scripts via nix modules";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs = { self, nixpkgs, ... }:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
    in
      {
        devShells = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          tests = import ./tests { inherit pkgs; };
        in tests.run);
      };
}