import 'package:ast_firebase/consts.dart';
import 'package:ast_firebase/ui_helpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditScreen extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> data;
  const EditScreen({super.key, required this.data});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _studentsNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _groupNameController.text = widget.data['name'];
    _studentsNumberController.text = widget.data['nm_students'].toString();
  }
  
  @override
  void dispose() {
    super.dispose();
    _groupNameController.dispose();
    _studentsNumberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Group'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _groupNameController,
                decoration: InputDecoration(
                  labelText: 'Enter Group name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if(value == null || value.isEmpty){
                    return "Field Can't be empty";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: _studentsNumberController,
                decoration: InputDecoration(
                  labelText: 'Enter Group name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if(value == null || value.isEmpty){
                    return "Field Can't be empty";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20,),
               Container(
                width: double.infinity,
                 child: ElevatedButton(
                  onPressed: () async {      
                  if(_formKey.currentState!.validate()){
                    await editGroup();
                    Navigator.pushReplacementNamed(context, 'home');
                  }
                               },
                 style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrangeAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(15),
                    ),
                    ),
                              child: Text(
                               'Edit Group',
                  style: TextStyle(color: Colors.white),
                              )
                              ),
               )
            ],
          )
          ),
        ),
    );
  }
  
  Future<void> editGroup() async {
   FirebaseFirestore.instance.collection(collectionGroup)
    .doc(widget.data.id).update({
      'name' : _groupNameController.text , 
      'nm_students' : int.parse(_studentsNumberController.text)
    })
    .then((value)=> UiHelpers.showSnackBar(context, 'Group Edited'))
    .catchError((error)=> UiHelpers.showSnackBar(context, 'Failed to Edit Groups'));
  }
  
}