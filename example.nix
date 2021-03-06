{ stdenv, jdk, jre, makeWrapper, callPackage }:

let
  deps = callPackage (import ./deps.nix) { };
  classpath = deps.makeClasspaths { };
in stdenv.mkDerivation {
  pname = "example";
  version = "0.0.1";

  src = ./.;

  buildInputs = [ jdk makeWrapper ];

  buildPhase = ''
    mkdir --parents classes
    java --class-path "${classpath}:src" clojure.main --eval "(compile 'example.main)"
  '';

  installPhase = ''
    mkdir --parents $out/{bin,lib}
    cp --recursive --no-target-directory classes $out/lib
    makeWrapper ${jre}/bin/java $out/bin/example \
      --add-flags "--class-path" \
      --add-flags "${classpath}:$out/lib" \
      --add-flags "example.main"
  '';
}
