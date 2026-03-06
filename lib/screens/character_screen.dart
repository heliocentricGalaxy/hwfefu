import 'package:flutter/material.dart';
import 'package:hwfefu/state_manager/state_manager.dart';
import 'package:provider/provider.dart';

class CharacterScreen extends StatelessWidget {
  const CharacterScreen({super.key});

  Widget layoutBuilder(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: ClipRRect(
              clipBehavior: .antiAlias,
              borderRadius: BorderRadiusGeometry.circular(10),
              child: Image.network(
                context.watch<StateManager>().characterItem.image,
                fit: BoxFit.cover,
                width: 150,
                errorBuilder: (context, error, stackTrace) => SizedBox(
                  width: 150,
                  height: 150,
                  child: Center(
                    child: Icon(Icons.error_outline_outlined, size: 54),
                  ),
                ),
                loadingBuilder: (context, child, loadingProgress) =>
                    loadingProgress == null
                    ? child
                    : SizedBox(
                        width: 150,
                        height: 150,
                        child: Center(
                          child: CircularProgressIndicator.adaptive(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(15.0),
          child: fieldBuilder(
            context,
            "STATUS",
            context.watch<StateManager>().characterItem.status,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15, bottom: 15, right: 15),
          child: fieldBuilder(
            context,
            "SPECIES",
            context.watch<StateManager>().characterItem.species,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15, bottom: 15, right: 15),
          child: fieldBuilder(
            context,
            "ORIGIN",
            context.watch<StateManager>().characterItem.origin,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15, bottom: 15, right: 15),
          child: fieldBuilder(
            context,
            "LOCATION",
            context.watch<StateManager>().characterItem.location,
          ),
        ),
      ],
    );
  }

  Widget fieldBuilder(
    BuildContext context,
    String fieldName,
    String fieldData,
  ) {
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
              fieldName,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          Center(
            child: Text(
              fieldData,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
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
        title: context.watch<StateManager>().characterItemStatusCode == 200
            ? Text(context.watch<StateManager>().characterItem.name)
            : null,
      ),
      body: context.watch<StateManager>().characterItemStatusCode == 200
          ? layoutBuilder(context)
          : context.watch<StateManager>().characterItemStatusCode != 0
          ? datasetError(context)
          : loadingData(),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return statusCode == 200
  //       ? ExpansionTile(
  //           initiallyExpanded: false,
  //           title: Center(child: Text(_characterItem.name)),
  //           children: [
  //             Row(
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.all(15.0),
  //                   child: Container(
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(10),
  //                     ),
  //                     child: ClipRRect(
  //                       clipBehavior: .antiAlias,
  //                       borderRadius: BorderRadiusGeometry.circular(10),
  //                       child: Image.network(
  //                         _residentItem.image,
  //                         fit: BoxFit.cover,
  //                         width: 150,
  //                         errorBuilder: (context, error, stackTrace) =>
  //                             SizedBox(
  //                               width: 150,
  //                               height: 150,
  //                               child: Center(
  //                                 child: Icon(
  //                                   Icons.error_outline_outlined,
  //                                   size: 54,
  //                                 ),
  //                               ),
  //                             ),
  //                         loadingBuilder: (context, child, loadingProgress) =>
  //                             loadingProgress == null
  //                             ? child
  //                             : SizedBox(
  //                                 width: 150,
  //                                 height: 150,
  //                                 child: Center(
  //                                   child: CircularProgressIndicator.adaptive(
  //                                     value:
  //                                         loadingProgress.expectedTotalBytes !=
  //                                             null
  //                                         ? loadingProgress
  //                                                   .cumulativeBytesLoaded /
  //                                               loadingProgress
  //                                                   .expectedTotalBytes!
  //                                         : null,
  //                                   ),
  //                                 ),
  //                               ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),

  //                 Expanded(
  //                   child: Container(
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text("Status: ${_residentItem.status}"),
  //                         Text("Species: ${_residentItem.species}"),
  //                         Text("Origin: ${_residentItem.origin}"),
  //                         Text("Location: ${_residentItem.location}"),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         )
  //       : Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: Center(child: CircularProgressIndicator.adaptive()),
  //         );
  // }
}
