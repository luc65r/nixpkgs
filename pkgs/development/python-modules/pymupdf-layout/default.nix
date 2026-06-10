{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  python,
  runCommand,

  # dependencies
  pymupdf,
  pyyaml,
  numpy,
  onnxruntime,
  networkx,
}:

buildPythonPackage rec {
  pname = "pymupdf-layout";
  version = "1.27.2.3";
  format = "wheel";

  disabled = pythonOlder "3.9";

  src =
    let
      platforms = {
        aarch64-darwin = {
          platform = "macosx_11_0_arm64";
          hash = lib.fakeHash;
        };
        x86_64-darwin = {
          platform = "macosx_10_9_x86_64";
          hash = lib.fakeHash;
        };
        aarch64-linux = {
          platform = "manylinux_2_28_aarch64";
          hash = lib.fakeHash;
        };
        x86_64-linux = {
          platform = "manylinux_2_28_x86_64";
          hash = "sha256-MDuUFCFt+vcR7H2Ae28eTD4Kkru0VpNA/O3Z1Vk9Fso=";
        };
      };
      info =
        platforms.${stdenv.hostPlatform.system}
          or (throw "pymupdf-layout: Unsupported system: ${stdenv.hostPlatform.system}");
    in
    fetchPypi {
      pname = "pymupdf_layout";
      inherit version format;
      inherit (info) platform hash;
      python = "cp310";
      abi = "abi3";
      dist = "cp310";
    };

  # curl https://pypi.org/pypi/pymupdf-layout/json | jq .info.requires_dist
  dependencies = [
    pymupdf
    pyyaml
    numpy
    onnxruntime
    networkx
  ];

  doCheck = false;

  # pythonImportsCheck doesn't work because pymupdf is not an Implicit Namespace Package (PEP 420).
  # pythonImportsCheck = [ "pymupdf.layout" ];
  # Use passthru.tests to verify imports in a merged environment.
  passthru.tests.import =
    runCommand "pymupdf-layout-import-test"
      {
        nativeBuildInputs = [ (python.withPackages (ps: [ ps.pymupdf-layout ])) ];
      }
      ''
        python -c "import pymupdf.layout; print('pymupdf.layout imported successfully')"
        touch $out
      '';

  meta = {
    description = "Lightweight layout analysis extension for PyMuPDF";
    homepage = "https://pypi.org/project/pymupdf-layout/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ ryota2357 ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}
