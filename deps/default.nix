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
  npmFlags = [ "--legacy-peer-deps" ];
  npmDepsHash = "sha256-F4SxOiv0WmZOh2DRBwi3yiKBhx9gGwgQsCn4xzOPtcw=";
  dontNpmBuild = true;
  src = runCommand "deps" {} ''
    mkdir -p $out
    cp ${writeText "package.json" (lib.strings.toJSON {
      name = "deps";
      version = "0.0.0";
      dependencies = listToAttrs (map (name: nameValuePair name "*") (deps ++ ["koishi"]));
    })} $out/package.json
    cp ${./package-lock.json} $out/package-lock.json
  '';
  installPhase = ''
    mkdir -p $out
    mv node_modules $out/node_modules
  '';
}