import 'package:ast_firebase/ui_helpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  CollectionReference groups = FirebaseFirestore.instance.collection('groups');

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _nmStudentsController = TextEditingController();
  
  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _nmStudentsController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Group'
        ),
      ),
      body: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Enter name ...',
                  border: OutlineInputBorder(),
                ),
                validator: (value){
                  if(value == null || value.isEmpty){
                    return "Field can't be empty";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20,),
               TextFormField(
                controller: _nmStudentsController,
                decoration: InputDecoration(
                  labelText: 'Enter nm of students ...',
                  border: OutlineInputBorder(),
                ),
                validator: (value){
                  if(value == null || value.isEmpty){
                    return "Field can't be empty";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () async {
                if(_formKey.currentState!.validate()){
                  await addGroup();
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
              'Adding Group',
                style: TextStyle(color: Colors.white),
             )
             )
            ],
          )
          ),
         ),
    );
  }


  Future<void> addGroup(){
   return groups.add({
      'id' : FirebaseAuth.instance.currentUser!.uid, 
      'name' : _nameController.text,
      'nm_students' : int.parse(_nmStudentsController.text),
      })
      .then((value) => UiHelpers.showSnackBar(context, 'Group Added'))
      .catchError((error)=> UiHelpers.showSnackBar(context, 'Error while adding group: $error'));
  }
}
