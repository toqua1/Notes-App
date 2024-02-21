import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:notesapp/main.dart';
import 'package:notesapp/noteElement.dart';
import 'package:notesapp/sqldb.dart';
import 'customSearch.dart';

class Home extends StatefulWidget {
  final String? initialView ;
   Home({super.key ,this.initialView});
  @override
  State<Home> createState() => HomeState(currentView: initialView);
}
class HomeState extends State<Home> {
  String? currentView ;
  HomeState({this.currentView}) ;
  void initState(){
    super.initState() ;
    // Use initialView from the widget if provided, otherwise default to "list"
    currentView =widget.initialView ?? "list" ;
  }
 String createdAt="" ;
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
 List notesList=[] ;
  GlobalKey<ScaffoldState>scaffoldKey =GlobalKey<ScaffoldState>() ;
  bool status =MyApp.themeNotifier.value==ThemeMode.dark?false :true ;
  String mess ='' ;
  String img ='' ;
  Color? colorr ;
  IconData? iconn;
  Color? colorFloating ;
  Color? colorFloatingFore ;
  Color? shadowColor ;
  Color? colorIconFore ;

  void changeTitle() {
    setState(() {
      status =MyApp.themeNotifier.value==ThemeMode.dark?false :true ;
      if (status==false) {
        mess = "Dark";
        img ="assests/darkMode/dark2.jpg" ;
        colorr=Colors.blue[900]  ;
        iconn=Icons.dark_mode  ;
        colorFloating=Colors.black;
        colorFloatingFore=Colors.white;
        shadowColor =Colors.grey.shade800.withOpacity(.8) ;
        colorIconFore =Colors.white70;
      } else {
        mess = "Light";
        img="assests/lightMode/light4.jpg" ;
        colorr=Colors.orangeAccent ;
        iconn =Icons.brightness_5  ;
        colorFloating=Colors.white ;
        colorFloatingFore=Colors.black;
        shadowColor =Colors.grey.shade300.withOpacity(.8) ;
        colorIconFore =Colors.black54;
      }
    });
  }

  void bottomSheet(int? id) async {
    if(id != null){
      final existingData =
          notesList.firstWhere((element) => element['id']==id);
          titleController.text=existingData['title'] ;
          noteController.text=existingData['note'] ;
    }
    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          top: 30,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 50,
        ),
        child: Column(
          /*to make it in the end*/
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: noteController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Note',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: ElevatedButton(
                onPressed: ()async {
                  if(id==null) {
                    await saveNotes();
                  }else{
                    await updateNotes(id) ;
                  }
                  titleController.clear() ;
                  noteController.clear() ;
                  Navigator.pop(context) ;
                },
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Text(
                   id==null ? "Add" : "Edit",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
   void openBottomSheet(int? id) {//id may be null
    bottomSheet(id);
  }

  @override
  Widget build(BuildContext context) {
    changeTitle();
    notesList=SqlDb.notesList! ;
    return RefreshIndicator(
      onRefresh: () async{//if we put getNotes only ,it will give you an error =>to solve it => must has return type(Future)
       await Future.delayed(Duration(seconds: 2)) ;
        await getNotes() ;
        notesList = SqlDb.notesList! ;
        setState(() {});
      },
      child: Scaffold(
        key: scaffoldKey,
          // backgroundColor: Colors.grey[800],
          appBar: AppBar(
            leading: IconButton(
              onPressed: (){
                scaffoldKey.currentState!.openDrawer() ;
              },
              icon: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: shadowColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                  child: Icon(
                    Icons.menu,size: 33,
                    color: colorIconFore,
                  ),
              ),
            ),
            title: const Text(
              "Note App",
              style: TextStyle(
                  fontFamily: "LoraRegular", fontSize: 30, letterSpacing: 4),
            ),
            // backgroundColor: Colors.black,
            actions: [
              IconButton(
                  onPressed: ()async{
                    await getNotes() ;
                  },
                  icon: Container(
                    width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: shadowColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.sort,
                        size: 33,
                        color: colorIconFore,
                      ),
                  ),
              ),
            ],
          ),
          drawer: Drawer(
              elevation: 10,
              shadowColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(200),
                    topLeft: Radius.circular(200),
                    bottomLeft: Radius.circular(200),
                    bottomRight: Radius.circular(200)
                ),
              ),
              child: ListView(
                children: [
                  Container(
                    height: 300,
                    child: Image(
                      image: AssetImage(img),
                    fit:BoxFit.cover,
                    ),

                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10 ,right: 10),
                    child:Column(
                     children :[
                       SizedBox(
                         height: 45,
                       ),
                  ListTile(
                    title: Text("Mode" ,style: TextStyle(
                        fontSize: 25,fontWeight: FontWeight.w700 ,fontFamily: "LoraRegular"
                    ),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 50 ,right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(iconn  ,
                        color:colorr ,
                        ) ,
                        Text(
                          mess,
                          style: TextStyle(
                              fontSize: 17 ,fontWeight: FontWeight.w500 ,fontFamily: "Merriweather"
                          ),),
                        Switch(
                            inactiveTrackColor: Colors.blue[900],
                            activeTrackColor: Colors.orangeAccent,
                            value: status,
                            onChanged: (bool val) {
                              setState(() {
                                status = val;
                                changeTitle() ;
                                MyApp.themeNotifier.value=
                                    MyApp.themeNotifier.value==ThemeMode.light?ThemeMode.dark :ThemeMode.light ;
                              });
                            }
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  ListTile(
                    title: Text("Layout" ,style: TextStyle(
                        fontSize: 25,fontWeight: FontWeight.w700 ,fontFamily: "LoraRegular" ,
                    ),),
                  ),
                       Padding(
                         padding: const EdgeInsets.only(left: 50 ),
                         child: RadioListTile(
                             title:Text(
                               "List View",
                               style: TextStyle(
                                   fontSize: 17 ,fontWeight: FontWeight.w500,fontFamily: "Merriweather"
                               ),),
                           value: "list",
                           groupValue: currentView,
                           onChanged: (val){
                               setState(() {
                                 currentView =val! ;
                               });
                           },
                         ),
                       ),
                       SizedBox(
                         height: 15,
                       ),
                       Padding(
                         padding: const EdgeInsets.only(left: 50 ),
                         child: RadioListTile(
                            title: Text(
                               "Grid View",
                               style: TextStyle(
                                   fontSize: 17 ,fontWeight: FontWeight.w500 ,fontFamily: "Merriweather"
                               ),),
                           value: "grid",
                           groupValue: currentView,
                           onChanged: (val){
                              setState(() {
                                currentView =val! ;
                              });
                           },
                         ),
                       ),
               ],
                    ),
                  ),
                ],
              ),
            ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(right: 28 ,bottom: 10),
            child: FloatingActionButton(
              foregroundColor:colorFloatingFore,
              backgroundColor: colorFloating,
              onPressed: () async {
                //  we set null when insert new data ,
                //  we make id as a parameter to use when
                //  we update data in certain id
                bottomSheet(null);
              },
              child: const Icon(Icons.add ,size: 30),
            ),
          ),
          body: Container(
            margin: EdgeInsets.only(top: 5),
            // padding: EdgeInsets.only(top: 5),
            // color: Colors.black,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.only(left: 30, right: 30),
                  height: 40,
                  child: Center(
                    child: TextField(
                      onTap: (){
                        showSearch(context: context, delegate: customSearch(context ,currentView!)) ;
                      },
                      style: TextStyle(
                          // color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                          hintText: "Search notes ...",
                          // hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(
                            Icons.search,
                            // color: Colors.grey,
                          ),
                          // fillColor: Colors.grey.shade700,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(color: Colors.transparent),
                          )),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                child: notesList.isEmpty ?
                  noNotes() : currentView=="list" ?
                 listView() : gridView()
          ),
              ],
            ),
          ),)
    );
  }

  listView(){
    return  Expanded(
        child: ListView.builder(itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17 ,vertical: 6),
            child: NoteElement(notesMap: notesList[index],
                openBottomSheetCallback: openBottomSheet,
                notesList: notesList ,currentView: currentView,),
          );
        }, itemCount: notesList.length
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
              child: NoteElement(notesMap: notesList[index],
                    openBottomSheetCallback: openBottomSheet,
                    notesList: notesList ,currentView: currentView
              ),
            );
          }, itemCount: notesList.length
          ),
    ) ;
  }

  saveNotes() async {
    DateTime currentTime =DateTime.now() ;
    createdAt =currentTime.toString() ;
    await SqlDb.insertData(
        title: titleController.text,
        note:noteController.text,
      createdAt: createdAt ,
    );
    getNotes() ;
  }
  getNotes() async {
    final data =await SqlDb.getData() ;
    setState(() {
      notesList=data ;
    });
  }
  updateNotes(int id) async{
    await SqlDb.updateDataById(
         id , titleController.text, noteController.text
    );
    getNotes();
  }
   noNotes(){
    return Expanded(
      child: ListView(
        children: [
          SizedBox(
            height: 50,
          ),
         Padding(
           padding: const EdgeInsets.only(left: 20 ,right: 20),
           child: Image.asset("assests/note5.png"),
         ) ,
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text("No notes " ,style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.w800,
            ),),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Text("Create a note and it will show up here." ,style: TextStyle(
              fontSize: 20 ,fontWeight: FontWeight.w400 ,
            ),),
          )
        ],
      ),
    );
  }
}
