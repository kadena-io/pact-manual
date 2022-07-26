args@{
  rev    ? "2f0c3be57c348f4cfd8820f2d189e29a685d9c41"
, sha256 ? "03zk4dpalfjkjbb7n0n9v23q011rpcp0cccmbi9ybpaagw49yv1i"

, pkgs   ? import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
    inherit sha256; }) {
    config.allowUnfree = true;
    config.allowBroken = false;
  }
}:

with pkgs; pkgs.stdenv.mkDerivation rec {
  name = "pact-manual-${version}";
  version = "0.1";

  src = ./.;

  buildInputs = [
    mkdocs python3Packages.pip python3Packages.pip-tools
  ];

  env = pkgs.buildEnv { inherit name; paths = buildInputs; };
}
