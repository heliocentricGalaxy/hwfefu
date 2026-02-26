import 'package:flutter/material.dart';
import 'package:hwfefu/provider/provider.dart';
import 'package:hwfefu/screens/list_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(lazy: false, create: (_) => AppStateProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'hwfefu',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.blue)),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    context.read<AppStateProvider>().getList(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Rick and Morty API Fetcher"),),
      body: ListPage());
  }
}
