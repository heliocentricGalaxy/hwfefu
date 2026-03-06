import 'package:flutter/material.dart';
import 'package:hwfefu/screens/character_screen.dart';
import 'package:hwfefu/state_manager/state_manager.dart';
import 'package:provider/provider.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  Widget typeBuilder(BuildContext context) {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Padding(
            padding: const EdgeInsetsGeometry.only(left: 15, top: 10),
            child: Text("TYPE", style: Theme.of(context).textTheme.labelLarge),
          ),
          Center(
            child: Text(
              context.watch<StateManager>().locationItem.type,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }

  Widget dimensionBuilder(BuildContext context) {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Padding(
            padding: const EdgeInsetsGeometry.only(left: 15, top: 10),
            child: Text(
              "DIMENSION",
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          Center(
            child: Text(
              context.watch<StateManager>().locationItem.dimension,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }

  Widget residentsBuilder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Padding(
              padding: const EdgeInsetsGeometry.only(left: 15, top: 10),
              child: Text(
                "RESIDENTS",
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            Column(
              children: List.generate(
                context.watch<StateManager>().locationItem.residents.length,
                (index) => Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 8,
                      right: 8,
                      top: 8,
                      bottom:
                          index ==
                              context
                                      .watch<StateManager>()
                                      .locationItem
                                      .residents
                                      .length -
                                  1
                          ? 8
                          : 0,
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: FilledButton.tonal(
                        onPressed: () {
                          context.read<StateManager>().getCharacterDetails(
                            int.parse(
                              context
                                  .read<StateManager>()
                                  .locationItem
                                  .residents[index]
                                  .split("/")
                                  .last,
                            ),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CharacterScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Resident: ${context.watch<StateManager>().locationItem.residents[index].split("/").last}",
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget layoutBuilder(BuildContext context) {
    return ListView(
      children: [
        Center(child: Icon(Icons.public_rounded, size: 256)),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: typeBuilder(context),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15, bottom: 15, right: 15),
          child: dimensionBuilder(context),
        ),
        context.watch<StateManager>().locationItem.residents.isNotEmpty
            ? residentsBuilder(context)
            : SizedBox(),
      ],
    );
  }

  Widget datasetError(BuildContext context) {
    return Column(
      mainAxisAlignment: .center,
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            "Error loading data from\nRick and Morty API",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        FilledButton.icon(
          onPressed: () {
            Navigator.of(context).pop();
          },
          label: Text("Back"),
          icon: Icon(Icons.arrow_back),
        ),
      ],
    );
  }

  Widget loadingData() {
    return Center(child: CircularProgressIndicator.adaptive());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: context.watch<StateManager>().locationItemStatusCode == 200
            ? Text(context.watch<StateManager>().locationItem.name)
            : null,
      ),
      body: context.watch<StateManager>().locationItemStatusCode == 200
          ? layoutBuilder(context)
          : context.watch<StateManager>().locationItemStatusCode != 0
          ? datasetError(context)
          : loadingData(),
    );
  }
}
