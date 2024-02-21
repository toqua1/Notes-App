import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:notesapp/HomePage.dart';
import 'package:notesapp/noteElement.dart';
import 'package:notesapp/sqldb.dart';

class customSearch extends SearchDelegate {
  final BuildContext scaffoldContext;
  String currentView;

  customSearch(this.scaffoldContext, this.currentView);

  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  List notesList = SqlDb.notesList!;

  List? filterList;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [ IconButton(
        onPressed: () {
          query = "";
        },
        icon: Icon(Icons.close))
    ];
    // TODO: implement buildActions
    throw UnimplementedError();
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back))
    ;
    // TODO: implement buildLeading
    throw UnimplementedError();
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.trim().isEmpty) {
      return Text(" ");
    } else {
      // then it is not case sensitive by this way
      filterList = notesList.where((element) =>
          element['title'].toString().toLowerCase().contains(
              query.toLowerCase())).toList();

      //************************ internal if condition *******************************

      if (filterList?.length == 0) {
        return const Center(child: Text("No notes here yet", style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w800, color: Colors.grey
        ),),);
      } else {
        return currentView != "grid" ?
        listView() : gridView();
      }

      // ************************ end of internal if condition *******************************

    }
    // TODO: implement buildSuggestions
    throw UnimplementedError();
  }
  listView(){
    return  Expanded(
      child: ListView.builder(itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17 ,vertical: 6),
          child: NoteElement(notesMap: filterList![index],
            openBottomSheetCallback:  () =>
                HomeState().openBottomSheet(filterList?[index]['id']),
            notesList: filterList! ,currentView: currentView,),
        );
      }, itemCount:  filterList!.length
      ),
    );
  }
  gridView(){
    return Expanded(
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            // crossAxisSpacing: 2,
            // mainAxisSpacing: 2
          ),
          itemBuilder: ( context , index){
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: NoteElement(notesMap: filterList![index],
                  openBottomSheetCallback:  () =>
                      HomeState().openBottomSheet(filterList?[index]['id']),
                  notesList: filterList!  ,currentView: currentView
              ),
            );
          }, itemCount:  filterList!.length
      ),
    ) ;
  }


}
