{ pkgs ? import (builtins.fetchTarball {
  name = "nixos-unstable-2020-09-14";
  url =
    "https://github.com/nixos/nixpkgs/archive/79b9007c941fc2921d2bea2b01a94da20c8c6e4d.tar.gz";
  sha256 = "114vg2yx1ammj6d950g77hksxxvmgbvn4mxi3dasbpvjnfvabvrm";
}) { } }:

with pkgs;
let
  jupyter = import (pkgs.fetchFromGitHub {
    owner = "tweag";
    repo = "jupyterWith";
    rev = "747a461d67b3d56e30c8a988a892ef611c8fe460";
    sha256 = "1kr098k1aljrqr4hwncgdzlzk3y0gmx34fqchi5lmn7v20qz2zgv";
  }) {};
  iHaskell = jupyter.kernels.iHaskellWith {
    name = "haskell";
    packages = p: with p; [ p.vinyl p.lens p.singletons p.aeson p.Frames ];
    extraIHaskellFlags = "--codemirror Haskell";
  };
  jupyterEnvironment =
    jupyter.jupyterlabWith {
      kernels = [ iHaskell ];
    };
in
jupyterEnvironment.env
