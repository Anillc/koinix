{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  outputs = {
    self, nixpkgs, flake-utils
  }: flake-utils.lib.eachDefaultSystem (system: let
    pkgs = import nixpkgs { inherit system; };
  in rec {
    packages._update = pkgs.substituteAll {
      src = ./update.sh;
      dir = "/bin";
      isExecutable = true;
      inherit (pkgs) runtimeShell;
      path = pkgs.lib.makeBinPath (with pkgs; [
        prefetch-npm-deps nodejs jq
      ]);
    };
    lib.buildKoishi = config: pkgs.callPackage ./src { inherit config; };
    packages.default = lib.buildKoishi {
      host = "0.0.0.0";
      port = 8080;
      plugins = {
        # admin = {};
        # bind = {};
        # commands = {};
        # help = {};
        # inspect = {};
        # locales = {};
        # rate-limit = {};
        # analytics = {};
        # console = {};
        # dataview = {};
        # # This causes build failure
        # # explorer = {};
        # logger = {};
        # auth.admin.password = "114514";
        # insight = {};
        # sandbox = {};
        # database-sqlite = {};
        # assets-local = {};
        # puppeteer = {};
        # screenshot = {};
        # echo = {};
      };
    };
  });
}