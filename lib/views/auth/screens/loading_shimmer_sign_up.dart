import 'package:flutter/material.dart';
import 'package:insta_node_app/common_widgets/loading_shimmer.dart';

class LoadingSignUp extends StatefulWidget {
  const LoadingSignUp({super.key});

  @override
  State<LoadingSignUp> createState() => _LoadingSignUpState();
}

class _LoadingSignUpState extends State<LoadingSignUp> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          centerTitle: false,
          title: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        body: LoadingShimmer(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width * 0.7,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Container(
                  width: MediaQuery.sizeOf(context).width * 0.8,
                  height: 15,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  width: MediaQuery.sizeOf(context).width * 0.8,
                  height: 15,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  width: MediaQuery.sizeOf(context).width * 0.6,
                  height: 15,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                  Container(
                  width: double.infinity,
                  height: 45,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: LoadingShimmer(
          child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
        ),
      ),
    );
  }
}
