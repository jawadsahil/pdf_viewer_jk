# pdf_viewer_jk
A flutter plugin for viewing PDF files in mobile app (Android & iOS).
based on https://github.com/CrossPT/flutter_plugin_pdf_viewer
Also, upgrades made by Damodar Lohani - https://github.com/CrossPT/flutter_plugin_pdf_viewer/pull/63 are added.


## Installation

Add  *pdf_viewer_jk*  as a dependency in [your pubspec.yaml file](https://flutter.io/platform-plugins/).
```
pdf_viewer_jk: any
```

---

## Android
No permissions required. Uses application cache directory.

## iOS
No permissions required.

## How-to:

#### Load PDF
```
// Load from assets
PDFDocument doc = await PDFDocument.fromAsset('assets/test.pdf');

// Load from URL
PDFDocument doc = await PDFDocument.fromURL('http://www.africau.edu/images/default/sample.pdf');

// Load from file
File file  = File('...');
PDFDocument doc = await PDFDocument.fromFile(file);
```

#### Load pages
```
// Load specific page
PDFPage pageOne = await doc.get(page: _number);
```

#### Pre-built viewer
Use the pre-built PDF Viewer
```
@override
  Widget build(BuildContext context) {
    Scaffold(
        appBar: AppBar(
          title: Text('Example'),
        ),
        body: Center(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : PDFViewer(document: document)),
    );
  }
```