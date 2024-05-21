import 'package:flutter/material.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(tabs: [
              Tab(
                icon: Icon(Icons.warning_amber_rounded),
              ),
              Tab(
                icon: Icon(Icons.done_outline_rounded),
              )
            ]),
          ),
          body: const TabBarView(children: [
            Center(
              child: Text('Si lo acabo'),
            ),
            Center(
              child: Text('Si puedo'),
            ),
          ])),
    );
  }
}
