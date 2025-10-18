import 'package:ast_firebase/consts.dart';
import 'package:ast_firebase/screens/groups/edit_screen.dart';
import 'package:ast_firebase/screens/students/students_screen.dart';
import 'package:ast_firebase/ui_helpers.dart';
import 'package:ast_firebase/widgets/group_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<QueryDocumentSnapshot> data = [];
  List<QueryDocumentSnapshot> filteredData = []; 
  final _searchController = TextEditingController();
  

  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('groups')
    .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
    .get();
    data.clear();
    data.addAll(querySnapshot.docs);
    filteredData = data;
     setState(() {});
     }
void filterData(String query){
  if(query.isEmpty){
    filteredData = data;
  }else{
    filteredData = data
    .where((group) =>
      group['name'].toString().toLowerCase().contains(query.toLowerCase()))
      .toList();
  }
  setState((){});
}


  @override
  void initState() {
    super.initState();
    getData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
 appBar: AppBar(
  automaticallyImplyLeading: false,
  title: ListTile(
    title:  Text('Home Screen '),
    subtitle: Text(FirebaseAuth.instance.currentUser?.email ?? ''),
  ),
        actions: [
          IconButton(onPressed: ()async{
          await FirebaseAuth.instance.signOut();
          Navigator.pushReplacementNamed(context, 'login');
          }, icon: Icon(Icons.logout))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, 'add_group'),
        backgroundColor: primaryBtnColor,
        child: Icon(Icons.add,color: Colors.white,),
        ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Searching....',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                )
              ),
              onChanged:(value) {
               filterData(value);
              },
            ),
          ),
          Expanded(
            child:filteredData.isEmpty
            ? Center(child : Text('No Data Found'))
            : GridView.builder(
              itemCount: filteredData.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), 
              itemBuilder: (context,index){
                return GroupItem(
                  text: filteredData[index]['name'],
                  nmOfStudents: filteredData[index]['nm_students'],
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> StudentsScreen(documentId: data[index].id,
                     groupName: filteredData[index]['name'], )));
                  },
                  onLongPress: (){
                      UiHelpers.showMyDialog(
                        context: context,
                         title: 'Choose Action please',
                          content: 'Please Choose Action of below choises',
                          onConfirm: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> EditScreen(data: filteredData[index])));
                          },
                          onCancel: () async {
                          await FirebaseFirestore.instance.collection(collectionGroup)
                          .doc(filteredData[index].id).delete();
                          getData();
                          }
                          );
                  },
                );
              }),
          ),
        ],
      ),
    );
      }
}
