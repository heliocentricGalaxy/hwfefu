import 'package:flutter/material.dart';
import 'package:hwfefu/api_service/api_service.dart';

import 'package:hwfefu/repo_service/repo_service.dart';
import 'package:hwfefu/screens/favorite_screen.dart';
import 'package:hwfefu/screens/list_screen.dart';
import 'package:hwfefu/state_manager/state_manager.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<ApiService>(create: (_) => ApiService()),
        ProxyProvider<ApiService, AppRepo>(
          update: (_, apiService, _) => AppRepo(apiService),
        ),
        ChangeNotifierProxyProvider<AppRepo, StateManager>(
          create: (_) => StateManager(AppRepo(ApiService())),
          update: (_, repo, vm) => StateManager(repo),
        ),
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
    context.read<StateManager>().getLocationList();
    context.read<StateManager>().initFavs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Rick and Morty API Fetcher")),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: context.watch<StateManager>().navBarState,
        onTap: (value) {
          if (value == 0) {
            context.read<StateManager>().getLocationList();
          } else {
            context.read<StateManager>().getFavs();
          }
          context.read<StateManager>().updateNavBarState(value);
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'List'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
        ],
      ),
      body: context.watch<StateManager>().navBarState == 0
          ? ListScreen()
          : FavsScreen(),
    );
  }
}
