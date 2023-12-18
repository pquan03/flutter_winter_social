import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class THelperFunctions {
  static Color? getColor(String value) {
    /// Define your product specific colors here and it will match the attribute colors and show specific 🟠🟡🟢🔵🟣🟤

    if (value == 'Green') {
      return Colors.green;
    } else if (value == 'Green') {
      return Colors.green;
    } else if (value == 'Red') {
      return Colors.red;
    } else if (value == 'Blue') {
      return Colors.blue;
    } else if (value == 'Pink') {
      return Colors.pink;
    } else if (value == 'Grey') {
      return Colors.grey;
    } else if (value == 'Purple') {
      return Colors.purple;
    } else if (value == 'Black') {
      return Colors.black;
    } else if (value == 'White') {
      return Colors.white;
    } else if (value == 'Yellow') {
      return Colors.yellow;
    } else if (value == 'Orange') {
      return Colors.deepOrange;
    } else if (value == 'Brown') {
      return Colors.brown;
    } else if (value == 'Teal') {
      return Colors.teal;
    } else if (value == 'Indigo') {
      return Colors.indigo;
    } else {
      return null;
    }
  }

  static void navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength)}...';
    }
  }

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static List<T> removeDuplicates<T>(List<T> list) {
    return list.toSet().toList();
  }

  static List<Widget> wrapWidgets(List<Widget> widgets, int rowSize) {
    final wrappedList = <Widget>[];
    for (var i = 0; i < widgets.length; i += rowSize) {
      final rowChildren = widgets.sublist(
          i, i + rowSize > widgets.length ? widgets.length : i + rowSize);
      wrappedList.add(Row(children: rowChildren));
    }
    return wrappedList;
  }

  static String convertDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  static String convertTimeAgo(String createdAt) {
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

  static String convertTimeAgoNotifiCustom(String createdAt) {
    // convert to DateTime
    DateTime createdAtDate = DateTime.parse(createdAt);
    // get difference
    Duration difference = DateTime.now().difference(createdAtDate);

    if (difference.inDays >= 7) {
      return '${difference.inDays ~/ 7} ${difference.inDays ~/ 7 > 1 ? 'weeks' : 'week'} ago';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays} ${difference.inDays > 1 ? 'days' : 'day'} ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} ${difference.inHours > 1 ? 'hours' : 'hour'} ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} ${difference.inMinutes > 1 ? 'minutes' : 'minute'} ago';
    } else if (difference.inSeconds >= 1) {
      return '${difference.inSeconds} ${difference.inSeconds > 1 ? 'seconds' : 'second'} ago';
    } else {
      return 'Just now';
    }
  }


  static String replaceMp4ToPng(String str) {
    return str.replaceAll('.mp4', '.png');
  }

  static Future<Uint8List> convertAssetEntityToUint8List(
      AssetEntity assetEntity) async {
    final file = await assetEntity.originFile;
    final bytes = await file!.readAsBytes();
    return bytes;
  }
}


  showSnackBar(BuildContext context, String label, String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        showCloseIcon: true,
        backgroundColor: label == 'Error' ? Colors.red : Colors.green,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              content,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }