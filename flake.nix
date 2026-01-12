{
  description = "my project description";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        hPkgs = pkgs.haskell.packages."ghc984";

        # Wrap Stack to work with our Nix integration.
        stack-wrapped = pkgs.symlinkJoin {
          name = "stack";
          paths = [ pkgs.stack ];
          buildInputs = [ pkgs.makeWrapper ];
          postBuild = ''
            wrapProgram $out/bin/stack \
              --add-flags "\
                --no-nix \
                --system-ghc \
                --no-install-ghc \
              "
          '';
        };

        repoScripts = {
          startdev = pkgs.writeShellApplication {
            name = "startdev";
            runtimeInputs = [ hPkgs.ghcid stack-wrapped pkgs.bash ];
            text = ''
              set -euo pipefail
              ghcid --command="stack ghci"
            '';
          };

          fmt = pkgs.writeShellApplication {
            name = "fmt";
            runtimeInputs = [ hPkgs.ormolu pkgs.findutils pkgs.coreutils ];
            text = ''
              set -euo pipefail
              find . -name '*.hs' -print0 | xargs -0 ormolu -i
            '';
          };
        };

        myDevTools = [
          hPkgs.ghc
          hPkgs.ghcid
          hPkgs.ormolu
          hPkgs.hlint
          hPkgs.hoogle
          hPkgs.haskell-language-server
          hPkgs.implicit-hie
          hPkgs.retrie
          stack-wrapped
          pkgs.zlib
        ];

      in {
        devShells.default = pkgs.mkShell {
          packages = myDevTools ++ (builtins.attrValues repoScripts);

          LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath myDevTools;
        };
      });
}

