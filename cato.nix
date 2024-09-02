{
  stdenv,
  fetchurl,
  dpkg,
  tree,
  lib,
  libz,
  autoPatchelfHook,
}:

stdenv.mkDerivation {
  pname = "cato";
  version = "0.0.0";

  src = fetchurl {
    url = "https://clientdownload.catonetworks.com/public/clients/cato-client-install.deb";
    sha256 = "sha256-0hUchaxaiKJth2ByQMFfjsCLi/4kl+SrNSQ33Y6r3WA=";
  };

  unpackPhase = "true";

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    stdenv.cc.cc.lib
    libz

    dpkg
    tree
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    dpkg -x $src $out

    tree $out

    cp -av $out/usr/* $out

    runHook postInstall
  '';

  meta = with lib; {
    description = "Cato";
    homepage = https://www.catonetworks.com/;
    license = licenses.unfree;
    maintainers = with lib.maintainers; [ yarektyshchenko ];
    platforms = [ "x86_64-linux" ];
  };
}