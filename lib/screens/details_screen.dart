import 'package:flutter/material.dart';
import 'package:hwfefu/screens/list_screen.dart';
import 'package:hwfefu/screens/residents_page.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key, required this.listItem});
  final ListItem listItem;

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
              listItem.type,
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
              listItem.dimension,
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
                listItem.residents.length,
                (index) =>
                    ResidentsPage(residentEndpoint: listItem.residents[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(listItem.name)),
      body: ListView(
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
          listItem.residents.isNotEmpty
              ? residentsBuilder(context)
              : SizedBox(),
        ],
      ),
    );
  }
}
