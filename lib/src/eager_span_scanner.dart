// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'line_scanner.dart';
import 'multiline_mixin.dart';
import 'span_scanner.dart';

/// A [SpanScanner] that tracks the line and column eagerly, like [LineScanner].
class EagerSpanScanner extends SpanScanner with MultilineMixin {
  @override
  LineScannerState get state =>
      _EagerSpanScannerState(this, position, line, column);

  @override
  bool isClassState(LineScannerState state) =>
      state is _EagerSpanScannerState && identical(state._scanner, this);

  EagerSpanScanner(String string, {sourceUrl, int? position})
      : super(string, sourceUrl: sourceUrl, position: position);
}

/// A class representing the state of an [EagerSpanScanner].
class _EagerSpanScannerState implements LineScannerState {
  final EagerSpanScanner _scanner;
  @override
  final int position;
  @override
  final int line;
  @override
  final int column;

  _EagerSpanScannerState(this._scanner, this.position, this.line, this.column);
}
