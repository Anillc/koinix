{ pkgs, lib, config, ... }: let
  moduleFiles = lib.attrNames (builtins.readDir ./modules);
  modules = map (name: ./modules/${name}) moduleFiles;
in (lib.evalModules {
  specialArgs = { inherit pkgs; };
  modules = modules ++ [ { config = { inherit config; }; } ];
}).config.koishi
