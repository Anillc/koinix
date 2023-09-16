{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  outputs = {
    self, nixpkgs, flake-utils
  }: flake-utils.lib.eachDefaultSystem (system: let
    pkgs = import nixpkgs { inherit system; };
  in rec {
    apps.update = flake-utils.lib.mkApp {
      drv = pkgs.writeScriptBin "update" ''
        export PATH=$PATH:${pkgs.lib.makeBinPath (with pkgs; [
          prefetch-npm-deps nodejs yarn
        ])}

        cd locker
        if [ ! -d node_modules ]; then
          yarn
        fi
        ./build.sh
        cp ./lock/* ../generated
        cd ..

        npmDepsHash=$(prefetch-npm-deps ./generated/package-lock.json)
        cat > ./generated/hash.nix <<EOF
        {
          npmDepsHash = "$npmDepsHash";
        }
        EOF
      '';
    };
    packages.buildDeps = pkgs.callPackage ./buildDeps {};
    packages.buildKoishi = pkgs.callPackage ./buildKoishi { inherit (packages) buildDeps; };
    packages.default = packages.buildKoishi {
      host = "0.0.0.0";
      port = 8080;
      plugins = {
        admin = {};
        bind = {};
        commands = {};
        help = {};
        inspect = {};
        locales = {};
        rate-limit = {};
        analytics = {};
        console = {};
        dataview = {};
        explorer = {};
        logger = {};
        auth.admin.password = "114514";
        insight = {};
        sandbox = {};
        database-sqlite = {};
        assets-local = {};
        puppeteer = {};
        screenshot = {};
        echo = {};
      };
    };
  });
}