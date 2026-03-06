import 'package:flutter/material.dart';
import 'package:hwfefu/data_types/data_types.dart';
import 'package:hwfefu/screens/details_screen.dart';
import 'package:hwfefu/state_manager/state_manager.dart';
import 'package:provider/provider.dart';

class FavsScreen extends StatelessWidget {
  const FavsScreen({super.key});

  Widget itemBuilder(BuildContext context) {
    return ListView.builder(
      itemCount: context.watch<StateManager>().favsItemList.length,
      itemBuilder: (context, index) {
        LocationItem listItem = context
            .read<StateManager>()
            .favsItemList[index];
        return Padding(
          padding: EdgeInsets.only(
            top: 15,
            left: 15,
            right: 15,
            bottom:
                index == context.read<StateManager>().favsItemList.length - 1
                ? 15
                : 0,
          ),
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
              child: Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Align(
                    alignment: .centerLeft,
                    child: Padding(
                      padding: const EdgeInsetsGeometry.only(left: 15),
                      child: Text(
                        "${listItem.id} | ${listItem.name}",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 25),
                    child: IconButton.outlined(
                      onPressed: () {
                        context.read<StateManager>().removeFav(listItem.id);
                      },
                      icon: Icon(Icons.delete_forever_outlined),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget noFavsAdded(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: .center,
        children: [
          Icon(Icons.favorite, size: 54),
          Text("Add items to Favorites to see them here"),
        ],
      ),
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
        child: !context.watch<StateManager>().isFavsLoading
            ? context.watch<StateManager>().favsItemList.isNotEmpty
                  ? itemBuilder(context)
                  : noFavsAdded(context)
            : loadingData(),
      ),
    );
  }
}
