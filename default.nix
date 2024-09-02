let
  # Import sources
  sources = import ./nix/sources.nix;

# And return that specific nixpkgs
in sources.nixpkgs

