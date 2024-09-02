{
  stdenv,
  fetchurl,
  dpkg,
  lib,
  libz,
  autoPatchelfHook,
}:

stdenv.mkDerivation {
  pname = "cato";
  version = "0.1.0";

  src = fetchurl {
    url = "https://clientdownload.catonetworks.com/public/clients/cato-client-install.deb";
    sha256 = "sha256-0hUchaxaiKJth2ByQMFfjsCLi/4kl+SrNSQ33Y6r3WA=";
  };

  dontConfigure = true;

  nativeBuildInputs = [ autoPatchelfHook dpkg ];

  buildInputs = [ libz stdenv.cc.cc ];

  unpackPhase = ''
    runHook preUnpack
    dpkg -x $src source
    cd source
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    mkdir $out
    mv etc $out/etc

    mv usr/lib $out/lib
    mv lib/systemd $out/lib/systemd
    substituteInPlace "$out/lib/systemd/system/cato-client.service" --replace /usr/sbin/ "$out/bin/"
    cat "$out/lib/systemd/system/cato-client.service"

    mkdir -p $out/bin
    mv usr/sbin/* $out/bin
    mv usr/bin/* $out/bin

    mv ./usr/local/share $out/share
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