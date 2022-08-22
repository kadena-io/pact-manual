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

let

install-markdown-plugin = pkgs.python3Packages.buildPythonApplication rec {
  pname = "mkdocs-install-markdown";
  version = "3.6.1";
  src = pkgs.fetchFromGitHub {
    owner = "mondeja";
    repo = "mkdocs-include-markdown-plugin";
    rev = "9dc4eb8ba721e7d7443712a53765f66afc1a54ff";
    sha256 = "1ymb9shvc3asscpwrg94vk6nah64ndq71djzy1i1w2673m26kw5s";
    # date = "2022-07-28T15:24:26+02:00";
  };
  propagatedBuildInputs = [
    pkgs.python3Packages.mkdocs
  ];
  pythonImportsCheck = [ "mkdocs" ];
  doCheck = false;
};

in with pkgs; pkgs.stdenv.mkDerivation rec {
  name = "pact-manual-${version}";
  version = "0.1";

  src = ./.;

  buildInputs = [
    mkdocs
    python3Packages.pip
    python3Packages.pip-tools
    python3Packages.pymdown-extensions
    install-markdown-plugin
  ];

  env = pkgs.buildEnv { inherit name; paths = buildInputs; };
}
