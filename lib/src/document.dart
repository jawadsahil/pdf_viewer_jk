import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart' as FCM;
import 'package:path_provider/path_provider.dart';

import '../pdf_viewer_jk.dart';

class PDFDocument {
  static const MethodChannel _channel = const MethodChannel('pdf_viewer_jk');

  String? _filePath;
  int? count;
  List<PDFPage> _pages = [];
  bool _preloaded = false;

  /// Load a PDF File from a given File
  ///
  /// Automatically clears the on-disk cache of previously rendered PDF previews
  /// unless [clearPreviewCache] is set to `false`. The option to disable it
  /// comes in handy when working with more than one document at the same time.
  /// If you do this, you are responsible for eventually clearing the cache by hand
  /// by calling [PDFDocument.clearPreviewCache].
  static Future<PDFDocument> fromFile(File f,
      {bool clearPreviewCache = true}) async {
    PDFDocument document = PDFDocument();
    document._filePath = f.path;
    try {
      var pageCount = await _channel.invokeMethod('getNumberOfPages',
          {'filePath': f.path, 'clearCacheDir': clearPreviewCache});
      document.count = document.count = int.parse(pageCount);
    } catch (e) {
      throw Exception('Error reading PDF!');
    }
    return document;
  }

  /// Load a PDF File from a given URL.
  /// File is saved in cache
  ///
  /// Automatically clears the on-disk cache of previously rendered PDF previews
  /// unless [clearPreviewCache] is set to `false`. The option to disable it
  /// comes in handy when working with more than one document at the same time.
  /// If you do this, you are responsible for eventually clearing the cache by hand
  /// by calling [PDFDocument.clearPreviewCache].
  static Future<PDFDocument> fromURL(String url,
      {Map<String, String>? headers, clearPreviewCache = true}) async {
    // Download into cache
    File f = await FCM.DefaultCacheManager().getSingleFile(url, headers: headers);
    PDFDocument document = PDFDocument();
    document._filePath = f.path;
    try {
      var pageCount = await _channel.invokeMethod('getNumberOfPages', {'filePath': f.path, 'clearCacheDir': clearPreviewCache});
      document.count = document.count = int.parse(pageCount);
    } catch (e) {
      throw Exception('Error reading PDF!');
    }
    return document;
  }

  /// Load a PDF File from assets folder
  ///
  /// Automatically clears the on-disk cache of previously rendered PDF previews
  /// unless [clearPreviewCache] is set to `false`. The option to disable it
  /// comes in handy when working with more than one document at the same time.
  /// If you do this, you are responsible for eventually clearing the cache by hand
  /// by calling [PDFDocument.clearPreviewCache].
  static Future<PDFDocument> fromAsset(String asset,
      {clearPreviewCache = true}) async {
    // To open from assets, you can copy them to the app storage folder, and the access them "locally"
    File file;
    try {
      var dir = await getApplicationDocumentsDirectory();

      file = File("${dir.path}/file.pdf");
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }
    PDFDocument document = PDFDocument();
    document._filePath = file.path;
    try {
      var pageCount = await _channel.invokeMethod('getNumberOfPages',
          {'filePath': file.path, 'clearCacheDir': clearPreviewCache});
      document.count = document.count = int.parse(pageCount);
    } catch (e) {
      throw Exception('Error reading PDF!');
    }
    return document;
  }

  /// Clears an on-disk cache of previously rendered PDF previews.
  ///
  /// This is normally done automatically by methods such as [fromFile],
  /// [fromURL], and [fromAsset], unless they are run with the
  /// `clearPreviewCache` parameter set to `false`.
  static Future<void> clearPreviewCache() async {
    await _channel.invokeMethod('clearCacheDir');
  }

  /// Load specific page
  ///
  /// [page] defaults to `1` and must be equal or above it
  Future<PDFPage> get({
    int page = 1,
    final Function(double)? onZoomChanged,
    final int? zoomSteps,
    final double? minScale,
    final double? maxScale,
    final double? panLimit,
  }) async {
    assert(page > 0);
    if (_preloaded && _pages.isNotEmpty) return _pages[page - 1];
    var data = await _channel
        .invokeMethod('getPage', {'filePath': _filePath, 'pageNumber': page});
    return new PDFPage(
      data,
      page,
      onZoomChanged: onZoomChanged,
      zoomSteps: zoomSteps,
      minScale: minScale,
      maxScale: maxScale,
      panLimit: panLimit,
    );
  }

  Future<void> preloadPages({
    final Function(double)? onZoomChanged,
    final int? zoomSteps,
    final double? minScale,
    final double? maxScale,
    final double? panLimit,
  }) async {
    int countvar = 1;
    await Future.forEach<int>(List.filled(count!, 0), (i) async {
      final data = await _channel.invokeMethod(
          'getPage', {'filePath': _filePath, 'pageNumber': countvar});
      _pages.add(PDFPage(
        data,
        countvar,
        onZoomChanged: onZoomChanged,
        zoomSteps: zoomSteps,
        minScale: minScale,
        maxScale: maxScale,
        panLimit: panLimit,
      ));
      countvar++;
    });
    _preloaded = true;
  }

  // Stream all pages
  Stream<PDFPage?> getAll({final Function(double)? onZoomChanged}) {
    return Future.forEach<PDFPage?>(List.filled(count!, null), (i) async {
      final data = await _channel
          .invokeMethod('getPage', {'filePath': _filePath, 'pageNumber': i});
      return new PDFPage(
        data,
        1,
        onZoomChanged: onZoomChanged,
      );
    }).asStream() as Stream<PDFPage?>;
  }
}
