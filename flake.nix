{
  description = "Minimal Haskell flake for dev shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        hpkgs = pkgs.haskellPackages;
        hsklPkgs = [ hpkgs.haskell-language-server hpkgs.stack pkgs.ghc ];
      in {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [ just direnv ] ++ hsklPkgs;
        };
      });
}

