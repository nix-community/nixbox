with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "nixbox-shell";
  buildInputs = [
    gnumake
    packer
    ruby
    vagrant
  ];
}
