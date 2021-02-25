import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterblogapp/Authentication.dart';
import 'package:flutterblogapp/PhotoUpload.dart';
import 'package:flutterblogapp/Posts.dart';
import 'package:firebase_database/firebase_database.dart';

class HomePage extends StatefulWidget {
  HomePage({this.auth,this.onSignedOut});
  final AuthImplementation auth;
  final VoidCallback onSignedOut;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  List<Posts> postsList=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DatabaseReference postsRef = FirebaseDatabase.instance.reference().child("Posts");
    postsRef.once().then((DataSnapshot snap)
        {
          var KEYS = snap.value.keys;
          var DATA = snap.value;

          postsList.clear();
          for(var individualKey in KEYS )
            {
              Posts posts=Posts(
                DATA[individualKey]['image'],
                DATA[individualKey]['description'],
                DATA[individualKey]['date'],
                DATA[individualKey]['time'],
              );
              postsList.add(posts);
            }
          setState(() {
            print('Length: $postsList.length' );
          });
        }
    );
  }


  void _logoutUser() async
  {
    try{
      await widget.auth.signOut();
      widget.onSignedOut();
    }
    catch(e)
    {
      print("Error "+e.toString());
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Blog App'),
      ),
      body: Container(
        child: postsList.length == 0 ? Text('No Blog Post Available'):ListView.builder
          (
          itemCount: postsList.length,
          itemBuilder: (_,index)
          {
            return PostsUI(postsList[index].image,postsList[index].description,postsList[index].date,postsList[index].time);
          }
        ),

      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.deepPurpleAccent,
        child: Container(
          margin: const EdgeInsets.only(left: 70.0,right: 70.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              IconButton(
                icon:Icon(Icons.account_circle,size: 40.0,color: Colors.white,) ,
                onPressed: _logoutUser,
              ),
              IconButton(
                icon:Icon(Icons.add_a_photo,size: 40.0,color: Colors.white,),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder:(context)
                    {
                      return UploadPhotoPage();
                    },)
                  );
                },
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget PostsUI(String image,String description, String date, String time)
  {
    return Card(
      elevation: 10.0,
      margin: EdgeInsets.all(15.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  date,
                  style: Theme.of(context).textTheme.subtitle,
                  textAlign: TextAlign.center,
                ),

                Text(
                  time,
                  style: Theme.of(context).textTheme.subtitle,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(height: 10.0,),
            Image.network(image,fit:BoxFit.cover),
            SizedBox(height: 10.0,),
            Text(
              description,
              style: Theme.of(context).textTheme.subhead,
              textAlign: TextAlign.center,
            ),


          ],
        ),
      ),

    );
  }
}
