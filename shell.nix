with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "nixbox-shell";
  buildInputs = [
    packer
    ruby
  ];
}
