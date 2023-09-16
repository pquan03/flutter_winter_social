String convertTimeAgo(String createdAt) {
  // convert to DateTime
  DateTime createdAtDate = DateTime.parse(createdAt);
  // get difference
  Duration difference = DateTime.now().difference(createdAtDate);

  if (difference.inDays >= 10) {
    return '${createdAtDate.day}/${createdAtDate.month}/${createdAtDate.year}';
  } else if (difference.inDays >= 7) {
    return '1 week ago';
  } else if (difference.inDays >= 1) {
    return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
  } else if (difference.inHours >= 1) {
    return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
  } else if (difference.inMinutes >= 1) {
    return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
  } else if (difference.inSeconds >= 1) {
    return '${difference.inSeconds} second${difference.inSeconds > 1 ? 's' : ''} ago';
  } else {
    return 'Just now';
  }
}
