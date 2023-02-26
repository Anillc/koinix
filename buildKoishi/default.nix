{
writeScriptBin,
runtimeShell,
buildDeps,
writeText,
nodejs,
lib,
...
}:

with builtins;
with lib;

config: let
  validPlugins = attrNames (strings.fromJSON (readFile ../generated/package.json)).dependencies;
  plugins = attrNames config.plugins;
  deps = buildDeps (foldl' (acc: x:
    if elem "@koishijs/plugin-${x}" validPlugins then acc ++ ["@koishijs/plugin-${x}"]
    else if elem "koishi-plugin-${x}" validPlugins then acc ++ ["koishi-plugin-${x}"]
    else if elem x validPlugins then acc ++ [x]
    else throw "Unknown koishi plugin: ${x}") [] plugins);
in writeScriptBin "koishi" ''
  #!${runtimeShell}
  export PATH=$PATH:${makeBinPath [ nodejs ]}
  ${deps}/node_modules/.bin/koishi start ${writeText "koishi.json" (strings.toJSON config)}
''