with import <nixpkgs> {};
stdenv.mkDerivation {
  name = "github-page-using-jekyll";
  buildInputs = [ jekyll ];
}
