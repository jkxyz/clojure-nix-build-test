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

        clojure-latest-jdk =
          pkgs.callPackage "${nixpkgs}/pkgs/development/interpreters/clojure" {
            jdk = pkgs.jdk;
          };
      in {
        devShell = pkgs.mkShell {
          buildInputs =
            [ clj2nix.packages.${system}.clj2nix clojure-latest-jdk ];
        };

        packages = {
          example = pkgs.callPackage (import ./example.nix) {
            clojure = clojure-latest-jdk;
          };
        };

        defaultPackage = self.packages.${system}.example;
      });
}
