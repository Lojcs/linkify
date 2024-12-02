import 'package:linkify/linkify.dart';

final _timeStampRegex = RegExp(
  r'^((?:.|\n)*?)(([0-9]?[0-9]\:)?[0-6]?[0-9]\:[0-6][0-9])',
  caseSensitive: false,
);

class TimeStampLinkifier extends Linkifier {
  const TimeStampLinkifier();

  @override
  List<LinkifyElement> parse(elements, options) {
    final list = <LinkifyElement>[];

    elements.forEach((element) {
      if (element is TextElement) {
        final match = _timeStampRegex.firstMatch(element.text!);

        if (match == null) {
          list.add(element);
        } else {
          final text = element.text!.replaceFirst(match.group(0)!, '');

          if (match.group(1)!.isNotEmpty) {
            list.add(TextElement(match.group(1)!));
          }

          if (match.group(2)!.isNotEmpty) {
            list.add(TimeStampElement(match.group(2)!));
          }

          if (text.isNotEmpty) {
            list.addAll(parse([TextElement(text)], options));
          }
        }
      } else {
        list.add(element);
      }
    });

    return list;
  }
}

/// Represents an element containing an email address
class TimeStampElement extends LinkableElement {
  final String timeStamp;

  TimeStampElement(this.timeStamp) : super(timeStamp, timeStamp);

  @override
  String toString() {
    return "TimeStampElement: '$timeStamp' ($text)";
  }

  @override
  bool operator ==(other) => equals(other);

  @override
  bool equals(other) =>
      other is TimeStampElement &&
      super.equals(other) &&
      other.timeStamp == timeStamp;
}
