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

let
  hash = import ./hash.nix;
in deps: buildNpmPackage {
  name = "koishi";
  npmFlags = [ "--ignore-scripts" ];
  inherit (hash) npmDepsHash;
  # npmDepsHash = "sha256-vnjzIHl6MIDxKh8TM/GtJwbMlwni9DT5lmewtb4Y7bI=";
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