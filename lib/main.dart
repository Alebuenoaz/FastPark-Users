import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: MyHomePage(title: 'Flutter Demo Home Page'),
      initialRoute: Home.id,
      routes: {
        MyHomePage.id: (context) => MyHomePage(),
        Home.id: (context) => Home(),
        Register.id: (context) => Register(),
        Login.id: (context) => Login(),
        MainPage.id: (context) => MainPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  static const String id = "HOMESCREEN";
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final databaseReference = Firestore.instance;
  int _counter = 0;

  void _createRecord() async {
    _counter++;
    await databaseReference.collection("parqueos").document("1").setData({
      'title': 'Chupate esa Drope',
      'description': 'Parece que funciona Firebase'
    });

    DocumentReference ref = await databaseReference.collection("parqueos").add({
      'title': 'parqueo' + _counter.toString(),
      'description': 'Descripcion del parqueo nro ' + _counter.toString()
    });
    print(ref.documentID);
  }

  void _getData() {
    databaseReference
        .collection("parqueos")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) => print('${f.data}}'));
    });
  }

  void _updateData() {
    try {
      databaseReference
          .collection('parqueos')
          .document('1')
          .updateData({'description': 'Seguila chupando Drope'});
    } catch (e) {
      print(e.toString());
    }
  }

  void _deleteData() {
    try {
      databaseReference.collection('parqueos').document('1').delete();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FireStore Demo'),
      ),
      body: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          RaisedButton(
            child: Text('Create'),
            onPressed: _createRecord,
          ),
          RaisedButton(
            child: Text('Read'),
            onPressed: _getData,
          ),
          RaisedButton(
            child: Text('Update'),
            onPressed: _updateData,
          ),
          RaisedButton(
            child: Text('Delete'),
            onPressed: _deleteData,
          ),
        ],
      )), //center
    );
  }
}

class Home extends StatelessWidget {
  static const String id = "HOME";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          RaisedButton(
            child: Text('Log In'),
            onPressed: () {
              Navigator.of(context).pushNamed(Login.id);
            },
          ),
          RaisedButton(
            child: Text('Register'),
            onPressed: () {
              Navigator.of(context).pushNamed(Register.id);
            },
          ),
          RaisedButton(
            child: Text('Nobo'),
            onPressed: () {
              Navigator.of(context).pushNamed(MyHomePage.id);
            },
          ),
        ],
      ),
    );
  }
}

class Register extends StatefulWidget {
  static const String id = "REGISTRATION";
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String email;
  String password;
  String name;
  String uid;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference databaseReference =
      Firestore.instance.collection('users');

  Future<void> registerUser() async {
    AuthResult result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    FirebaseUser user = result.user;
    uid = user.uid;
    print("Usuario registrado " + result.user.email);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MainPage(
          user: result,
        ),
      ),
    );
  }

  Future<void> createUser(String name, String email, String uid) async {
    return await databaseReference.document(uid).setData({
      'name': name,
      'email': email,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) => email = value,
            decoration: InputDecoration(
              hintText: "Enter Your Email...",
              border: const OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 40.0,
          ),
          TextField(
            autocorrect: false,
            obscureText: true,
            onChanged: (value) => password = value,
            decoration: InputDecoration(
              hintText: "Enter Your Password...",
              border: const OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 40.0,
          ),
          TextField(
            autocorrect: false,
            obscureText: false,
            onChanged: (value) => name = value,
            decoration: InputDecoration(
              hintText: "Enter Your Name...",
              border: const OutlineInputBorder(),
            ),
          ),
          RaisedButton(
            child: Text('Register'),
            onPressed: () async {
              await registerUser();
              await createUser(name, email, uid);
            },
          ),
        ],
      ),
    );
  }
}

class Login extends StatefulWidget {
  static const String id = "LOGIN";

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email;
  String password;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> loginUser() async {
    AuthResult user = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    print("Usuario " + user.user.email);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MainPage(
          user: user,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) => email = value,
            decoration: InputDecoration(
              hintText: "Enter Your Email...",
              border: const OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 40.0,
          ),
          TextField(
            autocorrect: false,
            obscureText: true,
            onChanged: (value) => password = value,
            decoration: InputDecoration(
              hintText: "Enter Your Password...",
              border: const OutlineInputBorder(),
            ),
          ),
          RaisedButton(
            child: Text('Log In'),
            onPressed: () async {
              await loginUser();
            },
          ),
        ],
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  static const String id = "MAIN";
  final AuthResult user;

  const MainPage({Key key, this.user}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  /*
  //trying to read user info by id form firestore
 Future<Group> getGroupInfo(String groupId) async {
    var document =
        Firestore.instance.collection("group").document(groupId).get();
    return await document.then((doc) {
      return Group.setGroup(doc);
    });
  }
*/
  String name;

  getdata() async {
    DocumentSnapshot variable = await Firestore.instance
        .collection('users')
        .document(widget.user.user.uid)
        .get();

    name = variable.data['name'];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: getdata(), // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // AsyncSnapshot<Your object type>
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text('Please wait its loading...'));
        } else {
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          else
            return Scaffold(
              appBar: AppBar(
                title: Text(
                    widget.user.user.email + " \n " + widget.user.user.uid),
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                      hintText: "User name: " + getdata().toString(),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            );
        }
      },
    );
  }
}
