{ config, pkgs, lib, ... }: let
  json = lib.strings.toJSON;
  plugins = lib.attrNames config.config;
  valid = config.generated.plugins;
  deps = [ "koishi" ] ++ (map (plugin:
    if lib.elem "@koishijs/plugin-${plugin}" valid then "@koishijs/plugin-${plugin}"
    else if lib.elem "koishi-plugin-${plugin}" valid then "koishi-plugin-${plugin}"
    else if lib.elem plugin valid then plugin
    else throw "Unknown koishi plugin: ${plugin}") plugins);
in {
  options.pj = lib.mkOption {
    type = lib.types.path;
    description = "package.json";
  };
  config.pj = pkgs.writeText "package.json" (json {
    name = "deps";
    version = "0.0.0";
    dependencies = lib.listToAttrs (map (name: lib.nameValuePair name "*") deps);
  });
}
