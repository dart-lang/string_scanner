import 'charcode.dart';
import 'line_scanner.dart';
import 'string_scanner.dart';

final _newlineRegExp = RegExp(r'\r\n?|\n');

mixin MultilineMixin on StringScanner {
  /// The scanner's current (zero-based) line number.
  int get line => _line;
  int _line = 0;

  /// The scanner's current (zero-based) column number.
  int get column => _column;
  int _column = 0;

  bool get _betweenCRLF => peekChar(-1) == $cr && peekChar() == $lf;

  @override
  set position(int newPosition) {
    final oldPosition = position;
    super.position = newPosition;

    if (newPosition > oldPosition) {
      final newlines = _newlinesIn(string.substring(oldPosition, newPosition));
      _line += newlines.length;
      if (newlines.isEmpty) {
        _column += newPosition - oldPosition;
      } else {
        _column = newPosition - newlines.last.end;
      }
    } else {
      final newlines = _newlinesIn(string.substring(newPosition, oldPosition));
      if (_betweenCRLF) newlines.removeLast();

      _line -= newlines.length;
      if (newlines.isEmpty) {
        _column -= oldPosition - newPosition;
      } else {
        _column =
            newPosition - string.lastIndexOf(_newlineRegExp, newPosition) - 1;
      }
    }
  }

  @override
  bool scanChar(int character) {
    if (!super.scanChar(character)) return false;
    _adjustLineAndColumn(character);
    return true;
  }

  @override
  int readChar() {
    final character = super.readChar();
    _adjustLineAndColumn(character);
    return character;
  }

  /// Adjusts [_line] and [_column] after having consumed [character].
  void _adjustLineAndColumn(int character) {
    if (character == $lf || (character == $cr && peekChar() != $lf)) {
      _line += 1;
      _column = 0;
    } else {
      _column += 1;
    }
  }

  @override
  bool scan(Pattern pattern) {
    if (!super.scan(pattern)) return false;
    final firstMatch = (lastMatch![0])!;

    final newlines = _newlinesIn(firstMatch);
    _line += newlines.length;
    if (newlines.isEmpty) {
      _column += firstMatch.length;
    } else {
      _column = firstMatch.length - newlines.last.end;
    }

    return true;
  }

  /// Returns a list of [Match]es describing all the newlines in [text], which
  /// is assumed to end at [position].
  List<Match> _newlinesIn(String text) {
    final newlines = _newlineRegExp.allMatches(text).toList();
    if (_betweenCRLF) newlines.removeLast();
    return newlines;
  }

  set state(LineScannerState state) {
    if (!isClassState(state)) {
      throw ArgumentError('The given LineScannerState was not returned by '
          'this LineScanner.');
    }

    super.position = state.position;
    _line = state.line;
    _column = state.column;
  }

  bool isClassState(LineScannerState state);
}
