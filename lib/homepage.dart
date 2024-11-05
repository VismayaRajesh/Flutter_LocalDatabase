import 'package:database_sqlflite/dbhelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'model.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController namecntrl = TextEditingController();
  TextEditingController phcntrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar : AppBar(),
        body: Form(
          key: formkey,
          child: Column(
            children: [
              TextFormField(
                controller: namecntrl,
                decoration: InputDecoration(
                  hintText: "Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value){
                  if(value == null || value.isEmpty){
                    return "please enter a name";
                  }
                  else {
                    return null;
                  }
                },
              ),
              TextFormField(
                controller: phcntrl,
                decoration: InputDecoration(
                  hintText: "PhoneNumber",
                  border: OutlineInputBorder()
                ),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return "please enter a name";
                    }
                    else if(value.length != 10){
                      return "please enter 10 digit phone number";
                    }
                    else {
                      return null;
                    }
                  }
              ),
              ElevatedButton(onPressed: (){
                if(formkey.currentState!.validate()){
                  User u = User(name : namecntrl.text, phonenumber : phcntrl.text);
                  databaseHelper.insertuser(u).then((onValue){
                    namecntrl.clear();
                    phcntrl.clear();
                });
                }

              }, child: Text("Submit")),
              Flexible(child: FutureBuilder(future: databaseHelper.getall(),
                builder: (BuildContext context, AsyncSnapshot<List<User>?> snapshot) {
                if(snapshot.hasError){
                  return Center(child: Text("Something went worng ${snapshot.error}"));
                }
                else if(snapshot.hasData){
                  return ListView.builder(itemCount: snapshot.data?.length, itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: CircleAvatar(child: Text('${snapshot.data![index].id}',),),
                      title: Text("${snapshot.data![index].name}"),
                      subtitle: Text("${snapshot.data![index].phonenumber}"),
                      trailing: Stack(
                        children: [
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red, size: 18,),
                            onPressed: () async {
                              await databaseHelper.deleteuser(snapshot.data![index]);
                              setState(() {}); // Refresh the list after deletion
                            },
                          ),
                          Positioned(
                            top: 16,
                            child: IconButton(onPressed: (){
                              showdialog(snapshot.data![index]);
                            }, icon: Icon(Icons.edit, size: 15,),),
                          )
                        ],
                      ),
                    );
                  },);
                }
                else{
                  return CircularProgressIndicator();
                }
                },)),
            ],
          ),
        ),
      ),
    );
  }

  void showdialog(User user) {
    TextEditingController name = TextEditingController();
    TextEditingController ph = TextEditingController();
    name.text = user.name;
    ph.text = user.phonenumber;

    AlertDialog alert = AlertDialog(
      title: Text("Edit"),
      content: Column(
        children: [
          TextField(
            controller: name,
            decoration: InputDecoration(),
          ),
          TextField(
            controller: ph,
            decoration: InputDecoration(),
          )
        ],
      ),
      actions: [
        ElevatedButton(onPressed: () async {
          User u = User(name: namecntrl.text, phonenumber: phcntrl.text);
          await databaseHelper.updateuser(u);
          setState(() {

          });
          Navigator.pop(context);
        }, child: Text('Update'))
      ],
    );
    showDialog(context: context, builder: (BuildContext context) {
      return alert;
    },);
  }
}


