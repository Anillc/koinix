{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  outputs = {
    self, nixpkgs, flake-utils
  }: flake-utils.lib.eachDefaultSystem (system: let
    pkgs = import nixpkgs { inherit system; };
  in rec {
    packages.buildDeps = pkgs.callPackage ./buildDeps {};
    packages.buildKoishi = pkgs.callPackage ./buildKoishi { inherit (packages) buildDeps; };
    packages.default = packages.buildKoishi {
      host = "0.0.0.0";
      port = 8080;
      plugins = {
        echo = {};
        console = {};
        sandbox = {};
        rryth = {};
      };
    };
  });
}