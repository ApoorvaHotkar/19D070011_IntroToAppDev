import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

double total_price = 0;

final TextEditingController _targetcontrol = TextEditingController();
Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(
    title: 'Budget Tracking',
    home: LoginPage(),
  ));
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  void initState()
  {
    super.initState();
  }

  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();

  final _auth = FirebaseAuth.instance;


  Future<void> LogIn(BuildContext context)
  async
  {
    try {

      await _auth.signInWithEmailAndPassword(email: _emailcontroller.text, password: _passwordcontroller.text);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomePage()
      )
      );

      _emailcontroller.text = '';
      _passwordcontroller.text = '';

    } catch (e) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const LoginFailure()
      )
      );

      _emailcontroller.text = '';
      _passwordcontroller.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget Tracking Login Page',
      home: Scaffold(

        appBar: AppBar(
          centerTitle: true,
          title: const Text('Budget Tracking Login Page'),

        ),

        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              Text("Email", style: TextStyle(fontSize: 30, color: Colors.black)),
              TextField(controller: _emailcontroller, decoration: InputDecoration(hintText: "Enter Email"),),
              Text("Password", style: TextStyle(fontSize: 30, color: Colors.black)),
              TextField(controller: _passwordcontroller, decoration: InputDecoration(hintText: "Enter Password"), keyboardType: TextInputType.number,),

              ElevatedButton(onPressed: () => LogIn(context), child: Text("Log In"))


            ],
          ),
        ),
      ),
    );

  }
}

class LoginFailure extends StatefulWidget {
  const LoginFailure({super.key});

  @override
  State<LoginFailure> createState() => _LoginFailureState();
}

class _LoginFailureState extends State<LoginFailure> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Budget Tracking',
        home: Scaffold(

            appBar: AppBar(
              centerTitle: true,
              title: const Text('Login Failure'),
              leading: IconButton(onPressed: () => _goback(context), icon: Icon(Icons.arrow_back_rounded)),
            ),
            body:
            Text("Please enter correct login credentials", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red,fontSize: 30),),
        )
    );
  }
}




class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CollectionReference _categories = FirebaseFirestore.instance.collection('categories');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_total();
  }
  
  void get_total()
  {
    FirebaseFirestore.instance.collection("categories").snapshots().listen((snapshot) {
      double temptot = snapshot.docs.fold(0, (tot_price, doc) => tot_price + doc['Price']);
      setState(() {
        total_price = temptot;
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Budget Tracking',
        home: Scaffold(

            appBar: AppBar(
              centerTitle: true,
              title: const Text('Budget Tracking'),
              leading: IconButton(onPressed: () => _goback(context), icon: Icon(Icons.arrow_back_rounded)),
            ),
            body:
            Container(
              height: double.infinity,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [first_page_first_row, first_page_second_row, first_page_third_row(context), first_page_fourth_row(context)],
              ),
            )
        )
    );

  }
}

class GoalsPage extends StatefulWidget {
  const GoalsPage({super.key});

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Budget Tracking',
        home: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Goals Page'),
            leading: IconButton(onPressed: () => _goback(context), icon: Icon(Icons.arrow_back_rounded)),
          ),
          body:
          Container(
              height: double.infinity,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [goals_page_first_row, goals_page_second_row,
                Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 50,
                child: ElevatedButton(onPressed: () => _checkgoals(context), child: Text("Check your Goal!"),)
                ),
                Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 50,
                child: ElevatedButton(onPressed: () => _logout(context), child: Text("Logout"),)
                )
                ]


        )
    )
        )
    );
  }
}


class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  final CollectionReference _categories = FirebaseFirestore.instance.collection("categories");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_total();
  }

  void get_total()
  {
    FirebaseFirestore.instance.collection("categories").snapshots().listen((snapshot) {
      double temptot = snapshot.docs.fold(0, (tot_price, doc) => tot_price + doc['Price']);
      setState(() {
        total_price = temptot;
      });
    });
  }

  final TextEditingController _categorycontrol = TextEditingController();
  final TextEditingController _pricecontrol = TextEditingController();

  Future<void> create_category([DocumentSnapshot? documentSnapshot])
  async{

    await showModalBottomSheet(isScrollControlled:true, context: context,
        builder: (BuildContext ctx)
        {
          return Padding(padding: EdgeInsets.only(
            top:20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),

            child: Column(

              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Category Name",style: TextStyle(fontSize: 25,color: Colors.blue)),
                TextField(
                  controller: _categorycontrol,
                ),
                Text("Category Price",style: TextStyle(fontSize: 25, color: Colors.blue)),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _pricecontrol,
                ),

                ElevatedButton(
                  child: Text("Create Category"),
                  onPressed: () async {
                    final String cat = _categorycontrol.text;
                    final double price = double.parse(_pricecontrol.text);

                    if (price != null) {
                      await _categories.add({"Category": cat, "Price": price});

                      _categorycontrol.text = '';
                      _pricecontrol.text = '';
                      Navigator.of(context).pop();
                    }
                  }
                )
              ],
            )
          );
        }

        );
  }

  Future<void> delete_category(String catid)
  async
  {
    await _categories.doc(catid).delete();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Budget Tracking',
        home: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text('Budget Tracking'),
              leading: IconButton(onPressed: () => _goback(context), icon: Icon(Icons.arrow_back_rounded)),
            ),
            body:
            Container(
              height: double.infinity,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  Flexible(
                      flex: 100,
                      child:  ListTile(
                        title: Text('Total: $total_price', style: TextStyle(fontSize: 30)),
                          trailing: IconButton
                            (onPressed : () => _gotosecondpage(context),
                              icon: Icon(Icons.arrow_drop_down_circle_rounded)
                          ),
                      )
                  ),

                  Flexible(
                      flex: 800,
                      child: StreamBuilder(
                        stream: _categories.snapshots(),
                        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot)
                        {
                        if(streamSnapshot.hasData)
                        {
                          return ListView.builder(
                            itemCount: streamSnapshot.data!.docs.length,
                            itemBuilder: (context,index)
                            {
                              final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];

                              return Dismissible(
                                key: UniqueKey(),

                                child: ListTile(
                                  title: Text(documentSnapshot['Category'] + ":  " + documentSnapshot['Price'].toString(),style: TextStyle(fontSize: 25,color: Colors.red, fontWeight: FontWeight.bold)),
                                ),
                                onDismissed: (DismissDirection direction) {
                                  setState(() {
                                    delete_category(documentSnapshot.id);
                                  });
                                },
                              );
                              },
                            );
                          }

                          return Center(
                            child: CircularProgressIndicator(),
                          );
                          },
                        ),
                        ),
                      ],
                  )
                  ),
                floatingActionButton: FloatingActionButton
                  (onPressed: () => create_category(),
                   child: Icon(Icons.add),
                  ),
                )
    );
    
  }
}




Widget first_page_first_row = Container(
  height: 100,
  width: 100,
  child: Icon(
    Icons.account_circle_sharp,
    color: Colors.blue,
    size:100,
  ),
);


Widget first_page_second_row = Container(
  alignment: Alignment.center,
  width: double.infinity,
  height: 50,
  child: Text("Welcome Back!!",
    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.blue),
  ),
);


Widget first_page_third_row(BuildContext context) {
  return ListTile(
    title: Text('Total: $total_price', style: TextStyle(fontSize: 30),),
    trailing: IconButton
      (onPressed : () => _gotosecondpage(context),
        icon: Icon(Icons.arrow_drop_down_circle_rounded)
    ),
  );
}

Widget first_page_fourth_row(BuildContext context) {
  return ElevatedButton(onPressed:() => _gotogoalspage(context), child: Text("Goals"));
}

Widget goals_page_first_row = Container(
  alignment: Alignment.center,
  width: double.infinity,
  height: 50,
  child: Text("Enter your target savings",
    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
  ),
);

Widget goals_page_second_row = Container(
  alignment: Alignment.center,
  width: double.infinity,
  height: 50,
  child: TextField(
    controller: _targetcontrol,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(hintText: "Enter yor target savings")
  ),
);


void _gotogoalspage(BuildContext context)
{
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => const GoalsPage()
  )
  );
}

void _gotosecondpage(BuildContext context)
{
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => const SecondPage()
  )
  );
}

void _goback(BuildContext context)
{
  Navigator.pop(context);
}

void _logout(BuildContext context)
{
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => const LoginPage()
  )
  );
}

Future<void> _dialogBuilder_totalless(BuildContext context, double goal_price) {

  double diff_tot = (total_price - goal_price).abs();
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('How far you are from your goal?'),
        content:  Text(
          'You are Rs. $diff_tot away from your goal!!',
          style: TextStyle(color: Colors.red, fontSize: 20),
        ),
      );
    },
  );
}

Future<void> _dialogBuilder_totalsatisfied(BuildContext context) {

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('How far you are from your goal?'),
        content: const Text(
          'Congrats!! You have reached your target savings!!!',
          style: TextStyle(color: Colors.green, fontSize: 20),
        ),
      );
    },
  );
}

void _checkgoals(BuildContext context)
{
  if(double.parse(_targetcontrol.text) > total_price)
    {
      _dialogBuilder_totalless(context, double.parse(_targetcontrol.text));
    }

  else
    {
      _dialogBuilder_totalsatisfied(context);
    }
}