{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pipcl,
  setuptools,
  pymupdf,
  pymupdf-layout,
  tabulate,

  withPymupdfLayout ? true,
}:

buildPythonPackage (finalAttrs: {
  pname = "pymupdf4llm";
  version = "1.27.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pymupdf";
    repo = "pymupdf4llm";
    tag = finalAttrs.version;
    hash = "sha256-HpIo9Jwi3M6IHqT/PC+tdi+YSsyevF+INbv0Utjb9sQ=";
  };

  build-system = [
    pipcl
    setuptools
  ];

  dependencies = [
    pymupdf
    tabulate
  ] ++ lib.optional withPymupdfLayout pymupdf-layout;

  postPatch = ''
    sed -i "1i from pathlib import Path" setup.py
    substituteInPlace setup.py \
      --replace-fail "pipcl.git_items('src')" "map(lambda p: p.relative_to('src'), Path('src').rglob('*.py'))"
  '' + lib.optionalString (!withPymupdfLayout) ''
    sed -i "/pymupdf_layout/d" setup.py
  '';

  checkPhase = ''
    runHook preCheck

    python3 - <<'EOF'
    import fitz
    import pymupdf4llm

    doc = fitz.open()
    page = doc.new_page()
    page.insert_text((72, 72), "Hello, Nix!")
    doc.save("input.pdf")

    md = pymupdf4llm.to_markdown("input.pdf")
    assert isinstance(md, str), "Returned value is not a string"
    assert "Hello, Nix!" in md, "Returned value does not contain the expected text"
    EOF

    runHook postCheck
  '';

  pythonImportsCheck = [ "pymupdf4llm" ];

  meta = {
    description = "PyMuPDF Utilities for LLM/RAG - converts PDF pages to Markdown format for Retrieval-Augmented Generation";
    homepage = "https://github.com/pymupdf/pymupdf4llm";
    changelog = "https://github.com/pymupdf/pymupdf4llm/blob/${finalAttrs.src.tag}/CHANGES.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ ryota2357 ];
  };
})
