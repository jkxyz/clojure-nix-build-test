# generated by clj2nix-1.1.0-rc
{ fetchMavenArtifact, fetchgit, lib }:

let repos = [
        "https://repo1.maven.org/maven2/"
        "https://repo.clojars.org/" ];

  in rec {
      makePaths = {extraClasspaths ? []}:
        if (builtins.typeOf extraClasspaths != "list")
        then builtins.throw "extraClasspaths must be of type 'list'!"
        else (lib.concatMap (dep:
          builtins.map (path:
            if builtins.isString path then
              path
            else if builtins.hasAttr "jar" path then
              path.jar
            else if builtins.hasAttr "outPath" path then
              path.outPath
            else
              path
            )
          dep.paths)
        packages) ++ extraClasspaths;
      makeClasspaths = {extraClasspaths ? []}:
       if (builtins.typeOf extraClasspaths != "list")
       then builtins.throw "extraClasspaths must be of type 'list'!"
       else builtins.concatStringsSep ":" (makePaths {inherit extraClasspaths;});
      packageSources = builtins.map (dep: dep.src) packages;
      packages = [
  rec {
    name = "clojure/org.clojure";
    src = fetchMavenArtifact {
      inherit repos;
      artifactId = "clojure";
      groupId = "org.clojure";
      sha512 = "4fd9e8b783e3f504c03a34a6479c033204d22c06dc72eaeeb4833f9298baf2dbcd045ec2eaf34da17087f2a622ce566e2c1623435c0b98c7674b583c91dfb6ad";
      version = "1.11.0-rc1";
      
    };
    paths = [ src ];
  }

  rec {
    name = "spec.alpha/org.clojure";
    src = fetchMavenArtifact {
      inherit repos;
      artifactId = "spec.alpha";
      groupId = "org.clojure";
      sha512 = "ddfe4fa84622abd8ac56e2aa565a56e6bdc0bf330f377ff3e269ddc241bb9dbcac332c13502dfd4c09c2c08fe24d8d2e8cf3d04a1bc819ca5657b4e41feaa7c2";
      version = "0.3.218";
      
    };
    paths = [ src ];
  }

  rec {
    name = "core.specs.alpha/org.clojure";
    src = fetchMavenArtifact {
      inherit repos;
      artifactId = "core.specs.alpha";
      groupId = "org.clojure";
      sha512 = "f521f95b362a47bb35f7c85528c34537f905fb3dd24f2284201e445635a0df701b35d8419d53c6507cc78d3717c1f83cda35ea4c82abd8943cd2ab3de3fcad70";
      version = "0.2.62";
      
    };
    paths = [ src ];
  }

  ];
  }
  