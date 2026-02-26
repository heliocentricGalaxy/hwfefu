import 'package:flutter/material.dart';
import 'package:hwfefu/provider/provider.dart';
import 'package:provider/provider.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  Widget itemBuilder(BuildContext context) {
    return ListView.builder(
      itemCount: context.watch<AppStateProvider>().listDataset.length,
      itemBuilder: (context, index) {
        ListItem listItem = ListItem.fromJson(
          Provider.of<AppStateProvider>(context).listDataset[index],
        );

        return Padding(
          padding: const EdgeInsets.all(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () {},
            onLongPress: () {},
            child: Container(
              height: 65,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Align(
                alignment: .centerLeft,
                child: Padding(
                  padding: const EdgeInsetsGeometry.only(left: 15),
                  child: Text(
                    "${listItem.id} | ${listItem.name}",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            ),
          ),
        );
      },
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
            context.read<AppStateProvider>().updateDatasetError(false);
            context.read<AppStateProvider>().getList(context);
          },
          label: Text("Try again"),
          icon: Icon(Icons.refresh_rounded),
        ),
      ],
    );
  }

  Widget loadingData() {
    return CircularProgressIndicator.adaptive();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: context.watch<AppStateProvider>().listDataset.isNotEmpty
            ? itemBuilder(context)
            : context.watch<AppStateProvider>().isDatasetError
            ? datasetError(context)
            : loadingData(),
      ),
    );
  }
}

class ListItem {
  late int id;
  late String name;
  late String type;
  late String dimension;
  late String created;

  ListItem.fromJson(Map json) {
    id = json["id"];
    name = json["name"];
    type = json["type"];
    dimension = json["dimension"];
    created = json["created"];
  }
}
