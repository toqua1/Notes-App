import 'dart:math';
import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'images.dart';

class NoteView extends StatefulWidget {
  NoteView({super.key ,required this.notesMap});
Map notesMap ;

  @override
  State<NoteView> createState() => _NoteViewState();
}
class _NoteViewState extends State<NoteView> {
  randomImage(){
    Random random =Random();
    return images[random.nextInt(images.length)] ;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Stack(
        children : [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(randomImage()),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 35.0),
                child: IconButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Home(),
                        ),
                      );
                      setState(() {

                      });
                    },
                    icon: Container(
                      width: 50,
                        height: 50,
                        decoration:BoxDecoration(
                          color: Colors.black54.withOpacity(.3),
                          borderRadius: BorderRadius.circular(15) ,
                        ),
                        child: Icon(Icons.arrow_back_ios_new ,size: 30,)),
                  ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 35.0),
                child: IconButton(
                    onPressed: (){
                       randomImage() ;
                       setState(() {

                       });
                }, icon:
                Container(
                    width: 50,
                    height: 50,
                    decoration:BoxDecoration(
                      color: Colors.black54.withOpacity(.3),
                      borderRadius: BorderRadius.circular(15) ,
                    ),
                    child: Icon(Icons.sort ,size: 30,)),
                ),
              ),
            ],
          ),
         Container(
          padding: EdgeInsets.only(top: 20 ,bottom: 10 ,left: 25 ,right: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top:90.0),
                child: Center(
                  child: Text(widget.notesMap['title'],style: const TextStyle(
                      fontSize: 45,fontWeight: FontWeight.w800 ,color: Colors.black,fontFamily:"serif" ,
                    ),),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(widget.notesMap['createdAt'], style: TextStyle(
                  fontSize: 15 ,fontWeight: FontWeight.w400 ,color: Colors.grey[800] ,fontFamily:"Merriweather"
              ),),
              SizedBox(
                height: 40,
              ),
             Text(widget.notesMap['note'] ,style: TextStyle(
                  fontSize: 25,fontWeight: FontWeight.w500 ,fontFamily:"serif" ,color: Colors.black
                ),),
            ],
          ),
        ),
    ],
      ),
    );
  }
}
