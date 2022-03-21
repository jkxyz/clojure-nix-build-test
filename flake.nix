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
        clojure-latest-jdk = pkgs.clojure.override { jdk = pkgs.jdk; };
      in {
        devShell = pkgs.mkShell {
          buildInputs =
            [ clj2nix.packages.${system}.clj2nix clojure-latest-jdk pkgs.jdk ];
        };

        packages =
          let jre = pkgs.jre_minimal.override { jdk = pkgs.jdk17_headless; };
          in rec {
            example = pkgs.callPackage (import ./example.nix) { jre = jre; };

            exampleDockerImage = pkgs.dockerTools.buildImage {
              name = "example";
              fromImage = pkgs.dockerTools.buildImage {
                name = "example-base";
                contents = [ jre ];
              };
              config = { Cmd = [ "${example}/bin/example" ]; };
            };
          };

        defaultPackage = self.packages.${system}.example;
      });
}
