/// A utility function to format a duration in seconds into a human-readable string.
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
  // inSeconds gives total seconds. We use the modulo operator to get the remainder.
  final remainingSeconds = seconds % 60;

  // Zero-pad the minutes and seconds to always have two digits (e.g., 9 -> "09").
  final minutesStr = minutes.toString().padLeft(2, '0');
  final secondsStr = remainingSeconds.toString().padLeft(2, '0');

  // Determine the suffix based on whether the total duration is a minute or more.
  final suffix = minutes > 0 ? 'min' : 's';

  return '$minutesStr:$secondsStr$suffix';
}
