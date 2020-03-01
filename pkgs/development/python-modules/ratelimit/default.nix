{ stdenv
, fetchPypi
, buildPythonPackage
}:

buildPythonPackage rec {
  pname = "ratelimit";
  version = "2.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "af8a9b64b821529aca09ebaf6d8d279100d766f19e90b5059ac6a718ca6dee42";
  };

  meta = with stdenv.lib; {
    description = "Pure-Python AES";
    license = licenses.mit;
    homepage = "https://github.com/tomasbasham/ratelimit";
    maintainers = with maintainers; [ luc65r ];
  };
}
