{ config, pkgs, lib, ... }: {
  options.deps = lib.mkOption {
    type = lib.types.path;
    description = "deps";
  };
  config.deps = pkgs.buildNpmPackage {
    name = "koishi";
    npmFlags = [ "--ignore-scripts" ];
    npmDepsHash = config.generated.hash;
    dontNpmBuild = true;
    src = pkgs.runCommand "deps" {} ''
      mkdir -p $out
      cp ${config.pj} $out/package.json
      cp ${config.generated.lock} $out/package-lock.json
    '';
    installPhase = ''
      mkdir -p $out
      mv node_modules $out/node_modules
    '';
  };
}
