{ stdenv, clojure, jdk, makeWrapper, callPackage }:

let
  deps = callPackage (import ./deps.nix) { };
  classpath = deps.makeClasspaths { };
in stdenv.mkDerivation {
  pname = "example";
  version = "0.0.1";

  src = ./.;

  buildInputs = [ clojure makeWrapper ];

  buildPhase = ''
    mkdir -p classes
    HOME=. clojure -Srepro -Scp "${classpath}:src" -e "(compile 'example.main)"
  '';

  dontFixup = true;

  installPhase = ''
    mkdir -p $out/{bin,lib}
    cp -rT classes $out/lib
    makeWrapper ${jdk}/bin/java $out/bin/example \
      --add-flags "-cp" \
      --add-flags "${classpath}:$out/lib" \
      --add-flags "example.main"
  '';
}
