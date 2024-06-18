{ config, pkgs, lib, ... }: let
  parseJSON = lib.strings.fromJSON;
in {
  options.generated = {
    hash = lib.mkOption {
      type = lib.types.str;
      description = "node_modules hash";
    };
    plugins = lib.mkOption {
      type = lib.types.str;
      description = "valid plugins";
    };
    lock = lib.mkOption {
      type = lib.types.path;
      description = "package-lock.json";
    };
  };
  config.generated = {
    inherit (import ../../generated/hash.nix) hash;
    plugins = lib.attrNames (parseJSON (lib.readFile ../../generated/package.json)).dependencies;
    lock = ../../generated/package-lock.json;
  };
}
