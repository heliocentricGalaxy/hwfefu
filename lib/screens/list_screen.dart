import 'package:flutter/material.dart';
import 'package:hwfefu/data_types/data_types.dart';
import 'package:hwfefu/screens/details_screen.dart';
import 'package:hwfefu/state_manager/state_manager.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  Widget itemBuilder(BuildContext context) {
    return ListView.builder(
      itemCount: context.watch<StateManager>().itemList.length,
      itemBuilder: (context, index) {
        LocationItem listItem = context.read<StateManager>().itemList[index];
        return Padding(
          padding: EdgeInsets.only(
            top: 15,
            left: 15,
            right: 15,
            bottom: index == context.read<StateManager>().itemList.length - 1
                ? 15
                : 0,
          ),
          child: GestureDetector(
            onLongPressStart: (details) {
              final RenderObject overlay = Overlay.of(
                context,
              ).context.findRenderObject()!;
              showMenu(
                context: context,
                position: RelativeRect.fromRect(
                  Rect.fromLTWH(
                    details.globalPosition.dx,
                    details.globalPosition.dy,
                    30,
                    30,
                  ),
                  Rect.fromLTWH(
                    0,
                    0,
                    overlay.paintBounds.size.width,
                    overlay.paintBounds.size.height,
                  ),
                ),
                items: [
                  PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(Icons.favorite),
                        SizedBox(width: 16),
                        Text('Add to Favorites'),
                      ],
                    ),
                    onTap: () {
                      context.read<StateManager>().addFav(
                        listItem.id,
                        listItem.name,
                      );
                    },
                  ),
                  PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(Icons.share),
                        SizedBox(width: 16),
                        Text('Share'),
                      ],
                    ),
                    onTap: () {
                      SharePlus.instance.share(
                        ShareParams(
                          uri: Uri.parse(
                            "https://rickandmortyapi.com/api/location/${listItem.id}",
                          ),
                        ),
                      );
                    },
                  ),
                  PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(Icons.info_outline),
                        SizedBox(width: 16),
                        Text('Open Details'),
                      ],
                    ),
                    onTap: () {
                      context.read<StateManager>().getLocationDetails(
                        listItem.id,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                context.read<StateManager>().getLocationDetails(listItem.id);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DetailsScreen()),
                );
              },

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
            context.read<StateManager>().getLocationList();
          },
          label: Text("Try again"),
          icon: Icon(Icons.refresh_rounded),
        ),
      ],
    );
  }

  Widget loadingData() {
    return Center(child: CircularProgressIndicator.adaptive());
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: context.watch<StateManager>().itemListStatusCode == 200
            ? itemBuilder(context)
            : context.watch<StateManager>().itemListStatusCode != 0
            ? datasetError(context)
            : loadingData(),
      ),
    );
  }
}
