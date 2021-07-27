{ llvmPackages
, lib
, fetchFromGitHub
, cmake
}:

llvmPackages.stdenv.mkDerivation {
  pname = "c2c";
  version = "unstable-2021-03-22";

  src = fetchFromGitHub {
    owner = "c2lang";
    repo = "c2compiler";
    rev = "d6a028121728acdaa45dbf0275ec2b31cb00cbd8";
    sha256 = "1ZrYhee2l925b5dwFk6uHBvzk0oQmd5owyScXuOP9ls=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    llvmPackages.llvm
  ];

  cmakeFlags = [
    "-DDESTDIR=${placeholder "out"}/bin"
  ];

  meta = with lib; {
    description = "Compiler for the C2 language";
    homepage = "http://c2lang.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ luc65r ];
    platforms = platforms.all;
  };
}
