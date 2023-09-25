String convertTimeAgo(String createdAt) {
  // convert to DateTime
  DateTime createdAtDate = DateTime.parse(createdAt);
  // get difference
  Duration difference = DateTime.now().difference(createdAtDate);

  if (difference.inDays >= 365) {
    return '${createdAtDate.day}/${createdAtDate.month}/${createdAtDate.year}';
  } else if (difference.inDays >= 7) {
    return '${createdAtDate.day}/${createdAtDate.month}';
  } else if (difference.inDays >= 1) {
    return '${difference.inDays}d';
  } else if (difference.inHours >= 1) {
    return '${difference.inHours}h';
  } else if (difference.inMinutes >= 1) {
    return '${difference.inMinutes}m';
  } else if (difference.inSeconds >= 1) {
    return '${difference.inSeconds}s';
  } else {
    return 'Now';
  }
}
