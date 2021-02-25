import 'package:flutter/material.dart';
import 'Authentication.dart';
import 'package:flutterblogapp/DialogBox.dart';
class LoginRegisterPage extends StatefulWidget {
  LoginRegisterPage({this.auth,this.onSignedIn});
  final AuthImplementation auth;
  final VoidCallback onSignedIn;
  @override
  _LoginRegisterPageState createState() => _LoginRegisterPageState();
}
enum FormType
{
  login,
  register
}


class _LoginRegisterPageState extends State<LoginRegisterPage> {
DialogBox dialogBox = DialogBox();
  final formKey = GlobalKey<FormState>();
  FormType _formType=FormType.login;
  String email="";
  String password="";

  bool validateAndSave()
  {
    final form = formKey.currentState;
    if(form.validate())
      {
        form.save();
        return true;
      }
    else
      {
        return false;
      }

  }

  void validateAndSubmit() async
  {
    if(validateAndSave())
      {
        try{
          if(_formType == FormType.login)
            {
              String userId= await widget.auth.signIn(email, password);
            //  dialogBox.information(context, "Congratulations","Your are logged in successfully");
              print("login userId= "+ userId);
            }
          else
            {
              String userId= await widget.auth.signUp(email, password);
             // dialogBox.information(context, "Congratulations","Your account has been created successfully");
              print("Registered userId= "+ userId);
            }
          widget.onSignedIn();
        }
        catch(e)
    {
      dialogBox.information(context, "Error", e.toString());

    }
      }
  }




  void moveToRegister(){
formKey.currentState.reset();
setState(() {
  _formType=FormType.register;
});
  }

  void moveToLogin(){
    formKey.currentState.reset();
    setState(() {
      _formType=FormType.login;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Blog App'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: createInputs() + createButtons(),
            ),
            
          ),
        ),
      ),
    );
  }
  List<Widget> createInputs()
  {
   return
   [
     SizedBox(
       height:10.0
     ),
     logo(),
     SizedBox(
       height: 20.0,
     ),
     TextFormField(
    decoration: InputDecoration(
      labelText: 'Email'
    ),
       validator: (value){
      return value.isEmpty?'Email is required':null;
       },
       onSaved: (value)
       {
         return email=value;
       },
     ),
     SizedBox(
         height:10.0
     ),
     TextFormField(
       decoration: InputDecoration(
           labelText: 'Password'
       ),
       obscureText: true,
       validator: (value){
         return value.isEmpty?'Password is required':null;
       },
       onSaved: (value)
       {
         return password=value;
       },
     ),
     SizedBox(
       height: 20.0,
     ),
   ] ;   
  }
  Widget logo()
  {
    return Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 110.0,
        child: Image.asset('images/Deadpool4.jpg'),
      ),
    );
  }
  List<Widget> createButtons()
  {
    if(_formType == FormType.login)
      {
        return
          [
            RaisedButton(
              onPressed: validateAndSubmit,
              child: Text(
                'login',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              textColor: Colors.white,
              color: Colors.lightBlueAccent,
            ),
            FlatButton(
              onPressed: moveToRegister,
              child: Text(
                'Not have an account?Create Account',
                style: TextStyle(
                    fontSize: 20.0
                ),
              ),
              textColor: Colors.lightBlueAccent,


            )
          ] ;
      }
    else
      {
        return
          [
            RaisedButton(
              onPressed: validateAndSubmit,
              child: Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              textColor: Colors.white,
              color: Colors.lightBlueAccent,
            ),
            FlatButton(
              onPressed: moveToLogin,
              child: Text(
                'Already have an Account? Login',
                style: TextStyle(
                    fontSize: 20.0
                ),
              ),
              textColor: Colors.lightBlueAccent,


            )
          ] ;
      }
  }
}

