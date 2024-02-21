import 'dart:math';
import 'package:flutter/material.dart';
import 'package:notesapp/HomePage.dart';
import 'package:notesapp/colors.dart';
import 'package:notesapp/noteView.dart';
import 'package:notesapp/sqldb.dart';

class NoteElement extends StatefulWidget {
  NoteElement({
    super.key,required this.notesMap ,
    required this.openBottomSheetCallback ,
    required this.notesList ,required this.currentView
  });
 Map notesMap ;
 List notesList ;
 final String? currentView ;
  final Function openBottomSheetCallback;//(?int)
  @override
  State<NoteElement> createState() => _NoteElementState();
}
 randomColor(){
  Random random =Random();
  return backgroundColors[random.nextInt(backgroundColors.length)] ;
}
class _NoteElementState extends State<NoteElement> {
  void navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => Home(initialView: widget.currentView),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        background:  Card(
          color: Colors.red,
          child: Icon(Icons.delete),
        ),
        key: ValueKey(widget.notesMap['id']),
        onDismissed :(direction)async{
          await SqlDb.deleteDataById(widget.notesMap['id']);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
            content: Text("Note deleted successfully") ,
            duration:  Duration(seconds: 3),
            action: SnackBarAction(
            label: "Ok",
          onPressed: (){
           navigateToHome() ;
          },
            ),)
          );
          setState(() {
            widget.notesList.removeWhere((element) => element['id'] == widget.notesMap['id']);
            getNotes(widget.notesList) ;
            // Navigator.of(context).pop();

          });

        },

          child: InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteView(notesMap: widget.notesMap),
                ),
              );
            },
              child: Card(
                elevation: 3,
                color: randomColor(),
                child:Container(
                  // padding: const EdgeInsets.only(left: 5,right: 5 ,top: 55, bottom: 55),
                  child: Center(
                    child: ListTile(
                    title: Text(widget.notesMap['title'] , style:  TextStyle(
                      fontSize: 19 ,fontWeight: FontWeight.w500 ,color: Colors.black ,fontFamily:"Merriweather"
                    ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.notesMap['note'] ,style: TextStyle(
                            fontSize: 15 ,fontWeight: FontWeight.w400 ,color: Colors.grey[800] ,fontFamily:"Merriweather"
                        ),
                        overflow: TextOverflow.ellipsis,
                        ),
                        Text("\n${widget.notesMap['createdAt']}" ,style: TextStyle(
                            fontSize: 13 ,fontWeight: FontWeight.w400 ,color: Colors.grey[600] ,fontFamily:"Merriweather"
                        ),)
                      ],
                    ),
                      trailing: InkWell(
                        onTap: (){
                          setState(() {
                            // we set id of note here not in NoteElement in Home as here onPressed Edit button , it is initialise
                            // null first in Home so it accepts null { ? }
                            widget.openBottomSheetCallback(widget.notesMap['id']);
                            });
                        }
                        ,child :  Icon(Icons.edit ,color: Colors.black),
                      ),
                    ),
                  ),
                ),
                ),
          ),

    );
  }
  getNotes(List notesList) async {
    final data =await SqlDb.getData() ;
    setState(() {
      notesList=data ;
    });
  }
}
