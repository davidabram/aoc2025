{
  description = "AOC 2025";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            ocaml
            dune_3
            opam

            ocamlPackages.ocaml-lsp
            ocamlPackages.ocamlformat
            ocamlPackages.utop

            ocamlPackages.findlib
          ];

          shellHook = ''
            if [ ! -d "$HOME/.opam" ]; then
              echo "Initializing opam..."
              opam init --disable-sandboxing -y
            fi

            eval $(opam env)

            echo "OCaml development environment loaded!"
            echo "OCaml version: $(ocaml -version)"
            echo "Dune version: $(dune --version)"
            echo "Opam version: $(opam --version)"
            echo "🎄 Happy Christmas 🎅🎁✨"
          '';
        };
      }
    );
}
