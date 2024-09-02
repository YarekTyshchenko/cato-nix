{
  stdenv,
  fetchurl,
  dpkg,
  tree,
  lib,
  libz,
  autoPatchelfHook,
}:

let
  rpath = lib.makeLibraryPath [
    libz
  ] + ":${stdenv.cc.cc.lib}/lib64";

in stdenv.mkDerivation {
  pname = "cato";
  version = "0.1.0";

  src = fetchurl {
    url = "https://clientdownload.catonetworks.com/public/clients/cato-client-install.deb";
    sha256 = "sha256-0hUchaxaiKJth2ByQMFfjsCLi/4kl+SrNSQ33Y6r3WA=";
  };
  unpackPhase = "true";

  buildInputs = [
    libz
    dpkg
    tree
  ];

  installPhase = ''
    mkdir -p $out
    dpkg -x $src $out

    tree $out

    cp -av $out/usr/* $out
  '';

  postFixup = ''
  '';

  meta = with lib; {
    description = "Cato";
    homepage = https://www.catonetworks.com/;
    license = licenses.unfree;
    maintainers = with lib.maintainers; [ yarektyshchenko ];
    platforms = [ "x86_64-linux" ];
  };
}