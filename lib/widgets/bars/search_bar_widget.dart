import 'package:flutter/material.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';

import '../../globals/color.dart' as color;

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({Key? key}) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  @override
  Widget build(BuildContext context) {
    return FloatingSearchBar(
      hint: 'Address, place ...',
      openAxisAlignment: 0.0,
      axisAlignment: 0.0,
      scrollPadding: EdgeInsets.only(top: 16, bottom: 20),
      elevation: 4.0,
      physics: BouncingScrollPhysics(),
      border: BorderSide(color: color.appColor(), width: 1.5),
      onQueryChanged: (query) {
        //Your methods will be here
      },
      transitionCurve: Curves.easeInOut,
      transitionDuration: Duration(milliseconds: 500),
      transition: CircularFloatingSearchBarTransition(),
      debounceDelay: Duration(milliseconds: 500),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: Icon(
              Icons.place,
              color: color.appColor(),
            ),
            onPressed: () {
              print('Places Pressed');
            },
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Material(
            color: Colors.white,
            child: Container(
              height: 200.0,
              child: Column(
                children: [
                  ListTile(
                    title: Text('Home'),
                    subtitle: Text('more info here........'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
