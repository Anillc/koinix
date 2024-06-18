{ config, pkgs, lib, ... }: {
  options.koishi = lib.mkOption {
    type = lib.types.path;
    description = "koishi";
  };
  config.koishi = pkgs.writeScriptBin "koishi" ''
    #!${pkgs.runtimeShell}
    set -u
    export PATH=$PATH:${lib.makeBinPath [ pkgs.nodejs ]}
    # koishi won't interpolate when config is not writable
    cp --no-preserve=mode ${config.configfile} koishi.json
    cp --no-preserve=mode ${config.pj} package.json
    ${config.deps}/node_modules/.bin/koishi start koishi.json
  '';
}
