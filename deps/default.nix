{
fetchFromGitHub,
buildNpmPackage,
e2fsprogs,
...
}:

buildNpmPackage {
  name = "koishi";
  yarnLock = ./yarn.lock;
  npmFlags = [ "--legacy-peer-deps" ];
  npmDepsHash = "sha256-F4SxOiv0WmZOh2DRBwi3yiKBhx9gGwgQsCn4xzOPtcw=";
  dontNpmBuild = true;
  src = ./.;
}