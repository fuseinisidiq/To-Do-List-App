import 'package:flutter/material.dart';
import 'package:todo_final/todo_item.dart';

import 'database/db.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DB.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Todo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        
        primaryColor: const Color.fromRGBO(58, 66, 86, 1.0),
        accentColor: const Color.fromRGBO(209, 224, 224, 0.2),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

 

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ToDoItem> _todo = [];
  List <Widget> get _items => _todo.map((item) => format(item)).toList();
  late String _name;
   Widget format(ToDoItem item){
     return Padding(
      padding:const EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Dismissible(
        key: Key(item.id.toString()), 
        child:Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Theme.of(context).accentColor,
            shape: BoxShape.rectangle,
            boxShadow: <BoxShadow>[
              const BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0.0, 10)
              )
            ]

           ),
           child: Row(children: <Widget>[
            Expanded(
            child: Text(item.name!, style: const TextStyle(color: Colors.white, fontSize: 16)),
            ),
           ]
        ) ,
        ),
        onDismissed: (DismissDirection d) {
          DB.delete(ToDoItem.table, item);
          refresh();
          
        },
         ),
     );
   }
  
  void _create(BuildContext context){
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add Item"),
          content: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  autofocus: true,
                  decoration: const InputDecoration(labelText: 'Item Name'),
                  onChanged: (name) {_name = name;} ,
                )

            ],
            )
            ),
            actions: <Widget>[
              ElevatedButton(onPressed: ()=> _save(), 
              child: const Text('Save')),
              // FlatButton(
              //    onPressed: () =>  _save(), 
              //     child: Text("save") )
            ],
        );
        
      }
      
      );
      
  }

  void _save() async {
    Navigator.of(context).pop();
    ToDoItem item = ToDoItem(
       name: _name,  
       
       );

       await DB.insert(ToDoItem.table, item);
       setState(() => _name = '');
       refresh();
  }

  void initState(){
    refresh();
    super.initState();
  }

void refresh() async {
  List<Map<String, dynamic>> _results = await DB.query(ToDoItem.table);
  _todo = _results.map((item) => ToDoItem.fromMap(item)).toList();
  setState(() {});
}


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
     child: ListView(
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 0, 10),
          child: 
          Text("To Do", 
          style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
          ), 
          ),
          ListView(
            children: _items,
            shrinkWrap: true,
          )
      ],
     ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent ,
        onPressed: () => _create(context),
        child: const Icon(Icons.add, color: Colors.white,),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  
}




