{
fetchFromGitHub,
buildNpmPackage,
writeTextDir,
runCommand,
writeText,
lib,
...
}:

with lib;

deps: buildNpmPackage {
  name = "koishi";
  npmFlags = [ "--ignore-scripts" ];
  npmDepsHash = "sha256-tuC1ZKhvCDcpITpDEBKFpEsqXUVIkiQPVKazOJTfzbI=";
  dontNpmBuild = true;
  src = runCommand "deps" {} ''
    mkdir -p $out
    cp ${writeText "package.json" (strings.toJSON {
      name = "deps";
      version = "0.0.0";
      dependencies = listToAttrs (map (name: nameValuePair name "*") (deps ++ ["koishi"]));
    })} $out/package.json
    cp ${../generated/package-lock.json} $out/package-lock.json
  '';
  installPhase = ''
    mkdir -p $out
    mv node_modules $out/node_modules
  '';
}