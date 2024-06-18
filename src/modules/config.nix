{ config, pkgs, lib, ... }: let
  json = lib.strings.toJSON;
in {
  options = {
    config = lib.mkOption {
      type = lib.types.attrs;
      description = "config";
    };
    configfile = lib.mkOption {
      type = lib.types.path;
      description = "config file";
    };
  };
  config.configfile = pkgs.writeText "koishi.json" (json config.config);
}
