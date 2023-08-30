import 'package:flutter/material.dart';

class CardLoadingShimmerNotifiWidget extends StatefulWidget {
  const CardLoadingShimmerNotifiWidget({super.key});

  @override
  State<CardLoadingShimmerNotifiWidget> createState() =>
      _CardLoadingShimmerNotifiWidgetState();
}

class _CardLoadingShimmerNotifiWidgetState
    extends State<CardLoadingShimmerNotifiWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width * 0.5,
                  height: 25,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  width: MediaQuery.sizeOf(context).width * 0.35,
                  height: 18,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.grey,
              ))
        ],
      ),
    );
  }
}
