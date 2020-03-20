import 'package:flutter/material.dart';
import 'package:pdf_viewer_jk/pdf_viewer_jk.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = true;
  PDFDocument document;
  String title="Loading";

  @override
  void initState() {
    super.initState();
    loadDocument(0);
  }


  loadDocument(value) async {
    setState(() {
      _isLoading = true;
      title = "Loading";
    });
    if (value == 1) {
      document = await PDFDocument.fromURL(
          "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf");
    } else {
      document = await PDFDocument.fromAsset('assets/sample.pdf');
    }
    setState(() {
      title = (value == 1)?"Loaded From Url":"Loaded From Assets";
       _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              SizedBox(height: 36),
              ListTile(
                title: Text('Load from URL'),
                onTap: () {
                  loadDocument(1);
                },
              ),
              ListTile(
                title: Text('Load from Assets'),
                onTap: () {
                  loadDocument(0);
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : PDFViewer(document: document)),
      ),
    );
  }
}

