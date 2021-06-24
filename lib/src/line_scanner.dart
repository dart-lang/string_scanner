// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'multiline_mixin.dart';
import 'string_scanner.dart';

// Note that much of this code is duplicated in eager_span_scanner.dart.

/// A subclass of [StringScanner] that tracks line and column information.
class LineScanner extends StringScanner with MultilineMixin {
  /// The scanner's state, including line and column information.
  ///
  /// This can be used to efficiently save and restore the state of the scanner
  /// when backtracking. A given [LineScannerState] is only valid for the
  /// [LineScanner] that created it.
  ///
  /// This does not include the scanner's match information.
  LineScannerState get state =>
      LineScannerState._(this, position, line, column);

  @override
  bool isClassState(LineScannerState state) => identical(state._scanner, this);

  LineScanner(String string, {sourceUrl, int? position})
      : super(string, sourceUrl: sourceUrl, position: position);
}

/// A class representing the state of a [LineScanner].
class LineScannerState {
  /// The [LineScanner] that created this.
  final LineScanner _scanner;

  /// The position of the scanner in this state.
  final int position;

  /// The zero-based line number of the scanner in this state.
  final int line;

  /// The zero-based column number of the scanner in this state.
  final int column;

  LineScannerState._(this._scanner, this.position, this.line, this.column);
}
