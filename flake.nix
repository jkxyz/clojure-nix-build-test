{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    clj2nix.url = "github:hlolli/clj2nix";
    clj2nix.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, clj2nix, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        deps = pkgs.callPackage (import ./deps.nix) { };
        classpath = deps.makeClasspaths { };
        example = pkgs.stdenv.mkDerivation {
          pname = "example";
          version = "0.0.1";

          buildInputs = [ pkgs.clojure pkgs.makeWrapper ];

          buildPhase = ''
            mkdir -p classes
            clojure -Scp "${classpath}:src" -e "(compile 'example.main)"
          '';

          dontFixup = true;

          installPhase = ''
            mkdir -p $out/{bin,lib}
            cp -rT classes $out/lib
            makeWrapper ${pkgs.openjdk}/bin/java $out/bin/example \
              --add-flags "-cp" \
              --add-flags "${classpath}:$out/lib" \
              --add-flags "example.main"
          '';
        };
      in {
        devShell = pkgs.mkShell {
          buildInputs = [ clj2nix.packages.${system}.clj2nix ];
        };

        defaultPackage = example;
      });
}
