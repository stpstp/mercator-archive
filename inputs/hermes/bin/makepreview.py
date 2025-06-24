from gavo.helpers import processing

class PreviewMaker(processing.SpectralPreviewMaker):
  sdmId = "build_spectrum"

if __name__=="__main__":
  processing.procmain(PreviewMaker, "hermes/q", "import")
