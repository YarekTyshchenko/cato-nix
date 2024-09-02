{
  pkgs ? import <nixpkgs> {}
}:

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    (callPackage ./default.nix {})
  ];
}