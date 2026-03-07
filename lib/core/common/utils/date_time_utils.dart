/// A utility function to format a duration in seconds
/// into a human-readable string.
///
/// The format changes based on whether the duration is longer than a minute.
/// - If 60 seconds or more, it formats as `mm:ss min` (e.g., "01:30 min").
/// - If less than 60 seconds, it formats as `mm:ss s` (e.g., "00:45 s").
///
/// [seconds] The total duration in seconds.
String formatDuration(int seconds) {
  // Create a Duration object from the total seconds.
  final duration = Duration(seconds: seconds);

  // Extract minutes and the remaining seconds.
  // inMinutes gives the total minutes, ignoring remaining seconds.
  final minutes = duration.inMinutes;
  // inSeconds gives total seconds.
  // We use the modulo operator to get the remainder.
  final remainingSeconds = seconds % 60;

  // Zero-pad the minutes and seconds to
  // always have two digits (e.g., 9 -> "09").
  final minutesStr = minutes.toString().padLeft(2, '0');
  final secondsStr = remainingSeconds.toString().padLeft(2, '0');

  // Determine the suffix based on whether the total
  // duration is a minute or more.
  final suffix = minutes > 0 ? 'min' : 's';

  return '$minutesStr:$secondsStr$suffix';
}

String getMonthName(int month) {
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  if (month < 1 || month > 12) return '';
  return months[month - 1];
}

String getTimeAgo(DateTime? dateTime) {
  if (dateTime == null) return '';
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inDays >= 365) {
    final years = (difference.inDays / 365).floor();
    return '$years ${years == 1 ? 'year' : 'years'} ago';
  } else if (difference.inDays >= 30) {
    final months = (difference.inDays / 30).floor();
    return '$months ${months == 1 ? 'month' : 'months'} ago';
  } else if (difference.inDays >= 7) {
    final weeks = (difference.inDays / 7).floor();
    return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
  } else if (difference.inDays > 0) {
    return '''${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago''';
  } else if (difference.inHours > 0) {
    return '''${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago''';
  } else if (difference.inMinutes > 0) {
    return '''${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago''';
  } else {
    return 'just now';
  }
}

String getMonthNameDateYear(DateTime? dateTime) {
  if (dateTime == null) {
    return '';
  }
  return '''${getMonthName(dateTime.month)} ${dateTime.day}, ${dateTime.year}''';
}
