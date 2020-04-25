{ stdenvNoCC, lib, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  name = "birch";

  src = fetchFromGitHub {
    owner = "dylanaraps";
    repo = "birch";
    rev = "3cfdfc1a8e928ab0d3821b999aae71224e82f164";
    sha256 = "0fyk5vr9gnm114k2sl46lci0j2688ffzdlgnyxyp1jbjms1vaad6";
  };

  dontBuild = true;

  installPhase = ''
    install -Dm755 -t $out/bin birch
  '';

  meta = with lib; {
    description = "An IRC client written in bash";
    homepage = "https://github.com/dylanaraps/birch";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ luc65r ];
  };
}
