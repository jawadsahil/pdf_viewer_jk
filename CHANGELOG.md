# Changelog

## [1.1.0]

- Custom navigation color
- Exposing `ZoomableWidget` from [flutter_advanced_networkimage](https://pub.dartlang.org/packages/flutter_advanced_networkimage) parameters (minScale, zoomSteps, maxScale,panLimit)
- Page controller initial page setting fixed (making able to set initially loaded page)
- Proper android cache cleanup
- Option to pass in controller `PDFViewer(document: document,controller: PageController())` that you can use to control the pageview rendering the PDF pages.
- Option to preload all pages in memory `PDFViewer(document: document,lazyLoad: false)`
- Option to disable swipe navigation `PDFViewer(document: document,scrollDirection: Aixs.vertical)`
- Option to change scroll axis to vertical or horizontal `PDFViewer(document: document,scrollDirection: Aixs.vertical)`
- Removed rxdart dependency
- Upgraded to androidX
- Added support to optional header while loading document from url
- Auto hide picker for 1 page documents
- Swipe control
- Zoom scale up to 5.0

## [1.0.1]

- updated dependencies

## [1.0.0]

- version number as stable.
- added example

## [0.0.4]

- fixed issue -- ios header files missing.

## [0.0.3]

- fixed issue -- No podspec found.

## [0.0.2]

- fixed few missing code parts.

## [0.0.1]

- initial release.
